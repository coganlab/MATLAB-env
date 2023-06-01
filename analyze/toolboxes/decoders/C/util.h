#ifndef __UTIL_H__
#define __UTIL_H__

void print_matrix(int M, int N, double * A);
void dlmwrite(char * fname, double * A, int M, int N);
double * allocate_and_zero(int N);
double * allocate_and_copy(int N, const double * d);
double * allocate_and_transpose(int M, int N, int lda, const double * d);
double * rand_array(int N);
#define max(x,y) (x>y)?x:y;
#define Calloc(size,type) (type *) calloc(size, sizeof(type));
#define Malloc(size,type) (type *) malloc(size*sizeof(type));

#endif