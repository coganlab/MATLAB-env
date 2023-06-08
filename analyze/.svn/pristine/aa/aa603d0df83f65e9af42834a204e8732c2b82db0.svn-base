#include <stdlib.h>
#include <stdio.h>
#include "kalman.h"
#include "util.h"

void inverse(double * A, int N) {
    int *IPIV = (int*) malloc ((N+1)*sizeof(int));
    int LWORK = N*N;
    double *WORK = (double*) malloc (LWORK*sizeof(double));
    int INFO;

    dgetrf_(&N,&N,A,&N,IPIV,&INFO);
    dgetri_(&N,A,&N,IPIV,WORK,&LWORK,&INFO);

    free(IPIV);
    free(WORK);
}

void train(params * p, const double * joint_data, const double * neural_data, const int time_steps, const int neural_dims, const int joint_dims, const hyperparams * h) {
	int lags = h->forward_lags + h->backward_lags;
	p->M = neural_dims;
	p->N = joint_dims * (lags + 1);
	p->latent_mean = Calloc(p->N, double);
	p->observe_mean = Calloc(p->M, double);

	// Stack time-shifted versions of input to compute AR(K) model of joint kinematics and subtract mean
	double * stacked_joint_data = (double *) malloc ((time_steps - lags)*p->N*sizeof(double));
	int i, j;
	for (i=0; i<time_steps-lags; i++) {
		for (j=0; j<p->N; j++) {
			stacked_joint_data[j + i * p->N] = joint_data[j + i * joint_dims];
			p->latent_mean[j]               += joint_data[j + i * joint_dims];
		}
	}
	for (j=0; j<p->N; j++) {
		p->latent_mean[j] /= time_steps - lags;
	}
	for (i=0; i<time_steps-lags; i++) {
		for (j=0; j<p->N; j++) {
			stacked_joint_data[j + i * p->N] -= p->latent_mean[j];
		}
	}

	// Subtract mean off neural data
	double * zero_mean_neural_data = (double *) malloc (p->M*time_steps*sizeof(double));
	for (i=0; i<time_steps; i++) {
		for (j=0; j<p->M; j++) {
			p->observe_mean[j] += neural_data[j + i * p->M];
		}
	}
	for (j=0; j<p->M; j++) {
		p->observe_mean[j] /= time_steps;
	}
	for (i=0; i<time_steps; i++) {
		for (j=0; j<p->M; j++) {
			zero_mean_neural_data[j + i * p->M] = neural_data[j + i * p->M] - p->observe_mean[j];
		}
	}

	// Compute transition matrix p->A by least squares.  Note: should compare against dgelsd_().
	double one = 1;
	double neg = -1;
	int n = time_steps - lags - 1;
	double * A = allocate_and_transpose(p->N, n, p->N, stacked_joint_data );  // Some pointer arithmetic to skip the first column of stacked_joint_data
	double * B = allocate_and_transpose(p->N, n, p->N, stacked_joint_data + p->N); // skip the last column of stacked_joint_data
	int lwork = -1; // Assume optimum block size of 16.  I'm really just guessing here.
	int info;
	double wkopt;
	dgels_("No transpose", &n, &(p->N), &(p->N), A, &n, B, &n, &wkopt, &lwork, &info); // Query optimal size of workspace
	lwork = (int)wkopt;
	double * work = (double *) malloc (lwork*sizeof(double));
	dgels_("No transpose", &n, &(p->N), &(p->N), A, &n, B, &n, work, &lwork, &info); // Solve overdetermined linear system for transition matrix
	free(work);
	p->A = allocate_and_transpose(p->N, p->N, n, B);

	// Compute residual of regression solution and use it to compute transition noise
	// Reset values of A and B
	for (i=0; i<n; i++) {
		for (j=0; j<p->N; j++) {
			A[j + i * p->N] = stacked_joint_data[j + i * p->N];
			B[j + i * p->N] = stacked_joint_data[j + (i+1) * p->N];
		}
	}
	dgemm_("No transpose", "No transpose", &(p->N), &n, &(p->N), &neg, p->A, &(p->N), A, &(p->N), &one, B, &(p->N)); // Set B equal to residual of regression
	p->Q = Calloc(p->N*p->N, double);
	double one_over_n = 1.0/(n+1);
	dgemm_("No transpose", "Transpose", &(p->N), &(p->N), &n, &one_over_n, B, &(p->N), B, &(p->N), &one, p->Q, &(p->N));
	free(A);
	free(B);

	// Compute observation matrix p->C by least squares.
	n = time_steps - lags;
	A = allocate_and_copy(p->N*n, stacked_joint_data);
	B = allocate_and_transpose(p->M, n, p->M, zero_mean_neural_data + h->backward_lags * p->M);
	lwork = -1;
	dgels_("Transpose", &(p->N), &n, &(p->M), A, &(p->N), B, &n, &wkopt, &lwork, &info); // Query optimal workspace size
	lwork = (int)wkopt;
	work = (double *) malloc (lwork*sizeof(double));
	dgels_("Transpose", &(p->N), &n, &(p->M), A, &(p->N), B, &n, work, &lwork, &info); // Solve overdetermined linear system for observation matrix
	free(work);
	p->C = allocate_and_transpose(p->N, p->M, n, B);
	free(A);

	// Compute residual of regression and use it to compute observation noise
	for (i=0; i<n; i++) {
		for (j=0; j<p->M; j++) {
			B[j + i * p->M] = zero_mean_neural_data[j + (i + h->backward_lags) * p->M];
		}
	}
	dgemm_("No transpose", "No transpose", &(p->M), &n, &(p->N), &neg, p->C, &(p->M), stacked_joint_data, &(p->N), &one, B, &(p->M));
	p->R_inverse = Calloc(p->M*p->M, double);
	dgemm_("No transpose", "Transpose", &(p->M), &(p->M), &n, &one_over_n, B, &(p->M), B, &(p->M), &one, p->R_inverse, &(p->M));
	inverse(p->R_inverse, p->M);

	free(B);
	free(stacked_joint_data);
	free(zero_mean_neural_data);
}

