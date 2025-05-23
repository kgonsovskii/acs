#include "pch.h"
#include <tss/timer.hpp>
#include <cassert>

using namespace std;

namespace tss {

Timer::~Timer()
{
	stop();
}

bool Timer::add(Item& item)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	assert(!_active);
	const bool ret = _items.insert(&item).second;
	if (ret)
		item._timer = this;
	return ret;
}

bool Timer::remove(Item& item)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	assert(!_active);
	return _items.erase(&item) == 1;
}

void Timer::start()
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	if (!_active)
	{
		for (set<Item *>::iterator it = _items.begin(); it != _items.end(); ++it)
			(*it)->_c = 0;
		_th = new Thread(new _ThImpl(*this));
		_active = true;
	}
}

void Timer::stop()
{
	{
		TSS_SCOPED_THREAD_LOCK(_sync);
		if (_active)
		{
			_active = false;
			_sem.set();
		} else
			return;
	}
	delete _th;
}

bool Timer::active(Item& item, bool val)
{
	TSS_SCOPED_THREAD_LOCK(_sync);
	set<Item *>::iterator it = _items.find(&item);
	const bool ret = it != _items.end();
	if (ret)
	{
		Item& item = *(*it);
		if (!item._active)
			item._c = 0;
		item._active = val;
	}
	return ret;
}

void Timer::_ThImpl::operator()() throw()
{
	while (true)
	{

		timer._sem.wait(990);
		if (!timer._active)
			break;

		for (set<Item *>::iterator it = timer._items.begin(); it != timer._items.end(); ++it)
		{
			Item& item = *(*it);
			try
			{
				if (item._getActive())
				{
					++item._c;
					if (item._c == item.interval)
					{
						item._c = 0;
						if (item.once)
							item._setActive(false);
						item.onTimer();
					}
				}
			} catch (const Abort&)
			{
				break;
			}
		}

	}
}

void Timer::Item::active(bool val)
{
	TSS_SCOPED_THREAD_LOCK(_timer->_sync);
	_active = val;
}

bool Timer::Item::active() const
{
	TSS_SCOPED_THREAD_LOCK(_timer->_sync);
	return _active;
}

void Timer::Item::_setActive(bool val)
{
	TSS_SCOPED_THREAD_LOCK(_timer->_sync);
	_active = val;
	if (!_timer->_active)
		throw Abort();
}

bool Timer::Item::_getActive() const
{
	TSS_SCOPED_THREAD_LOCK(_timer->_sync);
	if (!_timer->_active)
		throw Abort();
	return _active;
}

}//namespace tss
