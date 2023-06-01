/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/

#ifndef _MUJOCO_H_
#define _MUJOCO_H_


// double if defined, float if not
#define mjUSEDOUBLE				

// error handling and memory allocation
#include "mj_errmem.h"


#ifdef __cplusplus
extern "C"
{
#endif

// constant and type definitions
#include "mj_engine_typedef.h"

// function definitions
#include "mj_engine_util.h"
#include "mj_engine_callback.h"
#include "mj_engine_support.h"
#include "mj_engine_core.h"
#include "mj_engine_solver.h"
#include "mj_engine_impulse.h"
#include "mj_engine_collision.h"
#include "mj_engine_io.h"
#include "mj_engine_print.h"

#ifdef __cplusplus
}
#endif


#endif
