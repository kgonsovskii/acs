#ifndef HDR_TSS_HTTPSRV
#define HDR_TSS_HTTPSRV

#pragma once

#include <stdexcept>
#include <vector>
#include <string>
#include <fstream>
#include "websrvapi.h"
#include "exceptmsgs.hpp"
#include "socketsrv.hpp"
#include "socketcli.hpp"
#include "filenameutils.hpp"
#include "dynlib.hpp"

namespace tss
{

class HttpServer;

class HttpSrvClient
{
friend class tss::HttpServer;

public:
	virtual ~HttpSrvClient() {}

private:
	SocketClient _Socket;
	std::string _Collector;
};


class HttpServer
{
public:
	HttpServer(): _IsRunning(false), _RootPath(NULL), _DefDoc(NULL) {}
	virtual ~HttpServer() {}
	void Run(unsigned int Addr, unsigned short Port, const char *RootPath, const char *DefDoc)
	{
		if (! RootPath)
			throw std::logic_error(ERR_MSG_HTTP_SERVER_NO_ROOT_PATH);
		else
		{
			_RootPath = new char[strlen(RootPath) + 1];
			strcpy(_RootPath, RootPath);
		}

		if (DefDoc)
		{
			_DefDoc = new char[strlen(DefDoc) + 1];
			strcpy(_DefDoc, DefDoc);
		}

		try
		{
			_SockSrv.Create();
			_SockSrv.Bind(Addr, Port);
			_SockSrv.Listen();
		}
		catch (...)
		{
			Stop();
			throw;
		}

		_IsRunning = true;
	}

	bool IsRunning() { return _IsRunning; }
	void ProcessRequests(struct timeval *Timeout)
	{
		int r;
		fd_set set;
		bool needClose;
	#ifdef LINUX
		int nfds;
	#endif
		std::vector<HttpSrvClient *>::iterator it;

		FD_ZERO(&set);
		FD_SET(_SockSrv.getDescriptor(), &set);
	#ifdef LINUX
		nfds = _SockSrv.getDescriptor();
	#endif
		it = _Clients.begin();
		while (it != _Clients.end())
		{
			needClose = false;
			try
			{
				FD_SET((*it)->_Socket.getDescriptor(), &set);
	#ifdef LINUX
				if (nfds < (*it)->_Socket.getDescriptor())
					nfds = (*it)->_Socket.getDescriptor();
	#endif
			}
			catch (...)
			{
				needClose = true;
			}
			if (needClose)
				_EraseClient(it);
			else
				++it;
		}
	#ifdef LINUX
		r = select(++nfds, &set, NULL, NULL, Timeout);
	#else
		r = select(0, &set, NULL, NULL, Timeout);
	#endif
		if (r == SOCKET_ERROR)
			throw std::runtime_error(Socket::getErrorDescription(Socket::getErrorCode()));

		if (r == 0)
			return; // timeout.

		if (FD_ISSET(_SockSrv.getDescriptor(), &set))
		{
			SocketServer::AcceptedClientEntry ace;
			_SockSrv.Accept(&ace);
			HttpSrvClient *client = new HttpSrvClient;
			client->_Socket.Create(ace.Descriptor, ace.Addr, ace.Port);
			_Clients.push_back(client);
		}
		else
		{
			char buf[1024];
			it = _Clients.begin();
			while (it != _Clients.end())
			{
				needClose = false;
				try
				{
					if (FD_ISSET((*it)->_Socket.getDescriptor(), &set))
					{
						r = (*it)->_Socket.Receive(buf, sizeof(buf), 0);
						if (r == 0)
							needClose = true;
						else
						{
							(*it)->_Collector.append(buf, r);
							if (_ProcessRequest(*it, buf, sizeof(buf)))
								needClose = true;
						}
					}
				}
				catch (...)
				{
					needClose = true;
				}
				if (needClose)
					_EraseClient(it);
				else
					++it;
			}
		}
	}

	void Stop()
	{
		_IsRunning = false;

		try
		{
			_SockSrv.Close();
		}
		catch (...) {}

		std::vector<HttpSrvClient *>::const_iterator cit = _Clients.begin();
		while (cit != _Clients.end())
		{
			try
			{
				(*cit)->_Socket.Close();
			}
			catch (...) {}

			delete (*cit);

			++cit;
		}
		_Clients.clear();

		if (_RootPath)
		{
			delete [] _RootPath;
			_RootPath = NULL;
		}

		if (_DefDoc)
		{
			delete [] _DefDoc;
			_DefDoc = NULL;
		}
	}

