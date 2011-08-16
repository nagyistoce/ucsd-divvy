//
//  DivvyPCA.m
//  Divvy
//
//  Created by Joshua Lewis on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyPCA.h"
#import "DivvyDataset.h"

#include "pca.h"


@implementation DivvyPCA

@dynamic reducerID;
@dynamic name;

@dynamic firstAxis;
@dynamic secondAxis;
@dynamic rotatedData;

- (void) awakeFromInsert {
  [super awakeFromInsert];
  
  self.name = @"Principal Components Analysis";
  self.reducerID = [[NSProcessInfo processInfo] globallyUniqueString];
}

- (void) reduceDataset:(DivvyDataset *)dataset
           reducedData:(NSData *)reducedData {
	
	// Run PCA code
	float *newReducedData = (float*) [reducedData bytes];
	/*reduce_data([dataset floatData], 
				[[dataset d] unsignedIntValue], 
				[[dataset n] unsignedIntValue], 
				newReducedData, 2);*/
	
	// Should set firstAxis, secondAxis, and rotatedData...?
}

@end
