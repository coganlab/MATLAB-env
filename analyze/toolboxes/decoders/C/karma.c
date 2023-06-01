#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "karma.h"
#include "util.h"

// int count_features(struct svm_node * s) {
// 	int i;
// 	for(i=0; s[i].index != -1; i++) {}
// 	return i;
// }

// double * features_to_array(struct svm_node * s, int n) {
// 	double * A = Malloc(n, double);
// 	int i;
// 	for(i=0; i<n; i++) {
// 		A[i] = s[i].value;
// 	}
// 	return A;
// }

void train(params * p, const double * joint_data, const double * neural_data, const int time_steps, const int neural_dims, const int joint_dims, const hyperparams * h) {
	p->n = h->n; // Number of lags for joint data.  If equal to 0, means we predict based on neural data alone.
	p->m = h->m; // Number of lags for neural data.  If equal to 0, means we predict from only instantaneous neural data.
	int mn = max(p->m, p->n);
	int ntrain = time_steps - mn;
	p->N = joint_dims;
	p->M = neural_dims;
	p->latent_mean  = Calloc(joint_dims, double);
	p->latent_std   = Calloc(joint_dims, double);
	p->observe_mean = Calloc(neural_dims, double);
	p->observe_std  = Calloc(neural_dims, double);
	int i, j;

	// compute mean of joint and neural data
	for (i=0; i<time_steps; i++) {
		for (j=0; j<joint_dims; j++) {
			double k = joint_data[j + i * joint_dims];
			p->latent_mean[j] += k/time_steps;
		}

		for (j=0; j<neural_dims; j++) {
			double k = neural_data[j + i * neural_dims];
			p->observe_mean[j] += k/time_steps;
		}
	}

	// compute variance of joint and neural data
	for (i=0; i<time_steps; i++) {
		for (j=0; j<joint_dims; j++) {
			double k = joint_data[j + i * joint_dims] - p->latent_mean[j];
			p->latent_std[j] += k*k/(time_steps-1);
		}

		for (j=0; j<neural_dims; j++) {
			double k = neural_data[j + i * neural_dims] - p->observe_mean[j];
			p->observe_std[j] += k*k/(time_steps-1);
		}
	}

	// convert variance to standard deviation
	for (j=0; j<joint_dims; j++) {
		p->latent_std[j] = sqrt(p->latent_std[j]);
	}
	for (j=0; j<neural_dims; j++) {
		p->observe_std[j] = sqrt(p->observe_std[j]);
	}

	// subtract off means and divide by stds
	double * scaled_joint_data = Malloc (time_steps*joint_dims, double);
	double * scaled_neural_data = Malloc (time_steps*neural_dims, double);
	for (i=0; i<time_steps; i++) {
		for (j=0; j<joint_dims; j++) {
			scaled_joint_data[j + i * joint_dims] = (joint_data[j + i * joint_dims] - p->latent_mean[j])/p->latent_std[j];
		}
		for (j=0; j<neural_dims; j++) {
			scaled_neural_data[j + i * neural_dims] = (neural_data[j + i * neural_dims] - p->observe_mean[j])/p->observe_std[j];
		}
	}

	// Assign training labels to libsvm data structures
	struct svm_problem prob;
	prob.l = ntrain;
	double **y = Malloc (p->N, double *);
	for (i=0; i<joint_dims; i++) {
		y[i] = Malloc(ntrain, double);
		for (j=0; j<ntrain; j++) {
			y[i][j] = scaled_joint_data[i + (j + mn) * joint_dims];
		}
	}

	// Count the number of nonzero features
	int elements = 0;
	for (i=0; i<ntrain; i++) {
		for (j=0; j<(p->m+1)*p->M; j++) {
			if (scaled_neural_data[j + (i + mn - p->m) * (p->M)] != 0)
				elements++;	
		}
		for (j=0; j<p->n*p->N; j++) {
			if (scaled_joint_data[j + (i + mn - p->n) * (p->N)] != 0)
				elements++;
		}
		elements++; // Add count for -1 index, used to mark the break between feature vectors
	}
	prob.x = Malloc(ntrain, struct svm_node *);
	svm_node * x_space = Malloc(elements, svm_node);

	// Assign training features to libsvm data structure
	int idx = 0;
	double val;
	for (i=0; i<ntrain; i++) {
		prob.x[i] = &x_space[idx];
		for (j=0; j<(p->m+1)*p->M; j++) {
			val = scaled_neural_data[j + (i + mn - p->m) * (p->M)];
			if (val != 0) {
				x_space[idx].value = val;
				x_space[idx].index = j + 1;
				idx++;
			}
		}
		for (j=0; j<p->n*p->N; j++) {
			val = scaled_joint_data[j + (i + mn - p->n) * (p->N)];
			if (val != 0) {
				x_space[idx].value = val;
				x_space[idx].index = j + (p->m + 1) * (p->M) + 1;
				idx++;
			}
		}
		x_space[idx++].index = -1;
	}

	p->models = Malloc(joint_dims, struct svm_model *);
	for (i=0; i<joint_dims; i++) {
		prob.y = y[i];
		p->models[i] = svm_train(&prob, &(h->param)); // This is where all the actual learning happens
		free(y[i]);
	}
	free(y);
	free(scaled_neural_data);
	free(scaled_joint_data);
}

