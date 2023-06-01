#include "mujoco.h"

void main(void)
{
	mjModel* m = mj_loadModel("test.mjb", 0, 0);
	mjData* d = mj_makeData(m);

	mj_step(m, d, 0);
	mj_printModel(m, "model.txt");
	mj_printData(m, d, "data.txt");

	mj_deleteModel(m);
	mj_deleteData(d);
}