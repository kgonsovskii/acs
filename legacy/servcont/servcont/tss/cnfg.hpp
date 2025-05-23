#ifndef TSS_CNFG_HPP_INCLUDED
#define TSS_CNFG_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <cstdio>
#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <boost/scoped_ptr.hpp>

namespace tss
{

namespace cnfg
{

static const char marker[] = { 'g', 'm', 'C', 'N', 'F', 'G' };
namespace size
{
	static const char ver = 3;
	static const char name = 2;
	static const char node = 4;
	static const char str = 1;
	static const char blob = 4;
	static const char maxStrLen = 255;
	static const char type = 1;
	static const char attr = 2;
	static const char uid = 16;
} // namespace size

enum DataType
{
	dtClassname,
	dtUid,
	dtInteger,
	dtBoolean,
	dtDateTime,
	dtFloat,
	dtString,
	dtBlob,
	dtEnd
};

struct Stream
{
	virtual ~Stream() {}
	virtual int size() const = 0;
	virtual int position() const = 0;
	virtual void position(int) = 0;
	virtual void seek(int) = 0;
	virtual void read(char *, int) = 0;
	virtual void write(const char *, int) = 0;
	virtual bool find(const char *, int) = 0;
};

class FileStream: public Stream
{
public:
	FileStream(const char *, const char *);
	~FileStream();
	int size() const;
	int position() const;
	void position(int);
	void seek(int);
	void read(char *, int);
	void write(const char *, int);
	bool find(const char *, int);
protected:
	FILE *_fp;
};

class MemoryStream: public Stream
{
public:
	MemoryStream();
	MemoryStream(char *, int);
	~MemoryStream();
	int size() const;
	int position() const;
	void position(int);
	void seek(int);
	void read(char *, int);
	void write(const char *, int);
	bool find(const char *, int);
protected:
	char *_p;
	int _size;
	int _pos;
	bool _static;
};

struct Name
{
	std::string name;
	DataType type;
};

static inline int sizeByType(DataType type)
{
	switch (type)
	{
		case dtClassname: return 0;
		case dtUid: return 16;
		case dtInteger: return 4;
		case dtBoolean: return 1;
		case dtDateTime: return 8;
		case dtFloat: return 8;
		default: throw std::runtime_error("Invalid data type");
	}
}

static inline DataType dataType(char type)
{
	const DataType ret = static_cast<DataType>(type);
	if (ret < dtClassname || ret > dtBlob)
		throw std::runtime_error("Invalid data type");
	return ret;
}

class Rd
{
public:
	class Item;
	class Node
	{
		friend class Item;
	public:
		Node(const Item&);
		virtual ~Node() {}
		virtual void operator ()() = 0;
		int startPos() const throw() { return _startPos; }
		int size();
		unsigned short nameIdx();
		unsigned short attrCount();
		const Item& item;
	protected:
		int _startPos;
	};

	class Item
	{
		friend class Rd;
	public:
		char version();
		int nodesSize();
		unsigned short nameCount();
		void name(unsigned short, Name&);
		DataType name(unsigned short);
		void node(Node&);
		const int startPos;
	protected:
		Item(Stream&);
		Stream& _stream;
		void _chkSize(int) const;
	};
	typedef std::vector<boost::shared_ptr<Item> > Items;
	Rd(const char *);
	Rd(const char *, int);
	~Rd();
	const Items& items() const throw() { return _items; }
protected:
	void _load();
	Items _items;
	boost::scoped_ptr<Stream> _stream;
};

class Wr
{
public:
protected:
};

} // namespace cnfg
}

#endif
