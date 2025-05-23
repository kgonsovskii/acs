#ifndef TSS_MODBUS_HPP_INCLUDED
#define TSS_MODBUS_HPP_INCLUDED

#pragma once

namespace tss
{

class Modbus
{
public:
	struct Channel
	{
		virtual ~Channel() {}
		virtual void _write(const char *, int) const = 0;
		virtual int _read(char *, int) const = 0;
	};//Channel
	
	Modbus(const Channel& channel_): channel(channel_) {}
	void readCoilStatus(char slave, unsigned short addr, unsigned short count /* bit count */, char *dest /* dest[2] - byte count, dest[3] - data */, int size) const
	{
		_readMultiple(slave, 1, addr, count / 8 + ((count % 8)? 1: 0), dest, size);
	}
	void readInputStatus(char slave, unsigned short addr, unsigned short count /* bit count */, char *dest /* dest[2] - byte count, dest[3] - data */, int size) const
	{
		_readMultiple(slave, 2, addr, count / 8 + ((count % 8)? 1: 0), dest, size);
	}
	void readHoldingRegisters(char slave, unsigned short addr, unsigned short count /* register count */, char *dest /* dest[2] - byte count, dest[3] - data */, int size) const
	{
		_readMultiple(slave, 3, addr, count * 2, dest, size);
	}
	void readInputRegisters(char slave, unsigned short addr, unsigned short count /* register count */, char *dest /* dest[2] - byte count, dest[3] - data */, int size) const
	{
		_readMultiple(slave, 4, addr, count * 2, dest, size);
	}
	void forceSingleCoil(char slave, unsigned short addr, bool val) const
	{
		_writeSingle(slave, 5, addr, val? 0xFF00: 0x0000);
	}
	void presetSingleRegister(char slave, unsigned short addr, unsigned short val) const
	{
		_writeSingle(slave, 6, addr, val);
	}
	void presetMultipleRegisters(char slave, unsigned short addr, char *data /* &data[7] - data */, unsigned short count) const
	{
		_writeMultiple(slave, 0x10, addr, data, count / 2);
	}

	const Channel& channel;
	
	static short crc(const char *, unsigned short);
protected:
	void _readMultiple(char, char, unsigned short, unsigned short, char *, int) const;
	void _writeMultiple(char, char, unsigned short, char *, char) const;
	void _writeSingle(char, char, unsigned short, unsigned short) const;
};//Modbus

}//namespace tss

#endif
