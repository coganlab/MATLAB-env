/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/


//------------------------------ 3D vector and matrix-vector operations --------------

// set vector to zero
void mju_zero3(mjtNum* res);

// copy vector
void mju_copy3(mjtNum* res, const mjtNum* data);

// scale vector
void mju_scl3(mjtNum* res, const mjtNum* vec, mjtNum scl);

// add vectors
void mju_add3(mjtNum* res, const mjtNum* vec1, const mjtNum* vec2);

// subtract vectors
void mju_sub3(mjtNum* res, const mjtNum* vec1, const mjtNum* vec2);

// add to vector
void mju_addTo3(mjtNum* res, const mjtNum* vec);

// add scaled to vector
void mju_addToScl3(mjtNum* res, const mjtNum* vec, mjtNum scl);

// normalize vector, return length before normalization
mjtNum mju_normalize3(mjtNum* res);

// compute vector length (without normalizing)
mjtNum mju_norm3(const mjtNum* res);

// vector dot-product
mjtNum mju_dot3(const mjtNum* vec1, const mjtNum* vec2);

// Cartesian distance between 3D vectors
mjtNum mju_dist3(const mjtNum* pos1, const mjtNum* pos2);

// multiply vector by 3D rotation matrix
void mju_rotVecMat(mjtNum* res, const mjtNum* vec, const mjtNum* mat);

// multiply vector by transposed 3D rotation matrix
void mju_rotVecMatT(mjtNum* res, const mjtNum* vec, const mjtNum* mat);


//------------------------------ general vector operations ---------------------------

// set vector to zero
void mju_zero(mjtNum* res, int n);

// set matrix to diagonal
void mju_diag(mjtNum* mat, mjtNum value, int n);

// copy vector
void mju_copy(mjtNum* res, const mjtNum* data, int n);

// scale vector
void mju_scl(mjtNum* res, const mjtNum* vec, mjtNum scl, int n);

// add vectors
void mju_add(mjtNum* res, const mjtNum* vec1, const mjtNum* vec2, int n);

// subtract vectors
void mju_sub(mjtNum* res, const mjtNum* vec1, const mjtNum* vec2, int n);

// add to vector
void mju_addTo(mjtNum* res, const mjtNum* vec, int n);

// add scaled to vector
void mju_addToScl(mjtNum* res, const mjtNum* vec, mjtNum scl, int n);

// normalize vector, return length before normalization
mjtNum mju_normalize(mjtNum* res, int n);

// compute vector length (without normalizing)
mjtNum mju_norm(const mjtNum* res, int n);

// vector dot-product
mjtNum mju_dot(const mjtNum* vec1, const mjtNum* vec2, const int n);


//------------------------------ matrix-vector operations ----------------------------

// multiply matrix and vector
void mju_mulMatVec(mjtNum* res, const mjtNum* mat, const mjtNum* vec,
				   int nr, int nc);

// multiply transposed matrix and vector
void mju_mulMatTVec(mjtNum* res, const mjtNum* mat, const mjtNum* vec,
				    int nr, int nc);

// normalize columns of matrix
void mju_normalizeCol(mjtNum* mat, int nr, int nc);


//------------------------------ matrix-matrix operations ----------------------------

// transpose matrix
void mju_transpose(mjtNum* res, const mjtNum* mat, int r, int c);

// add transpose matrix to scaled matrix
void mju_transposeAdd(mjtNum* res, const mjtNum* mat, int r, int c);

// enforce symmetry
void mju_symmetrize(mjtNum* mat, int n);

// multiply matrices
void mju_mulMatMat(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
				   int r1, int c1, int c2);

// multiply matrices, second argument transposed
void mju_mulMatMatT(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
				    int r1, int c1, int r2);

// compute M*M'
void mju_mulMatMatT_Sqr(mjtNum* res, const mjtNum* mat, int r, int c,
						mjtNum* scratch, int szScratch);

