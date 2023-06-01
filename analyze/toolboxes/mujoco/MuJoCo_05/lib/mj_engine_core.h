/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/


//-------------------------- kinematics -------------------------------------------------

// forward kinematics
void mj_kinematics(const mjModel* m, mjData* d);

// map inertias and motion dofs to global frame centered at CoM
void mj_com(const mjModel* m, mjData* d);


// compute tendon lengths, velocities and moment arms
void mj_tendon(const mjModel* m, mjData* d);

// compute actuator transmission lengths and moments
void mj_transmission(const mjModel* m, mjData* d);


//-------------------------- smooth dynamics --------------------------------------------

// recursive Newton-Euler algorithm
void mj_rne(const mjModel* m, mjData* d, const mjtNum* qacc);

// composite rigid body inertia algorithm
void mj_crb(const mjModel* m, mjData* d);

// sparse L'*D*L factorizaton of the inertia matrix M, assumed spd
void mj_factorM(const mjModel* m, mjData* d);

// sparse backsubstitution:  x = inv(L'*D*L)*y
void mj_backsubM(const mjModel* m, mjData* d, mjtNum* x, const mjtNum* y, int n);

// half of sparse backsubstitution:  x = sqrt(inv(D))*inv(L')*y
void mj_backsubM2(const mjModel* m, mjData* d, mjtNum* x, const mjtNum* y, int n);

// half of sparse backsubstitution of impulse Jacobian
void mj_backsubM2Jac(const mjModel* m, mjData* d, mjtNum* res);

// spring-damper forces
void mj_passive(const mjModel* m, mjData* d);


//-------------------------- constraints and impulses -----------------------------------

// equality constraints: compute eq_err and eq_J
void mj_makeConstraint(const mjModel* m, mjData* d);

// projections involving constraint Jacobian
void mj_projectConstraint(const mjModel* m, mjData* d);

// project qvel_next to equality constraints: impose eq_vdes
void mj_imposeConstraint(const mjModel* m, mjData* d);

// add a contact to mjData (utility function)
//  result: 1=error (too many contacts), 0=success
int mj_addContact(const mjModel* m, mjData* d, const mjContact* con);

// add row to sparse flc_J; return 1 if successful, 0 if out of space
int mj_addJrow(const mjModel* m, mjData* d, const mjtNum* row);

// include frictional dofs in impulse solver data structures
void mj_instantiateFriction(const mjModel* m, mjData* d);

// include limits in impulse solver data structures
void mj_instantiateLimits(const mjModel* m, mjData* d);

// include contacts in impulse solver data structures
void mj_instantiateContacts(const mjModel* m, mjData* d);

// impulses: compute lc_dist, xconpenetration, contact frame, Jacobian
void mj_makeImpulse(const mjModel* m, mjData* d);

// projections involving impulse Jacobian
void mj_projectImpulse(const mjModel* m, mjData* d);

// compute lc_vmin, flc_v0, flc_b for latest qvel_next
void mj_impulseVel(const mjModel* m, mjData* d);
