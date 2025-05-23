#ifndef TSS_MAP_HPP
#define TSS_MAP_HPP

#pragma once

#include "config.hpp"
#include <string>
#include <map>
#include <utility>
#include <boost/shared_ptr.hpp>

namespace tss {

template <class Key, class Val>
class Map: public std::map<Key, Val>
{
public:
	typedef std::map<Key, Val> Base;
	typedef std::pair<Key, Val> Pair;

	virtual ~Map() {}

	void insert(const Key& key, const Val& item)
	{
		if (!Base::insert(Pair(key, item)).second)
			_throw(key, "already exists");
	}

	void erase(const Key& key)
	{
		if (!Base::erase(key))
			_throwNoItem(key);
	}

	Val *find(const Key& key) throw()
	{
		typename Base::iterator it = Base::find(key);
		if (it == Base::end())
			return NULL;
		return &it->second;
	}

	const Val *find(const Key& key) const throw()
	{
		return const_cast<Map *>(this)->find(key);
	}

	Val& operator [](const Key& key)
	{
		typename Base::iterator it = Base::find(key);
		if (it == Base::end())
			_throwNoItem(key);
		return it->second;
	}

	const Val& operator [](const Key& key) const
	{
		return const_cast<Map *>(this)->operator [](key);
	}
protected:
	virtual std::string _key2str(const Key&) const = 0;
private:
	void _throw(const Key& key, const char *s)
	{
		throw std::runtime_error(_key2str(key) + ' ' + s);
	}

	void _throwNoItem(const Key& key) { _throw(key, "doesn't exist"); }
};//Map

template <class Key, class Val>
class PtrMap: public Map<Key, boost::shared_ptr<Val> >
{
public:
	typedef Map<Key, boost::shared_ptr<Val> > Base;

	void insert(const Key& key, Val *item)
	{
		Base::insert(key, boost::shared_ptr<Val>(item));
	}

	Val *find(const Key& key) throw()
	{
		return Base::find(key)->get();
	}

	Val& operator [] (Key key)
	{
		return *Base::operator [] (key);
	}

	const Val& operator [] (Key key) const
	{
		return *Base::operator [] (key);
	}
};//PtrMap


}//namespace tss

#endif//TSS_MAP_HPP
