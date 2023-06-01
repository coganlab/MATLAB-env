/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/

#ifndef _MJ_ERRMEM_H_
#define _MJ_ERRMEM_H_

#pragma warning(disable: 4996)


#ifdef __cplusplus
extern "C"
{
#endif


//------------------------------ user handlers --------------------------------------

extern void (*mju_user_error)(const char*);
extern void (*mju_user_warning)(const char*);
extern void* (*mju_user_malloc)(unsigned int);
extern void (*mju_user_free)(void*);

// restore default handlers
void mju_clear_handlers(void);


//------------------------------ errors and warnings --------------------------------

// write text message to logfile and console, exit if error
void mju_error(const char* msg);
void mju_warning(const char* msg);

// additional int argument
void mju_error_i(const char* msg, int i);
void mju_warning_i(const char* msg, int i);

// additional string argument
void mju_error_s(const char* msg, const char* text);
void mju_warning_s(const char* msg, const char* text);

// write datetime, type: message to MUJOCO_LOG.TXT
void mju_log(const char* type, const char* msg);


//------------------------------ malloc and free ------------------------------------

// allocate memory, using malloc() by default
void* mju_malloc(unsigned int sz);

// free memory, using free() by default
void mju_free(void* ptr);


#ifdef __cplusplus
}
#endif

#endif
