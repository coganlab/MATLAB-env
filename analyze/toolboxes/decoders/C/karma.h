#ifndef __KARMA_H__
#define __KARMA_H__

#include "libsvm-3.11/svm.h"

typedef struct {
	struct svm_node * x;
} state;

typedef struct {
	int n; // number of lags of latent state
	int N; // number of latent states
	int m; // number of lags of observed state
	int M; // number of observed states
	double * latent_mean;
	double * latent_std;
	double * observe_mean;
	double * observe_std;
	struct svm_model **models; // One model for each DoF we're decoding
} params;

typedef struct{
	int n; // number of lags of latent state
	int m; // number of lags of observed state
	struct svm_parameter param; // everything else taken care of by libsvm
} hyperparams;

void train(params * p, const double * joint_data, const double * neural_data, const int time_steps, const int neural_dims, const int joint_dims, const struct svm_parameter * param, const int n, const int m);
void initialize(state * s, const params * p);
void decode(double * prediction, state * s, const double * neural_data, const params * p, int n);
#endif