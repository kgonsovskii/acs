#ifndef TSS_TIMER_HPP_INCLUDED
#define TSS_TIMER_HPP_INCLUDED

#pragma once

#include "config.hpp"
#include <set>
#include "sync.hpp"
#include "thread.hpp"

namespace tss {

class Timer
{
protected:
	struct _ThImpl;
public:
	class Item
	{
	friend class Timer;
	public:
		Item(unsigned int interval_, bool once_): interval(interval_), once(once_), _active(false), _c(0) {}
		virtual ~Item() {}
		void active(bool);
		bool active() const;
		const unsigned int interval;
		const bool once;
	protected:
		virtual void onTimer() throw() = 0;
		void _setActive(bool);
		bool _getActive() const;
		Timer *_timer;
		bool _active;
		unsigned int _c;
	};

	Timer(): _active(false) {}
	~Timer();
	void start();
	void stop();
	bool add(Item&);
	bool remove(Item&);
	bool active(Item&, bool);
protected:
	struct _ThImpl: Thread::Impl
	{
		_ThImpl(Timer& timer_): timer(timer_) {}
		void operator() () throw();
		Timer& timer;
	};
	thread::Synchronizer _sync;
	volatile bool _active;
	std::set<Item *> _items;
	Semaphore _sem;
	Thread *_th;
};

}//namespace tss

#endif
