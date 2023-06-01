/*******************************************
This file is part of the MuJoCo software.
(C) 2012 Emo Todorov. All rights reserved.
*******************************************/


// global callback function pointers

extern mjfCallback mjcb_control;
extern mjfCallback mjcb_passive;
extern mjfCallback mjcb_constraint;
extern mjfCallback mjcb_actgain;
extern mjfCallback mjcb_actdyn;
extern mjfCallback mjcb_impulse;

extern int (*mjcb_gettime)(void);