// multiply matrices, first argument transposed
void mju_mulMatTMat(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
				    int r1, int c1, int c2);

// multiply matrices, sparse
void mju_mulMatMat_S(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
				     int r1, int c1, int c2, mjtNum* scratch, int szScratch);

// multiply matrices, second argument transposed, sparse
void mju_mulMatMatT_S(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
				      int r1, int c1, int r2, mjtNum* scratch, int szScratch);

// sparse symmetric matrix multiplication, second argument transposed
void mju_mulMatMatT_SS(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
					   int r, int c, mjtNum* scratch, int szScratch);

// sparse symmetric matrix multiplication, first argument transposed
void mju_mulMatTMat_SS(mjtNum* res, const mjtNum* mat1, const mjtNum* mat2,
					   int r, int c, mjtNum* scratch, int szScratch);

// rank-one update to symmetric matrix, enforce symmetry
void mju_rankOneUpdateSym(mjtNum* res, const mjtNum* vec1, const mjtNum* vec2, 
						  mjtNum scl, int n);


//------------------------------ tensor operations ----------------------------

// multiply vector by tensor, output matrix
void mju_multVecTens(mjtNum* res, const mjtNum* vec, const mjtNum* tens,
				   const int r, const int c, const int p);

// multiply vector by symmetric tensor, output symmetric matrix               
void mju_multVecSymTens(mjtNum* res, const mjtNum* vec, const mjtNum* tens,
				   const int r, const int c);               


//------------------------------ quaternion operations -----------------------------

// rotate vector by quaternion
void mju_rotVecQuat(mjtNum* res, const mjtNum* vec, const mjtNum* quat);

// muiltiply quaternions
void mju_mulQuat(mjtNum* res, const mjtNum* quat1, const mjtNum* quat2);

// negate quaternion
void mju_negQuat(mjtNum* res, const mjtNum* quat);

// convert axisAngle to quaternion
void mju_axisAngle2Quat(mjtNum* res, const mjtNum* axis, mjtNum angle);

// convert quaternion (corresponding to orientation difference) to 3D velocity
void mju_quat2Vel(mjtNum* res, const mjtNum* quat, mjtNum dt);

// convert quaternion to 3D rotation matrix
void mju_quat2Mat(mjtNum* res, const mjtNum* quat);

// convert 3D rotation matrix to quaterion
void mju_mat2Quat(mjtNum* quat, const mjtNum* mat);

// time-derivative of quaternion, given 3D rotational velocity
void mju_derivQuat(mjtNum* res, const mjtNum* quat, const mjtNum* vel);

// integrate quaterion given 3D angular velocity
void mju_quatIntegrate(mjtNum* quat, const mjtNum* vel, mjtNum scale);

// compute quaternion performing rotation from given vector to z-axis
void mju_quatZ2Vec(mjtNum* quat, const mjtNum* vec);


//------------------------------ spatial algebra --------------------------------

// vector cross-product, 3D
void mju_cross(mjtNum* res, const mjtNum* a, const mjtNum* b);

// cross-product for motion vector
void mju_crossMotion(mjtNum* res, const mjtNum* vel, const mjtNum* v);

// cross-product for force vectors
void mju_crossForce(mjtNum* res, const mjtNum* vel, const mjtNum* f);

// express inertia in com-based frame
void mju_inertCom(mjtNum* res, const mjtNum* inert, const mjtNum* mat,
				  const mjtNum* dif, mjtNum mass);

// express motion axis in com-based frame
void mju_dofCom(mjtNum* res, const mjtNum* axis, const mjtNum* offset);

// multiply 6D vector (rotation, translation) by 6D inertia matrix
void mju_mulInertVec(mjtNum* res, const mjtNum* inert, const mjtNum* vec);

// multiply dof matrix by vector
void mju_mulDofVec(mjtNum* res, const mjtNum* mat, const mjtNum* vec, int n);

