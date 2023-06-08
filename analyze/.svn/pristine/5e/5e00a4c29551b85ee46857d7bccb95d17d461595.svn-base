#include <stdlib.h>
#include <stdio.h>

void print_matrix(int M, int N, double * A) {
	// Print column-major order matrix with M rows and N columns
	int i, j;
	printf("[\t");
	for (i=0; i<M; i++) {
		if (i>0) {
			printf("\t");
		}
		for (j=0; j<N; j++) {
			printf("%4.2e\t", A[i + j * M]);
		}
		if (i<M-1) {
			printf("\n");
		}
	}
	printf("]\n");
}

void dlmwrite(char * fname, double * A, int M, int N) {
	// Write matrix to file in CSV format, easily read into Matlab via dlmread
	FILE *out;
	out = fopen(fname, "w");
	if (out != NULL) {
		int i, j;
		for (i=0; i<M; i++) {
			for (j=0; j<N; j++) {
				if (j<N-1) {
					fprintf(out, "%e,", A[i + j * M]);
				} else {
					fprintf(out, "%e\n", A[i + j * M]);
				}
			}
		}
	}
	fclose(out);
}

double * allocate_and_copy(int N, const double * d) {
	double * a = (double *) malloc (N*sizeof(double));
	int i;
	for(i=0; i<N; i++) {
		a[i] = d[i];
	}
	return a;
}

double * allocate_and_transpose(int M, int N, int lda, const double * A) {
	// M - number of rows of A and columns of a
	// N - number of columns of A and rows of a
	// lda - leading dimension of A, useful for copying submatrices.  If we are copying the full matrix, M = lda, otherwise M < lda
	double * a = (double *) malloc (M*N*sizeof(double));
	int i, j;
	for (i=0; i<N; i++) {
		for (j=0; j<M; j++) {
			a[i + j*N] = A[j + i*lda];
		}
	}
	return a;
}

double * rand_array(int N) {
	double * A = (double *) malloc (N*sizeof(double));
	//unsigned int iseed = (unsigned int) time (NULL);
	//srand(iseed);
	int i;
	for (i=0; i<N; i++) {
		A[i] = rand()/1.0e9;
	}
	return A;
}

// void inverse(double * A, int N) {
//     int *IPIV = (int*) malloc ((N+1)*sizeof(int));
//     int LWORK = N*N;
//     double *WORK = (double*) malloc (LWORK*sizeof(double));
//     int INFO;

//     dgetrf_(&N,&N,A,&N,IPIV,&INFO);
//     dgetri_(&N,A,&N,IPIV,WORK,&LWORK,&INFO);

//     free(IPIV);
//     free(WORK);
// }