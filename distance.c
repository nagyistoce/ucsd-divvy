/*
 *  distance.c
 *  Divvy
 *
 *  Created by Joshua Lewis on 8/22/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "distance.h"

// Calculate distances with matrix/matrix operations (BLAS3)
void distance(int N, int D, float *data, float *result) {
	int i, j, m, o;
	int blockSize = 50;
  int threadNum = omp_get_max_threads(); // Number of threads OpenMP will spawn
  
	float *diag = (float *)malloc(sizeof(float) * N);
  float *C = (float *)malloc(threadNum * blockSize * blockSize * sizeof(float));
  
#pragma omp parallel private(i, j, o)
	{ 
    int th_id = omp_get_thread_num();
    
#pragma omp for schedule(guided)
		for(m = 0; m < N / blockSize; m++)
		{
			cblas_sgemm(CblasColMajor, CblasTrans, CblasNoTrans, blockSize, blockSize, D,
                  1, &data[m * blockSize * D], D,
                  &data[m * blockSize * D], D, 0,
                  &C[th_id * blockSize * blockSize], blockSize);
			
			for(i = 0; i < blockSize; i++)
				diag[m * blockSize + i] = C[th_id * blockSize * blockSize + i * (blockSize + 1)];
      
			for(i = 0; i < blockSize; i++)
				for(j = i + 1; j < blockSize; j++)
					result[utndidx(i + m * blockSize, j + m * blockSize)] = \
          sqrt(diag[i + m * blockSize] + diag[j + m * blockSize] - \
               2 * C[th_id * blockSize * blockSize + j * blockSize + i]);
    }
		
#pragma omp for schedule(guided)
		for(m = 0; m < N / blockSize; m++)
			for(o = m + 1; o < N / blockSize; o++)
			{
				cblas_sgemm(CblasColMajor, CblasTrans, CblasNoTrans, blockSize, blockSize, D,
                    1, &data[m * blockSize * D], D,
                    &data[o * blockSize * D], D, 0,
                    &C[th_id * blockSize * blockSize], blockSize);
				
				for(j = 0; j < blockSize; j++)
					for(i = 0; i < blockSize; i++)
						result[utndidx(j + m * blockSize, i + o * blockSize)] = \
            sqrt(diag[i + o * blockSize] + diag[j + m * blockSize] - \
                 2 * C[th_id * blockSize * blockSize + i * blockSize + j]);
			}
  }
  
  free(C);
	free(diag);
  
	return;
}