	const char * getRootPath()
	{
		if (! IsRunning())
			throw std::logic_error(ERR_MSG_HTTP_SERVER_NOT_RUNNING);
		return _RootPath;
	}
	const char * getDefDoc()
	{
		if (! IsRunning())
			throw std::logic_error(ERR_MSG_HTTP_SERVER_NOT_RUNNING);
		return _DefDoc;
	}

private:
	bool _IsRunning;
	SocketServer _SockSrv;
	char *_RootPath;
	char *_DefDoc;
	std::vector<HttpSrvClient *> _Clients;
	bool _ProcessRequest(HttpSrvClient* Client, char *buf, int bufSize)
	{
		static const char BAD_REQUEST_TEMPLATE[] =
			"HTTP/1.1 %s\r\n"
			"Content-type: text/html\r\n"
			"\r\n"
			"<html><head><title>%s</title></head><body><h1>%s.</h1></body></html>\n";
		static const char RESPONSE200_TEMPLATE[] = "HTTP/1.1 200 OK\r\n"
			"Content-Type: %s/%s\r\n"
			"Content-Length: %u\r\n"
			"%s"
			"Connection: Close\r\n"
			"\r\n";
		static const char CACHE_CONTROL[] = "Cache-Control: no-cache\r\n";
		static const char RESPONSE400[] = "400 Bad Request";
		static const char RESPONSE501[] = "501 Method Not Implemented";
		static const char RESPONSE404[] = "404 Not Found";
		int r, len, resp_size, ec = 0;
		char method[16], url[256], proto[16];

		if (Client->_Collector.rfind("\r\n\r\n") != std::string::npos)
		{
			if ( (sscanf(Client->_Collector.c_str(), "%15s %255s %15s/\r\n", method, url, proto) != 3) || (strcmp(proto, "HTTP/1.1") != 0) )
				ec = 1;
			else if (strcmp(method, "GET") != 0)
				ec = 2;

			Client->_Collector.clear();

			if (ec != 0)
			{
				switch (ec)
				{
				case 1:
					len = sprintf(buf, BAD_REQUEST_TEMPLATE, RESPONSE400, RESPONSE400, RESPONSE400);
					break;
				case 2:
					len = sprintf(buf, BAD_REQUEST_TEMPLATE, RESPONSE501, RESPONSE501, RESPONSE501);
					break;
				}
				Client->_Socket.Send(buf, len);
			}
			else
			{
				std::string cache_control;
				len = static_cast<int>(strlen(url));
				if (len == 1 && url[0] == '/')
					sprintf(url, "/%s", getDefDoc());
	#ifdef MSWINDOWS
				for (register int i=0; i< len; ++i)
					if (url[i] == '/') url[i] = '\\';
	#endif
				strcpy(buf, url);
				tss::extractFilePath(buf);
				std::string s(buf);
				sprintf(buf, "%cbin%c", tss::PATH_SEPARATOR, tss::PATH_SEPARATOR);
	#ifdef LINUX
				if (strcasecmp(buf, s.c_str()) == 0)
	#else
				if (strcmpi(buf, s.c_str()) == 0)
	#endif
				{
					char *p = strchr(url, '?');
					std::string params;
					if (p)
					{
						params = p + 1;
						memset(p, '\0', 1);
					}
					s = getRootPath();
					s.append(url);
					DynLib dl;
					dl.Open(s.c_str());
	#ifdef MSWINDOWS
					DisableThreadLibraryCalls(static_cast<HMODULE>(dl.getHandle()));
	#endif
					try
					{
						websrvbinext_generate *gen = (websrvbinext_generate *) dl.GetFuncAddr("generate");
						gen(getRootPath(), params.c_str(), url);
					}
					catch (...)
					{
						dl.Close();
						throw;
					}
					dl.Close();
				}
				strcpy(buf, url);
				tss::extractFilePath(buf);
				s = buf;
				sprintf(buf, "%cdyn%c", tss::PATH_SEPARATOR, tss::PATH_SEPARATOR);
	#ifdef LINUX
				if (strcasecmp(s.c_str(), buf) == 0)
	#else
				if (strcmpi(s.c_str(), buf) == 0)
	#endif
					cache_control = CACHE_CONTROL;
				strcpy(buf, getRootPath());
				strcat(buf, url);
				std::ifstream fs;
				fs.open(buf, std::ios::in|std::ios::binary);
				if (fs.is_open())
				{
					try
					{
						fs.seekg(0, std::ios::end);
						resp_size = fs.tellg();
						tss::extractFileExt(buf);
						if (strcmp(buf, ".html") == 0)
							len = sprintf(buf, RESPONSE200_TEMPLATE, "text", "html", resp_size, cache_control.c_str());
						else
						if (strcmp(buf, ".css") == 0)
							len = sprintf(buf, RESPONSE200_TEMPLATE, "text", "css", resp_size, cache_control.c_str());
						else
						if (strcmp(buf, ".jpg") == 0)
							len = sprintf(buf, RESPONSE200_TEMPLATE, "image", "jpeg", resp_size, cache_control.c_str());
						else
						if (strcmp(buf, ".gif") == 0)
							len = sprintf(buf, RESPONSE200_TEMPLATE, "image", "gif", resp_size, cache_control.c_str());
						else
						if (strcmp(buf, ".txt") == 0)
							len = sprintf(buf, RESPONSE200_TEMPLATE, "text", "txt", resp_size, cache_control.c_str());
						else
						if (strcmp(buf, ".bmp") == 0)
							len = sprintf(buf, RESPONSE200_TEMPLATE, "image", "bmp", resp_size, cache_control.c_str());
						else
							len = sprintf(buf, RESPONSE200_TEMPLATE, "application", "binary", resp_size, cache_control.c_str());
						Client->_Socket.Send(buf, len);
						fs.seekg(0);
						while (! fs.eof())
						{	
							fs.read(buf, bufSize);
							r = fs.gcount();
							if (r > 0)
								Client->_Socket.Send(buf, r);
						}
					}
					catch (...)
					{
						fs.close();
						throw;
					}
					fs.close();
				}
				else
				{
					len = sprintf(buf, BAD_REQUEST_TEMPLATE, RESPONSE404, RESPONSE404, RESPONSE404);
					Client->_Socket.Send(buf, len);
				}
			}
			return true;
		}
		return false;
	}

	void _EraseClient(std::vector<HttpSrvClient *>::iterator& it)
	{
		try
		{
			(*it)->_Socket.Close();
		}
		catch (...) {}
		delete (*it);
		it = _Clients.erase(it);
	}
};

}

#endif
