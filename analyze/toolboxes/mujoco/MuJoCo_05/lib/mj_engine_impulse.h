/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/


// restrict all impulse elements to constraint set
void mj_projectF(const mjModel* m, mjData* d);


// diagonal solver
void mj_impulseDiagonal(const mjModel* m, mjData* d);

// Jacobi solver
void mj_impulseJacobi(const mjModel* m, mjData* d);

// Gauss-Seidel solver
//  phase: 0- all, 1- normal only, 2- contact friction only
void mj_impulseGS(const mjModel* m, mjData* d, int phase);

// (preconditioned) conjugate gradient solver
void mj_impulseCG(const mjModel* m, mjData* d);

// Newton solver
void mj_impulseNewton(const mjModel* m, mjData* d);
