#include <tss/gpio.hpp>
#include <cassert>
#include <cstring>
#include <sstream>
#include <tss/nix/fcntl.hpp>
//#include <tss/nix/unistd.hpp>

using namespace std;
using namespace boost;

namespace tss
{

static const char * const root = "/sys/class/simple-gpio/";

static void turn(char no, bool on)
{
	ostringstream o;
	o << root;
	if (!on)
		o << "un";
	o << "export";
	os::Handle handle(os::open(o.str().c_str(), O_WRONLY|O_NOCTTY));
	const char buf[] = {no + '0', '\n'};
	if (::write(handle, buf, sizeof(buf)) != sizeof(buf))
		os::fatalError();
	::fsync(handle);
}

GPIO::GPIO(char no_): no(no_)
{
	turn(no, true);
	ostringstream o;
	o << root << "gpio" << static_cast<unsigned short>(no) << '/' << "value";
	_handle = new os::Handle(os::open(o.str().c_str(), O_RDWR|O_NOCTTY));
}

GPIO::~GPIO()
{
	delete _handle;
	turn(no, false);
}

void GPIO::setDirection(Direction dir)
{
	ostringstream o;
	o << root << "gpio" << static_cast<unsigned short>(no) << '/' << "direction";
	os::Handle handle(os::open(o.str().c_str(), O_WRONLY|O_NOCTTY));
	const char *s;
	switch (dir)
	{
		case high:
			s = "high";
			break;
		case low:
			s = "low";
			break;
		case in:
			s = "in";
			break;
		default: assert(0); s = NULL;
	}
	const ssize_t len = strlen(s);
	if (::write(handle, s, len) != len)
		os::fatalError();
	::fsync(handle);
}

bool GPIO::isIn() const
{
	ostringstream o;
	o << root << "gpio" << static_cast<int>(no) << '/' << "direction";
	os::Handle handle(os::open(o.str().c_str(), O_RDONLY|O_NOCTTY));
	char buf[5];
	::fsync(handle);
	const ssize_t r = ::read(handle, buf, sizeof(buf));
	if (r < 1)
		os::fatalError();
	buf[r-1] = '\0';
	if (strcmp(buf, "in") == 0)
		return true;
	else if (strcmp(buf, "out") == 0)
		return false;
	else
		os::fatalError(); return false;
}

void GPIO::value(bool val) const
{
	const char buf[] = { val? '1': '0', '\n' };
	if (::write(*_handle, buf, sizeof(buf)) != sizeof(buf))
		os::fatalError();
	::fsync(*_handle);
}

bool GPIO::value() const
{
	char buf[5];
	::fsync(*_handle);
	const ssize_t r = ::read(*_handle, buf, sizeof(buf));
	if (r < 1)
		os::fatalError();
	switch (buf[0])
	{
		case '0':
			return false;
		case '1':
			return true;
		default:
			os::fatalError(); return false;
	}
}

}
