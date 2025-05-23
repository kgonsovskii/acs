#ifndef TSS_OS_HPP_INCLUDED
#define TSS_OS_HPP_INCLUDED

#pragma once

#include "config.hpp"

#ifdef LINUX
#include <tss/nix/nix.hpp>
#endif

#ifdef MSWINDOWS
#include <tss/win/windows.hpp>
#endif

#endif