void initialize(state * s, const params * p) {
	s->mean = Calloc(p->N, double);
	s->covariance = allocate_and_copy(p->N * p->N, p->Q);
}

void decode(double * prediction, state * s, const double * neural_data, const params * p) {
	// Declare a whole bunch of things explicitly because everything in BLAS is pass by reference (thanks, FORTRAN)
	double ONE = 1.0;
	double NEG = -1.0;
	int INC = 1;

	// Compute mean of forward prediction
	double * z = Calloc(p->N, double);
	dgemv_("No transpose", &(p->N), &(p->N), &ONE, p->A, &(p->N), s->mean, &INC, &ONE, z, &INC);

	// Compute covariance of forward prediction
	double * P = Calloc(p->N * p->N, double);
	dsymm_("Right", "Upper", &(p->N), &(p->N), &ONE, s->covariance, &(p->N), p->A, &(p->N), &ONE, P, &(p->N)); // P = p->A * s->covariance
	int i;
	for (i=0; i<p->N*p->N; i++) {
		s->covariance[i] = p->Q[i]; // In BLAS matrix multiplication, A*B + C changes C.  We want to change A instead.
	}
	dgemm_("No transpose", "Transpose", &(p->N), &(p->N), &(p->N), &ONE, P, &(p->N), p->A, &(p->N), &ONE, s->covariance, &(p->N)); // s->covariance = P * p->A' + p->Q 

	// Compute residual
	double * r = (double *) malloc (p->M*sizeof(double));
	for (i=0; i<p->M; i++) {
		r[i] = neural_data[i] - p->observe_mean[i];
	}
	dgemv_("No transpose", &(p->M), &(p->N), &NEG, p->C, &(p->M), z, &INC, &ONE, r, &INC);

	// Compute S^-1 = (C*P*C' + R)^-1, but rather involved because we use the Woodbury lemma.
	double * S = Calloc(p->M * p->N, double); // Shorthand for R^-1*C
	dsymm_("Left", "Upper", &(p->M), &(p->N), &ONE, p->R_inverse, &(p->M), p->C, &(p->M), &ONE, S, &(p->M));
	for (i=0; i<p->N*p->N; i++) {
		P[i] = s->covariance[i];
	}
	inverse(P, p->N);
	dgemm_("Transpose", "No transpose", &(p->N), &(p->N), &(p->M), &ONE, p->C, &(p->M), S, &(p->M), &ONE, P, &(p->N));
	inverse(P, p->N); // (P^-1 + C'*R^-1*C)^-1
	double * K = Calloc(p->M * p->N, double);
	dsymm_("Right", "Upper", &(p->M), &(p->N), &ONE, P, &(p->N), S, &(p->M), &ONE, K, &(p->M));
	double * W = allocate_and_copy(p->M * p->M, p->R_inverse);
	dgemm_("No tranpose", "Transpose", &(p->M), &(p->M), &(p->N), &NEG, K, &(p->M), S, &(p->M), &ONE, W, &(p->M));

	// Compute Kalman gain
	for(i=0; i<p->M*p->N; i++) {
		S[i] = 0;
		K[i] = 0;
	}
	dsymm_("Right", "Upper", &(p->M), &(p->N), &ONE, s->covariance, &(p->N), p->C, &(p->M), &ONE, S, &(p->M)); // S = C*P
	dgemm_("Transpose", "No transpose", &(p->N), &(p->M), &(p->M), &ONE, S, &(p->M), W, &(p->M), &ONE, K, &(p->N)); // K = S'*W

	// Compute new mean and covariance
	dgemv_("No tranpose", &(p->N), &(p->M), &ONE, K, &(p->N), r, &INC, &ONE, z, &INC);
	for (i=0; i<p->M*p->N; i++) {
		S[i] = 0;
	}
	dsymm_("Right", "Upper", &(p->M), &(p->N), &ONE, s->covariance, &(p->N), p->C, &(p->M), &ONE, S, &(p->M));
	dgemm_("No transpose", "No transpose", &(p->N), &(p->N), &(p->M), &NEG, K, &(p->N), S, &(p->M), &ONE, s->covariance, &(p->N));

	// Free memory and assign new state values
	free(s->mean);
	s->mean = z;

	free(P);
	free(K);
	free(S);
	free(r);
	free(W);

	// Copy relevant section of the state as the prediction
	for(i=0; i<p->n; i++) {
		prediction[i] = s->mean[i + p->N - p->n];
	}
}

int main(int argc, char * argv[]) {
	int time_steps = atoi(argv[1]);
	int neural_dims = atoi(argv[2]);
	int joint_dims = atoi(argv[3]);
	hyperparams * h = malloc (2*sizeof(int));
	if (argc > 4) {
		h->forward_lags = atoi(argv[4]);
		h->backward_lags = atoi(argv[5]);
	} else {
		h->forward_lags = 0;
		h->backward_lags = 0;
	}
	params * p = malloc (2*sizeof(int) + 6*sizeof (double *));
	double * j = rand_array(joint_dims*time_steps);
	double * n = rand_array(neural_dims*time_steps);
	train(p, j, n, time_steps, neural_dims, joint_dims, h);
	state * s = malloc (2*sizeof(double *));
	initialize(s, p);
	int i;
	double * prediction = (double *) malloc (p->N*sizeof(double));
	for (i=0; i<time_steps; i++) {
		printf("%d\n",i);
		decode(prediction, s, n + i*neural_dims, p);
	}
	free(prediction);
	free(j);
	free(n);
	free(p);
	free(h);
	return 1;
}