// transform 6D motion or force vector between frames
//  rot is 3-by-3 matrix; flg_force determines vector type (motion or force)
void mju_transformSpatial(mjtNum* res, const mjtNum* vec, mjtByte flg_force,
						  const mjtNum* newpos, const mjtNum* oldpos, 
						  const mjtNum* rotnew2old);


//------------------------------ tendon wrapping ------------------------------

// wrap tendons around spheres and cylinders
mjtNum mju_wrap(mjtNum* wpnt, const mjtNum* x0, const mjtNum* x1, 
			    const mjtNum* xpos, const mjtNum* xmat, const mjtNum* size, 
				int type, const mjtNum* side);


//------------------------------ linear solvers -------------------------------

// Cholesky decomposition
int mju_cholFactor(mjtNum* mat, mjtNum* diag, int n, 
				   mjtNum minabs, mjtNum minrel, mjtNum* correct);

// Cholesky backsubstitution (or half of it)
void mju_cholBacksub(mjtNum* res, const mjtNum* mat, const mjtNum* vec,
					 int n, int nvec, mjtByte half);

// sparse Cholesky decomposition and backsubstitution... separate ???
int mju_solverChol_S(mjtNum* res, mjtNum* mat, const mjtNum* vec,
				   int n, int nSparse, int nBand, mjtNum minval);

// linear solver, indexed matrix... separate ???
void mju_solverIndex(mjtNum* res, const mjtNum* matbig, mjtNum* vec, mjtNum Rrel,
					 int* ir, int* ic, int nr, int nc, int ncbig, 
					 mjtNum* scratch, int szScratch);


//------------------------------ matrix decompositions ------------------------

// eigenvalue decomposition of symmetric 3x3 matrix
int mju_eig3(mjtNum* eigval, mjtNum* eigvec, mjtNum* quat, const mjtNum* mat);

// singular value decomposition of 3x3 matrix
void mju_svd3(mjtNum* U, mjtNum* s, mjtNum* V, const mjtNum* mat);


//------------------------------ miscellaneous --------------------------------

// make 3D frame given X axis (and possibly Y axis)
void mju_makeFrame(mjtNum* frame);

// clamp value to non-negative
mjtNum mju_clampPlus(mjtNum x, mjtNum beta2);

// clamp value to range [-limit, +limit]
mjtNum mju_clampRange(mjtNum x, mjtNum limit, mjtNum beta2);

// enforce friction cone
void mju_clampCone(mjtNum* f, const mjtNum* friction, int dim, mjtNum beta2);

// hard-clamp vector to range [-limit(i), +limit(i)]
void mju_clampVec(mjtNum* vec, const mjtNum* limit, int n);

// compute desired/minimal next-state velocity of critically-damped spring
mjtNum mju_errReduce(mjtNum pos, mjtNum vel, mjtNum tau, mjtNum dt, mjtByte onesided);

// muscle FVL curve
mjtNum mju_muscle(mjtNum len, mjtNum len0, mjtNum vel, mjtNum* prm);

// pneumatic cylinder dynamics
mjtNum mju_pneumatic(mjtNum len, mjtNum len0, mjtNum vel, mjtNum* prm,
					 mjtNum act, mjtNum ctrl);

// print matrix to screen
void mju_matPrint(const mjtNum* mat, int nr, int nc);

// min function, single evaluation of a and b
mjtNum mju_min(mjtNum a, mjtNum b);

// max function, single evaluation of a and b
mjtNum mju_max(mjtNum a, mjtNum b);

// sign function
mjtNum mju_sign(mjtNum x);

// round to nearest integer
int mju_round(mjtNum x);

// convert type id to type name
const char* mju_type2Str(int type);

// convert type id to type name
mjtObj mju_str2Type(const char* str);

// max and min macros are not always defined
#define max(a,b)    (((a) > (b)) ? (a) : (b))
#define min(a,b)    (((a) < (b)) ? (a) : (b))
