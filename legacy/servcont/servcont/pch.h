// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file

#ifndef PCH_H
#define PCH_H

// TODO: add headers that you want to pre-compile here
#include <tss/config.hpp>
#ifdef MSWINDOWS
#include <Windows.h>
#include <MSTcpIP.h>
#include <memory.h>
#endif

#include <sqlite3.h>

#include <cassert>
#include <cstring>
#include <cstdlib>
#include <cstdio>

#include <stdexcept>
#include <string>
#include <list>
#include <utility>
#include <vector>
#include <queue>
#include <algorithm>
#include <memory>
#include <new>
#include <set>
#include <map>
#include <iomanip>
#include <sstream>

#include <boost/scoped_array.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/format.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/function.hpp>
#include <boost/bind.hpp>
#include <boost/optional.hpp>


#endif //PCH_H
