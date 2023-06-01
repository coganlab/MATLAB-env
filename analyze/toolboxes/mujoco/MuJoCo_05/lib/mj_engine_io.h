/*********************************************
This file is part of the MuJoCo software.
Copyright 2013 Roboti LLC. All rights reserved.
**********************************************/


//------------------------------- mjOption ----------------------------------------------

// set model options to default values
void mj_defaultOption(mjOption* opt);


//------------------------------- mjModel -----------------------------------------------

// size of mjModel for serialization
int mj_sizeModel(const mjModel* m);

// allocate mjModel
mjModel* mj_makeModel(int nq, int nv, int nu2, int nu3, int nbody, int njnt, 
					  int ngeom, int nsite, 
					  int nmesh, int nmeshvert, int nmeshface, int nmeshaux,
					  int nhfield, int nhfielddata,
					  int ncpair, int neq, int ntendon, int nwrap, 
					  int ncustom, int ncustomdata, int nnames);

// copy mjModel
mjModel* mj_copyModel(mjModel* dest, const mjModel* src);

// set pointers in mjModel buffer
void mj_setPtrModel(mjModel* m);

// save model to binary file
void mj_saveModel(const mjModel* m, const char* filename, int szbuf, void* buf);

// load model from binary file
mjModel* mj_loadModel(const char* filename, int szbuf, void* buf);

// de-allocate model
void mj_deleteModel(mjModel* m);


//------------------------------- mjData ------------------------------------------------

// allocate mjData
mjData* mj_makeData(const mjModel* m);

// copy mjData
mjData* mj_copyData(mjData* dest, const mjModel* m, const mjData* src);

// set pointers in mjData buffer
void mj_setPtrData(const mjModel *m, mjData* d);

// set data to defaults
void mj_resetData(const mjModel* m, mjData* d, mjtByte clearpert);

// mjData stack allocate
mjtNum* mj_stackAlloc(mjData* d, int size);

// de-allocate data
void mj_deleteData(mjData* d);


//------------------------------- mjTrajectory ------------------------------------------

// allocate mjTrajectory, set pointers
mjTrajectory* mj_makeTrajectory(const mjModel* m, int nmax);

// copy relevant fields from mjData to mjTrajectory
void mj_addFrame(const mjData* d, mjTrajectory* trj);

// de-allocate mjTrajectory
void mj_deleteTrajectory(mjTrajectory* trj);