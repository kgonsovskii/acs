#include <tss/i2c.hpp>
#include <tss/nix/ioctl.hpp>
#include <tss/nix/fcntl.hpp>

#define I2C_SLAVE   0x0703  /* Change slave address         */
#define I2C_RDWR    0x0707  /* Combined R/W transfer (one stop only)*/

#define I2C_M_TEN   0x10    /* we have a ten bit chip address   */
#define I2C_M_RD    0x01
#define I2C_M_NOSTART   0x4000
#define I2C_M_REV_DIR_ADDR  0x2000
#define I2C_M_IGNORE_NAK    0x1000
#define I2C_M_NO_RD_ACK     0x0800

struct i2c_msg {
	unsigned short addr;    /* slave address            */
	unsigned short flags;
	unsigned short len;     /* msg length               */
	unsigned char *buf;     /* pointer to msg data          */
};

struct i2c_rdwr_ioctl_data {
	struct i2c_msg  *msgs;  /* pointers to i2c_msgs */
	unsigned int nmsgs;         /* number of i2c_msgs */
};

namespace tss
{

const char * const I2C::devStr = "/dev/i2c-0";

I2C::I2C(char id_): os::Handle(os::open(devStr, O_RDWR|O_NOCTTY)), id(id_)
{
	os::ioctl(handle, I2C_SLAVE, id >> 1);
}

void I2C::write(const char *data, char size) const
{
	os::write(handle, data, size);
}

void I2C::write(char off, char *data, char size) const
{
	data[0] = off;
	os::write(handle, data, size);
}

void I2C::write(char off, O& data, char size) const
{
	*data.p = off;
	os::write(handle, data, size);
}

int I2C::read(char off, char *data, char size) const
{
	struct i2c_msg msg = {id >> 1, 0, 1, reinterpret_cast<unsigned char *>(data) };
	struct i2c_rdwr_ioctl_data rdwr = {&msg, 1};
	msg.buf[0] = off;
	os::ioctl(handle, I2C_RDWR, reinterpret_cast<int>(&rdwr));
	return os::read(handle, data, size);
}
	
}