void initialize(state * s, const params * p) {
	s->x = Calloc((p->n*p->N + (p->m+1)*p->M + 1), struct svm_node);
	int i;
	for(i=0; i<p->n*p->N + (p->m+1)*p->M; i++) {
		s->x[i].index = i+1;
	}
	s->x[i].index = -1;
}

void decode(double * prediction, state * s, const double * neural_data, const params * p, int n) {
	//Update the neural state
	int i;
	for (i=0; i<p->M * p->m; i++) {
		s->x[i].value = s->x[i + p->M].value;
	}
	for (i=0; i<p->M; i++) {
		s->x[i + (p->M * p->m)].value = (neural_data[i] - p->observe_mean[i])/p->observe_std[i];
	}

	for (i=0; i<p->N; i++) {
		prediction[i] = svm_predict(p->models[i], s->x); // All the actual prediction happens here.  This is the bottleneck
	}

	// Update the joint state
	for (i=0; i<p->N * (p->n - 1); i++) {
		s->x[i + (p->m + 1)*p->M].value = s->x[i + p->m*p->M + p->N].value;
	}
	for (i=0; i<p->N; i++) {
		s->x[i + (p->m + 1)*p->M + (p->N * (p->n - 1))].value = prediction[i];
	}

	// Un-scale the prediction
	for (i=0; i<p->N; i++) {
		prediction[i] = p->latent_std[i]*prediction[i] + p->latent_mean[i];
	}
}

void set_default(hyperparams * h) {
	h->m = 2;
	h->n = 2;
	h->param.svm_type = EPSILON_SVR;
	h->param.kernel_type = RBF;
	h->param.degree = 3;
	h->param.gamma = 0.001;	// 1/num_features
	h->param.coef0 = 0;
	h->param.nu = 0.5;
	h->param.cache_size = 100;
	h->param.C = 1;
	h->param.eps = 1e-3;
	h->param.p = 0.1;
	h->param.shrinking = 0;
	h->param.probability = 0;
	h->param.nr_weight = 0;
	h->param.weight_label = NULL;
	h->param.weight = NULL;
}

int main(int argc, char **argv) {
	hyperparams h;
	set_default(&h);
	params p;
	int time_steps = atoi(argv[1]);
	int joint_dims = atoi(argv[2]);
	int neural_dims = atoi(argv[3]);
	h.n = atoi(argv[4]);
	h.m = atoi(argv[5]);
	double * joint_data = rand_array(time_steps * joint_dims);
	double * neural_data = rand_array(time_steps * neural_dims);
	train(&p, joint_data, neural_data, time_steps, neural_dims, joint_dims, &h);
	state s;
	initialize(&s, &p);
	int i;
	double * prediction = Malloc(10*joint_dims, double);
	for (i=0; i<10; i++) {
		decode(prediction + i * joint_dims, &s, neural_data + i * neural_dims, &p, i);
	}
	free(joint_data);
	free(neural_data);
	return 1;
}
