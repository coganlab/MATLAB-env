#include <string.h>
#include "mex.h"

/**
* fast_avg.c - from a cell array of covariates, each indexed by time and value, takes the average value
* 	of each over times provided.
* 
* David Pfau, 2011
*
* Input arguments:
* prhs[0] - double array of times, marking the time stamp at the edges of the bins we want to average over
* prhs[1] - cell array of double arrays, each double array has two columns, the first being time stamps in
*	ascending order, the second being the values we wish to average over within times denoted by the first input
*
* Output arguments:
* plhs[0] - double array of averages, time along the first axis, average value for different cells of prhs[1]
*	along the second axis.
* plhs[1] - double array of average derivatives
**/
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	if( nrhs != 2 ) {
		mexErrMsgTxt("Incorrect number of input arguments!");
	}
	if( !mxIsDouble( prhs[0] ) ) {
		mexErrMsgTxt("First input must be double array!");
	}
	if( !mxIsCell( prhs[1] ) ) {
		mexErrMsgTxt("Second input must be cell array!");
	}

	mwSize x, y;
	x = mxGetNumberOfElements( prhs[0] ) - 1;
	y = mxGetNumberOfElements( prhs[1] );
	plhs[0] = mxCreateDoubleMatrix( x, y, mxREAL );
	plhs[1] = mxCreateDoubleMatrix( x, y, mxREAL );

	double *edges = mxGetPr( prhs[0] );
	double *output = mxGetPr( plhs[0] );
	double *deriv  = mxGetPr( plhs[1] );
	mxArray *cvr = mxGetCell( prhs[1], (mwIndex) 1 );

	mwIndex i, j;
	mwSize q, n;
	int nbin, dbin; 

	for( j = 0; j < y; j++ ) {
		mxArray *cvr = mxGetCell( prhs[1], j );
		n = mxGetM( cvr );
		double *timesAndVals = mxGetPr( cvr );
		i = -1;
		for( q = 0; q < n; q++ ) {
			if( i == -1 && timesAndVals[q] >= edges[0] ) {
				while( i+1 < x && timesAndVals[q] >= edges[i+1] ) { 
					i++;
				}
				if( i+1 == x ) {
					mexErrMsgTxt("Covariate times begin after last edge!");
				}
				nbin = 0;
				dbin = 0;
			}
			if ( i >= 0 && i < x ) {
				if( timesAndVals[q] >= edges[i+1] ) {
					output[i + x*j] /= nbin;
                    if( dbin != 0 ) {
                        deriv[i + x*j] /= dbin;
                    }
					i++;
					nbin = 0;
					dbin = 0;
				}
				output[i + x*j] += timesAndVals[q + n];
				nbin++;
				if( q > 0 ) {
					deriv[i + x*j] += ( timesAndVals[q + n] - timesAndVals[q - 1 + n] )/( timesAndVals[q] - timesAndVals[q - 1] );
					dbin++;
				}
			}
		}
		if( nbin != 0 ) {
			output[i + x*j] /= nbin;
		}
		if( dbin != 0 ) {
			deriv[i + x*j] /= dbin;
		}
	}
}