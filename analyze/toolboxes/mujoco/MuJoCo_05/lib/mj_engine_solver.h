/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/


//-------------------------------- solver components ---------------------------------

// smooth dynamics: computations that depend only on qpos
void mj_solvePosition(const mjModel* m, mjData* d, mjtByte skipM);

// clear applied force and control, call control callback if defined
void mj_solveControl(const mjModel* m, mjData* d, void* cbdata);

// compute actuator force
void mj_solveActuation(const mjModel* m, mjData* d);

// smooth dynamics: compute qvel_next before impulse
void mj_solveVelocity(const mjModel* m, mjData* d);

// forward impulse solver
void mj_solveImpulse(const mjModel* m, mjData* d);

// compute energy
void mj_solveEnergy(const mjModel* m, mjData* d);


//-------------------------------- integrators ------------------------------------

// integrate activation states
void mj_updateAct(const mjModel* m, mjData* d, mjtNum dt);

// integrate position
void mj_updatePos(const mjModel* m, mjData* d, mjtNum dt, int mode);

// Runge Kutta stepper (called from mj_step only)
void mj_RungeKutta(const mjModel* m, mjData* d, void* cbdata);


//-------------------------------- top-level API ----------------------------------

// forward dynamics
//  compute (qvel_next) given (qpos, qvel, act, ctrl)
void mj_forward(const mjModel* m, mjData* d, void* cbdata);

// advance simulation: use control callback, no external force
void mj_step(mjModel* m, mjData* d, void* cbdata);

// advance simulation in two steps: before external force [and control] is set by user
void mj_step1(const mjModel* m, mjData* d, void* cbdata);

// advance simulation in two steps: after external force [and control] is set by user
void mj_step2(const mjModel* m, mjData* d);
