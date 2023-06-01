/*******************************************
This file is part of the MuJoCo software.
(C) 2012 Emo Todorov. All rights reserved.
*******************************************/


// test all enabled geom pairs
void mj_collideAll(const mjModel* m, mjData* d);

// broadphase collision detection system
void mj_broadphase(const mjModel* m, mjData* d);

// test two geoms for collision; g2<0 means g1 is a geom pair address
void mj_collideGeoms(const mjModel* m, mjData* d, int g1, int g2);


// collision function pointers and max contact pairs
extern mjfConFn mjCOLLISIONFUNCTIONS[mjNGEOMTYPES][mjNGEOMTYPES];
extern int mjCOLLISIONMAX[mjNGEOMTYPES][mjNGEOMTYPES];


// plane collisions
int mjc_PlaneSphere		(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);
int mjc_PlaneCapsule	(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);
int mjc_PlaneCylinder	(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);
int mjc_PlaneBox		(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);
int mjc_PlaneConvex		(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);

// heightfield collisions
int mjc_ConvexHField	(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);

// sphere collisions
int mjc_SphereSphere	(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);
int mjc_SphereCapsule	(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);

// capsule collisions
int mjc_CapsuleCapsule	(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);

// general convex collisions
int mjc_Convex			(const mjModel* m, const mjData* d, mjContact* con,  
						 int g1, int g2, mjtNum mindist);


// define and extract geom info
#define mjGETINFO \
	mjtNum* pos1 = d->geom_xpos + 3*g1; \
	mjtNum* mat1 = d->geom_xmat + 9*g1; \
	mjtNum* size1= m->geom_size + 3*g1; \
	mjtNum* pos2 = d->geom_xpos + 3*g2; \
	mjtNum* mat2 = d->geom_xmat + 9*g2; \
	mjtNum* size2= m->geom_size + 3*g2;
