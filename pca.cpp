/*
 *  pca.cpp
 *  Divvy
 *
 *  Created by Laurens van der Maaten on 8/16/11.
 *  Copyright 2011 Delft University of Technology. All rights reserved.
 *
 */

#include "pca.h"
#include <Accelerate/Accelerate.h>


void reduce_data(float* X, int D, int N, float* Y, int no_dims) {
	
	// Compute data mean
	float* mean = (float*) calloc(D, sizeof(float));
	for(int n = 0; n < N; n++) {
		for(int d = 0; d < D; d++) {
			mean[d] += X[n * D + d];
		}
	}
	for(int d = 0; d < D; d++) {
		mean[d] /= (float) N;
	}
	
	// Subtract data mean
	for(int n = 0; n < N; n++) {
		for(int d = 0; d < D; d++) {
			X[n * D + d] -= mean[d];
		}
	}
	
	// Compute covariance matrix (with BLAS)
	float* C = (float*) calloc(D * D, sizeof(float));
	cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasTrans, D, D, N, 1.0, X, D, X, D, 1.0, C, D);
	
	// Compute covariance matrix (without BLAS)
	/*float* C = (float*) calloc(D * D, sizeof(float));
	for(int n = 0; n < N; n++) {
		for(int d1 = 0; d1 < D; d1++) {
			for(int d2 = 0; d2 < D; d2++) {
				C[d1 * D + d2] += X[n * D + d1] * X[n * D + d2];
			}
		}
	}*/
	
	// Perform eigendecomposition of covariance matrix
	int n = N, lda = N, lwork = -1, info;
	float wkopt;
	float* lambda = (float*) malloc(D * sizeof(float));
	ssyev_((char*) "N", (char*) "U", &n, C, &lda, lambda, &wkopt, &lwork, &info);			// gets optimal size of working memory
	lwork = (int) wkopt;
	float* work = (float*) malloc(lwork * sizeof(float));
	ssyev_((char*) "N", (char*) "U", &n, C, &lda, lambda, work, &lwork, &info);				// eigenvectors for real, symmetric matrix
	
	// Project data onto first eigenvectors (using BLAS)
	cblas_sgemm(CblasRowMajor, CblasTrans, CblasNoTrans, no_dims, N, D, 1.0, C, D, X, D, 1.0, Y, no_dims);
	
	// Project data onto first eigenvectors (without BLAS)
	/*for(int n = 0; n < N; n++) {
		for(int d1 = 0; d1 < no_dims; d1++) {
			Y[n * no_dims + d1] = 0.0;
			for(int d2 = 0; d2 < D; d2++) {
				Y[n * no_dims + d1] += X[n * no_dims + d2] * C[d1 * D + d2];
			}
		}
	}*/
	
	// Clean up memory
	free(mean);
	free(C);
	free(lambda);
	free(work);
}