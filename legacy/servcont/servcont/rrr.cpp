char Controller::_readRPD(char off) const
{
	const char cmd[] = {0x16, 0x63, addr, off};
	channel._write(cmd, sizeof(cmd));
	char ret;
	const int r = channel._read(&ret, 1);
	_chkInput(r);
	return ret;
}

int Controller::_varVal(const char *data, int idx) const
{
	int ret;
	switch (data[0])
	{
		case 2:
			ret = data[idx] | (data[1 + idx] << 8);
			break;
		case 3:
			ret = data[idx] | (data[1 + idx] << 8) | (data[2 + idx] << 16);
			break;
		default:
			_throwUnexpectedResponse();
	}
	return ret;
}