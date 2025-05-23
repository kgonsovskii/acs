#ifndef TSS_INIFILE_HPP_INCLUDED
#define TSS_INIFILE_HPP_INCLUDED

#pragma once

#include "config.hpp"
#ifdef LINUX
#include <cerrno>
#else
#include <windows.h>
#endif
#include <cstdio>
#include <ctype.h>
#include <stdexcept>
#include <functional>
#include <algorithm>
#include <map>
#include <string>
#include <fstream>
#include <boost/format.hpp>
#include <boost/lexical_cast.hpp>
#include "sys.hpp"
#include "file.hpp"

namespace tss {

class IniFile
{
private:
	struct _Less: public std::binary_function<std::string, std::string, bool>
	{
		void tcpy(const std::string& from, std::string& to) const
		{
			to.resize(from.size());
			std::transform(from.begin(), from.end(), to.begin(), &::toupper);
		}
		bool operator()(const std::string& lhs, const std::string& rhs) const
		{
			std::string l;
			tcpy(lhs, l);

			std::string r;
			tcpy(rhs, r);

			return (l < r);
		}
	};

public:
	typedef std::map<std::string, std::string, _Less> SectionParams;
	typedef std::map<std::string, SectionParams, _Less> Sections;
	typedef std::pair<std::string, std::string> SectionParamsPair;
	typedef std::pair<std::string, SectionParams> SectionsPair;

	IniFile(const char *filename)
	{
		//FileStream<std::ifstream> is(filename, std::ios::in);
		std::ifstream is;
		is.open(filename, std::ios::in);
		if (!is.is_open()) {
			if (os::errNo() != 2)
				os::throwErr<FatalError>();
			else
				return;
		}
		SectionParams params;
		Sections::iterator cur_sec = _sections.end();
		std::string name;
		char line[256];
		std::size_t len;
		std::string key, val;
		char *eq;
		while (!is.eof()) {
			is.getline(line, sizeof(line), '\n');
			if (is.gcount() > 0) {
				len = strlen(line);
				if (line[len - 1] == '\r')
					line[--len] = '\0';
				if (len > 2) {
					if (line[0] != ';') {
						if (line[0] == '[') {
							line[len - 1] = '\0';
							name = &line[1];
							std::pair<Sections::iterator, bool> pr = _sections.insert(SectionsPair(name, params));
							if (pr.second)
								cur_sec = pr.first;
						}
						else if (cur_sec != _sections.end()) {
							eq = strchr(line, '=');
							if (eq) {
								eq[0] = '\0';
								key = line;
								val = ++eq;
								cur_sec->second.insert(SectionParamsPair(key, val));
							}
						}
					}
				}
			}
		}
	}

	void save(const char *filename) const
	{
		createPath(extractFilePath(filename));
		FileStream<std::ofstream> os(filename, std::ios::out|std::ios::trunc);
		SectionParams::const_iterator param_it;
		Sections::const_iterator sec_it = _sections.begin();
		while (sec_it != _sections.end()) {
			os << '[' << sec_it->first << ']' << std::endl;
			param_it = sec_it->second.begin();
			while (param_it != sec_it->second.end()) {
				os << param_it->first << '=' << param_it->second << std::endl;
				++param_it;
			}
			++sec_it;
		}
	}

	std::string read(const char *section, const char *key, const std::string& defVal) const
	{
		Sections::const_iterator sec_it = _sections.find(section);
		if (sec_it != _sections.end()) {
			SectionParams::const_iterator key_it = sec_it->second.find(key);
			if (key_it != sec_it->second.end())
				return key_it->second;
		}
		return defVal;
	}

	int read(const char *section, const char *key, int defVal) const
	{
		const std::string s = boost::lexical_cast<std::string, int>(defVal);
		return boost::lexical_cast<int, std::string>(read(section, key, s));
	}

	void write(const char *section, const char *key, const std::string& val)
	{
		SectionParams params;
		std::pair<Sections::iterator, bool> sec_pr = _sections.insert(SectionsPair(section, params));
		std::pair<SectionParams::iterator, bool> param_pr = sec_pr.first->second.insert(SectionParamsPair(key, val));
		if (!param_pr.second)
			param_pr.first->second = val;
	}

	void clear()
	{
		Sections::iterator it = _sections.begin();
		while (it != _sections.begin()) {
			it->second.clear();
			++it;
		}
		_sections.clear();
	}

	const Sections& sections() const { return _sections; }

private:
	Sections _sections;
};

}

#endif
