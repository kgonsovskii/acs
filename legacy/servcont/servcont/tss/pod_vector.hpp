#ifndef TSS_POD_VECTOR_HPP_INCLUDED
#define TSS_POD_VECTOR_HPP_INCLUDED

#pragma once

#include <cassert>
//#include <cstdlib>
//#include <malloc.h>
#include <stdexcept>
#include <algorithm>
#include <boost/type_traits/is_pod.hpp>
#include <boost/utility/enable_if.hpp>

namespace tss {

template <typename T, typename Enable = void>
class pod_vector;

template <typename T>
class pod_vector<T, typename boost::enable_if<boost::is_pod<T> >::type>
{
public:
	typedef T value_type;
	typedef value_type* pointer;
	typedef const value_type* const_pointer;
	typedef value_type* iterator;
	typedef const value_type* const_iterator;
	typedef value_type& reference;
	typedef const value_type& const_reference;
	typedef std::size_t size_type;
	typedef std::ptrdiff_t difference_type;

	pod_vector(): _p(NULL), _capacity(0), _size(0) {}
	explicit pod_vector(const size_type size): _p(NULL), _capacity(0), _size(0)
	{
		resize(size);
	}
	pod_vector(const size_type count, const_reference val): _p(NULL), _capacity(0), _size(0)
	{
		assign(count, val);
	}
	template<class Iter>
	pod_vector(Iter beg, Iter end): _p(NULL), _capacity(0), _size(0)
	{
		assign(beg, end);
	}
	pod_vector(const pod_vector& rhs): _p(NULL), _capacity(0), _size(0)
	{
		assign(rhs.begin(), rhs.end());
	}

	~pod_vector() throw()
	{
		std::free(_p);
	}

	void assign(const size_type count, const_reference val)
	{
		resize(count);
		std::fill(begin(), end(), val);
	}

	template<class Iter>
	void assign(Iter beg, Iter end)
	{
		resize(std::distance(beg, end));
		std::copy(beg, end, begin());
	}

	iterator begin() throw()
	{
		return _p;
	}
	const_iterator begin() const throw()
	{
		return _p;
	}

	iterator end() throw()
	{
		return (_p + _size);
	}
	const_iterator end() const throw()
	{
		return (_p + _size);
	}

	void reserve(const size_type size)
	{
		if (_capacity < size)
			capacity(size);
	}

	void capacity(const size_type size) // throw(std::bad_alloc)
	{
		if (_capacity == size)
			return;

		if (size > max_size())
			throw std::length_error("vector<T> too long");

		pointer p = static_cast<pointer>(std::realloc(_p, size * sizeof(value_type)));
		if (!p)
			throw std::bad_alloc();
		_p = p;
		_capacity = size;
		if (size < _size)
			_size = size;
	}

	size_type capacity() const throw()
	{
		return _capacity;
	}

	void resize(const size_type size)
	{
		reserve(size);
		_size = size;
	}

	size_type size() const throw()
	{
		return _size;
	}

	bool empty() const throw()
	{
		return _size == 0;
	}

	void clear() throw()
	{
		resize(0);
	}

	reference front() throw()
	{
		assert(_size != 0);
		return _p[0];
	}
	const_reference front() const throw()
	{
		assert(_size != 0);
		return _p[0];
	}

	reference back() throw()
	{
		assert(_size != 0);
		return _p[_size - 1];
	}
	const_reference back() const throw()
	{
		assert(_size != 0);
		return _p[_size - 1];
	}

	void push_back(const_reference elem)
	{
		resize(_size + 1);
		_p[_size - 1] = elem;

	}

	void pop_back() throw()
	{
		assert(_size != 0);
		--_size;
	}

	template<class Iter>
	void insert(iterator pos, Iter beg, Iter end)
	{
		assert(pos >= begin());
		const difference_type insertion = std::distance(beg, end);
		const difference_type left_part = pos - _p;
		resize(_size + insertion);
		pos = _p + left_part;
		if (pos != _p + _size - insertion)
			std::copy_backward(pos, _p + _size - insertion, _p + _size);
		std::copy(beg, end, pos);
	}

	/************************************************************************/
	/* custom method                                                        */
	/************************************************************************/
	void erase_back(size_type count)
	{
		assert(count <= _size);
		resize(_size - count);
	}

	reference at(const size_type pos) // throw(std::out_of_range)
	{
		if (!(pos < _size))
			_throw_out_of_range();
		return _p[pos];
	}
	const_reference at(const size_type pos) const // throw(std::out_of_range)
	{
		if (!(pos < _size))
			_throw_out_of_range();
			return _p[pos];
	}

	/************************************************************************/
	/* custom behaviour                                                     */
	/************************************************************************/
	void swap(pod_vector& rhs) throw()
	{
		if (this == &rhs)
			return;

		pointer const p = rhs._p;
		const size_type s = rhs.size();
		const size_type c = rhs.capacity();

		rhs._p = _p;
		rhs._size = _size;
		rhs._capacity = _capacity;

		_p = p;
		_size = s;
		_capacity = c;
	}

	reference operator[] (const size_type idx) throw()
	{
		assert(idx < _size);
		return _p[idx];
	}
	const_reference operator[] (const size_type idx) const throw()
	{
		assert(idx < _size);
		return _p[idx];
	}

	pod_vector& operator= (const pod_vector& rhs)
	{
		if (this != &rhs)
			assign(rhs.begin(), rhs.end());
		return *this;
	}

	static size_type max_size() throw()
	{
		return static_cast<size_type>(-1) / sizeof(value_type);
	}

protected:
	static void _throw_out_of_range() { throw std::out_of_range("invalid vector<T> subscript"); }
	pointer _p;
	size_type _capacity;
	size_type _size;
};//pod_vector

template <class T>
static inline bool operator== (const pod_vector<T>& lhs, const pod_vector<T>& rhs)
{
	return (&lhs != &rhs)? ((lhs.size() == rhs.size())? std::equal(lhs.begin(), lhs.end(), rhs.begin()): false): true;
}

template <class T>
static inline bool operator!= (const pod_vector<T>& lhs, const pod_vector<T>& rhs)
{
	return !operator==(lhs, rhs);
}

}// namespace tss

#endif
