#ifndef __KALMAN_H__
#define __KALMAN_H__
typedef struct {
	double * mean;
	double * covariance;
} state;

typedef struct {
	double * A; // Transition matrix
	double * C; // Output matrix
	double * Q; // Transition noise
	double * R_inverse; // Inverse of output noise
	double * latent_mean; // mean of the latent state
	double * observe_mean; // mean of the observed data
	int N; // number of latent states
	int n; // number of latent states to decode, always at the end
	int M; // number of observed states
} params;

typedef struct{
	int forward_lags;
	int backward_lags;
} hyperparams;

void train(params * p, const double * joint_data, const double * neural_data, const int time_steps, const int neural_dims, const int joint_dims, const hyperparams * h);
void initialize(state * s, const params * p);
void decode(double * prediction, state * s, const double * neural_data, const params * p);
#endif