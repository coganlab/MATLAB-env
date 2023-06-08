/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/


// names of disable flags
extern const char* mjDISABLESTRING[mjNDISABLE];

// names of timers
extern const char* mjTIMERSTRING[mjNTIMER];


//-------------------------- Jacobians --------------------------------------------------

// compute 3/6-by-nv Jacobian of given point (local or global) on given body
void mj_jac(const mjModel* m, const mjData* d, mjtNum* jacp, mjtNum* jacr,
			const mjtNum* point, int body);

// compute body frame Jacobian
void mj_jacBody(const mjModel* m, const mjData* d, mjtNum* jacp, mjtNum* jacr, int body);

// compute body center-of-mass Jacobian
void mj_jacBodyCom(const mjModel* m, const mjData* d, mjtNum* jacp, mjtNum* jacr, int body);

// compute geom Jacobian
void mj_jacGeom(const mjModel* m, const mjData* d, mjtNum* jacp, mjtNum* jacr, int geom);

// compute site Jacobian
void mj_jacSite(const mjModel* m, const mjData* d, mjtNum* jacp, mjtNum* jacr, int site);

// compute translation Jacobian of point, and rotation Jacobian of axis
void mj_jacPointAxis(const mjModel* m, mjData* d, mjtNum* jacPoint, mjtNum* jacAxis, 
					 const mjtNum* point, const mjtNum* axis, int body);


//-------------------------- sparse impulse Jacobians -----------------------------------

// multiply Jacobian by vector
void mj_mulJacVec(const mjModel* m, mjData* d, mjtNum* res, const mjtNum* vec);

// multiply JacobianT by vector
void mj_mulJacTVec(const mjModel* m, mjData* d, mjtNum* res, const mjtNum* vec);


//-------------------------- name functions ---------------------------------------------

// get id of object with specified name; -1: not found
int mj_name2Id(const mjModel* m, mjtObj type, const char* name);

// get name of object with specified id; 0: invalid type or id
const char* mj_id2Name(const mjModel* m, mjtObj type, int id);


//-------------------------- inertia functions ------------------------------------------

// convert sparse inertia matrix M into full matrix
void mj_fullM(const mjModel* m, const mjData* d, mjtNum* dst, const mjtNum* M);

// convert full inertia matrix M into sparse matrix
void mj_sparseM(const mjModel* m, const mjData* d, mjtNum* dst, const mjtNum* M);

// dense backsubstitution:  x = inv(L'*D*L)*y
void mj_backsubFull(const mjModel* m, const mjData* d, const mjtNum* mat,
					mjtNum* x, const mjtNum* y);

// multiply (A + R) by vector
void mj_mulAVec(const mjModel* m, mjData* d, mjtNum* res, const mjtNum* vec);


//-------------------------- perturbations ----------------------------------------------

// apply cartesian force and torque
void mj_applyFT(const mjModel* m, mjData* d, const mjtNum* force, const mjtNum* torque,
			    const mjtNum* point, int body, mjtNum* qfrc_target);

// accumulate active perturbations in qfrc_target
void mj_accumulatePerturb(const mjModel* m, mjData* d, mjtNum* qfrc_target);


//-------------------------- local vel, acc, frc ----------------------------------------

// rne with complete data: compute cacc, cfrc_ext, cfrc_int
void mj_rnePost(const mjModel* m, mjData* d);

// get object 6D velocity/acceleration, object-centered, world/local orientation
void mj_objectMotion(const mjModel* m, const mjData* d, int objtype, int objid, 
					 mjtNum* res, mjtByte flg_acc, mjtByte flg_local);

// get 6D interaction force to parent body, in parent/child frame
void mj_bodyForce(const mjModel* m, const mjData* d, int bodyid, 
				  mjtNum* res, mjtByte flg_child);


//-------------------------- miscellaneous ----------------------------------------------

// compute velocity by finite-differencing two positions
void mj_differencePos(const mjModel* m, mjtNum* qvel, mjtNum dt,
					  const mjtNum* qpos1, const mjtNum* qpos2);

// integrate position
void mj_integratePos(const mjModel* m, mjtNum* qpos, const mjtNum* qvel, mjtNum dt);

// set _reflen fields from current qpos
void mj_setReflen(mjModel* m, mjData* d);

// set _invweight fields from current qpos
void mj_setInvweight(mjModel* m, mjData* d);

// compute lines of action for all actuators on given body and point
void mj_actionLines(const mjModel* m, mjData* d, mjtNum* lines, 
					const mjtNum* point, int body);

// map from body local to global Cartesian coordinates
void mj_local2Global(const mjModel* m, mjData* d, mjtNum* xpos, mjtNum* xmat, 
					 const mjtNum* pos, const mjtNum* quat, int body);

// sum all body masses
mjtNum mj_getTotalMass(const mjModel* m);

// scale body masses and inertias to achieve specified total mass
void mj_setTotalMass(mjModel* m, mjtNum newmass);

// count warnings, print only the first time
void mj_warning(mjData* d, int warning, const char* msg);

// effective atype: larger of given and minimum required
int mj_atype(const mjModel* m);

// compute spatial dimensions:  sizes[3] = (bounding box, max segment, max geom)
void mj_spatial(const mjModel* m, const mjData* d, mjtNum* center, mjtNum* sizes);
