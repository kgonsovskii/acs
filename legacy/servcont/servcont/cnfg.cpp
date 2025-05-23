#include "pch.h"
#include <tss/cnfg.hpp>
#include <new>
#include <cassert>
#include <cstring>
#include <stdexcept>
#include <tss/sys.hpp>
#include <tss/file.hpp>
#include <boost/scoped_array.hpp>
#include <boost/lexical_cast.hpp>

using namespace std;
using namespace boost;

namespace tss { namespace cnfg
{

FileStream::FileStream(const char *filename, const char *mode)
{
	_fp = fopen(filename, mode);
	if (!_fp)
		throwFileOpenErr(filename);
}

FileStream::~FileStream()
{
	if (fclose(_fp) != 0)
		os::fatalError();
}

int FileStream::size() const
{
	const int pos = position();
	if (fseek(_fp, 0, SEEK_END) != 0)
		os::fatalError();
	const int ret = position();
	const_cast<FileStream *>(this)->position(pos);
	return ret;
}

int FileStream::position() const
{
	const int ret = ftell(_fp);
	if (ret == -1)
		os::fatalError();
	return ret;
}

void FileStream::position(int val)
{
	if (fseek(_fp, val, SEEK_SET) != 0)
		os::fatalError();
}

void FileStream::read(char *buf, int size)
{
	assert((position() + size) <= this->size());
	if (static_cast<int>(fread(buf, 1, size, _fp)) != size)
		os::fatalError();
}

void FileStream::write(const char *buf, int size)
{
	if (static_cast<int>(fwrite(buf, 1, size, _fp)) != size)
		os::fatalError();
}

bool FileStream::find(const char *sample, int size)
{
	const int ss = this->size();
	scoped_array<char> buf(new char[size]);
	int pos = position();
	while ((pos + size) <= ss)
	{
		read(&buf[0], size);
		if (memcmp(&buf[0], sample, size) == 0)
			return true;
		position(++pos);
	}
	return false;
}

void FileStream::seek(int offset)
{
	if (fseek(_fp, offset, SEEK_CUR) != 0)
		os::fatalError();
}

//-------------------------------------------------------------------

MemoryStream::MemoryStream(): _p(NULL), _size(0), _pos(0), _static(false)
{
}

MemoryStream::MemoryStream(char *staticDataPtr, int size): _p(staticDataPtr), _size(size), _pos(0), _static(true)
{
}

MemoryStream::~MemoryStream()
{
	if (!_static)
		free(_p);
}

int MemoryStream::size() const
{
	return _size;
}

int MemoryStream::position() const
{
	return _pos;
}

void MemoryStream::position(int val)
{
	_pos = val;
}

void MemoryStream::read(char *buf, int size)
{
	assert((_pos + size) <= _size);
	memcpy(buf, &_p[_pos], size);
	_pos += size;
}

void MemoryStream::write(const char *buf, int size)
{
	if (!_static)
	{
		const int x = _pos + size;
		if (_size < x)
		{
			const int newSize = _size + (x - _size);
			_p = reinterpret_cast<char *>(realloc(static_cast<void *>(_p), newSize));
			if (newSize && !_p)
				throw bad_alloc();
			_size = newSize;
		}
	}
	assert((_pos + size) <= _size);
	memcpy(static_cast<void *>(&_p[_pos]), buf, size);
	_pos += size;
}

bool MemoryStream::find(const char *sample, int size)
{
	while ((_pos + size) <= _size)
	{
		if (memcmp(&_p[_pos], sample, size) == 0)
		{
			_pos += size;
			return true;
		}
		++_pos;
	}
	return false;
}

void MemoryStream::seek(int offset)
{
	_pos += offset;
}

//-------------------------------------------------------------------

Rd::Item::Item(Stream& stream): startPos(stream.position()), _stream(stream)
{
}

char Rd::Item::version()
{
	_stream.position(startPos);
	_chkSize(size::ver);
	char buf[size::ver + 1];
	_stream.read(buf, size::ver);
	buf[size::ver] = 0;
	return lexical_cast<int, char *>(buf);
}

int Rd::Item::nodesSize()
{
	_stream.position(startPos + size::ver);
	_chkSize(size::ver + size::node);
	int ret;
	_stream.read(reinterpret_cast<char *>(&ret), size::node);
	return ret;
}

unsigned short Rd::Item::nameCount()
{
	_stream.position(startPos + size::ver + size::node + nodesSize());
	_chkSize(size::name);
	unsigned short ret;
	_stream.read(reinterpret_cast<char *>(&ret), size::name);
	return ret;
}

void Rd::Item::name(unsigned short idx, Name& name)
{
	assert(idx < nameCount());
	_stream.position(startPos + size::ver + size::node + nodesSize() + size::name);
	for (unsigned short i = 0; i <= idx; ++i)
	{
		_chkSize(size::str);
		char len;
		_stream.read(&len, size::str);
		if (i == idx)
		{
			const int size = len + size::type;
			_chkSize(size);
			scoped_array<char> buf(new char[size]);
			_stream.read(&buf[0], size);
			name.name.assign(&buf[0], len);
			name.type = dataType(buf[len]);
		} else
			_stream.seek(len + size::type);
	}
}

DataType Rd::Item::name(unsigned short idx)
{
	assert(idx < nameCount());
	_stream.position(startPos + size::ver + size::node + nodesSize() + size::name);
	for (unsigned short i = 0; i <= idx; ++i)
	{
		_chkSize(size::str);
		char len;
		_stream.read(&len, size::str);
		if (i == idx)
		{
			_chkSize(len + size::type);
			_stream.seek(len);
			char ret;
			_stream.read(&ret, size::type);
			return static_cast<DataType>(ret);
		} else
			_stream.seek(len + size::type);
	}
	return dtEnd;
}

void Rd::Item::node(Node& node)
{
	const int size = startPos + size::node + nodesSize();
	_stream.position(startPos + size::ver);
	while (_stream.position() < size)
	{
		node._startPos = _stream.position();
		int size;
		_stream.read((char*)&size, sizeof(size));
		printf("size: %d\n", size);

		unsigned short classNameIdx;
		_stream.read((char*)&classNameIdx, sizeof(classNameIdx));
		printf("classNameIdx: %u\n", classNameIdx);

		unsigned short attrCount;
		_stream.read((char*)&attrCount, sizeof(attrCount));
		printf("attrCount: %u\n", attrCount);

		for (unsigned short i = 0; i != attrCount; ++i)
		{
			unsigned short attrNameIdx;
			_stream.read((char*)&attrNameIdx, sizeof(attrNameIdx));
			printf("\tattrNameIdx: %u\n", attrNameIdx);
			Name n;
			const int pos = _stream.position();
			name(attrNameIdx, n);
			_stream.position(pos);
			printf("\tname: %s\n", n.name.c_str());
			printf("\ttype: %d\n", n.type);
			if (n.type == dtString || n.type == dtBlob)
			{
				int size = 0;
				if (n.type == dtString)
					_stream.read((char*)&size, size::str);
				else
					_stream.read((char*)&size, size::blob);
				scoped_array<char> buf(new char[size + 1]);
				_stream.read(&buf[0], size);
				if (n.type == dtString)
				{
					buf[size] = 0;
					printf("\tattr: %s\n", &buf[0]);
				}
			} else
				_stream.seek(sizeByType(n.type));
			printf("\n");
		}

		unsigned short relationsCount;
		_stream.read((char*)&relationsCount, sizeof(relationsCount));
		printf("relationsCount: %u\n", relationsCount);

		char associateBuffSizeLen;
		_stream.read(&associateBuffSizeLen, sizeof(associateBuffSizeLen));
		printf("associateBuffSizeLen: %u\n", associateBuffSizeLen);

		for (unsigned short i = 0; i < relationsCount; ++i)
		{
			char uid[size::uid];
			_stream.read(uid, sizeof(uid));
			for (int i=0; i < sizeof(uid); ++i)
				printf("%.2X ", uid[i]);
			printf("\n");

			if (associateBuffSizeLen)
			{
				int associateBuffSize = 0;
				_stream.read((char*)&associateBuffSize, associateBuffSizeLen);
				printf("associateBuffSize: %d\n", associateBuffSize);

				scoped_array<char> buf(new char[associateBuffSize]);
				_stream.read(&buf[0], associateBuffSize);
			}
		}

		unsigned short childCount;
		_stream.read((char*)&childCount, sizeof(childCount));
		printf("childCount: %u\n", childCount);

		node();
	}
}

void Rd::Item::_chkSize(int size) const
{
	if ((_stream.position() + size) > _stream.size())
		throw runtime_error("Invalid configuration");
}

//-------------------------------------------------------------------

Rd::Rd(const char *filename): _stream(new FileStream(filename, "rb"))
{
	_load();
}

Rd::Rd(const char *data, int size): _stream(new MemoryStream(const_cast<char *>(data), size))
{
	_load();
}

Rd::~Rd()
{
}

void Rd::_load()
{
	_stream->position(0);
	while (true)
	{
		if (!_stream->find(marker, sizeof(marker)))
			break;
		boost::shared_ptr<Item> item(new Item(*_stream));
		_items.push_back(item);
	}
}

//-------------------------------------------------------------------

Rd::Node::Node(const Item& item_): item(item_)
{
	//item._stream.position(item.startPos + size::ver + size::node);
}

int Rd::Node::size()
{
	item._stream.position(_startPos);
	item._chkSize(size::node);
	int ret;
	item._stream.read(reinterpret_cast<char *>(&ret), size::node);
	return ret;
}

unsigned short Rd::Node::nameIdx()
{
	item._stream.position(_startPos + size::node);
	unsigned short ret;
	item._chkSize(size::name);
	item._stream.read(reinterpret_cast<char *>(&ret), size::name);
	return ret;
}

unsigned short Rd::Node::attrCount()
{
	item._stream.position(_startPos + size::node + size::name);
	unsigned short ret;
	item._chkSize(size::attr);
	item._stream.read(reinterpret_cast<char *>(&ret), size::attr);
	return ret;
}

} // namespace cnfg
}
