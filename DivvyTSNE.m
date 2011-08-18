//
//  DivvyTSNE.m
//  Divvy
//
//  Created by Laurens van der Maaten on 8/18/11.
//  Copyright 2011 Delft University of Technology. All rights reserved.
//

#import "DivvyTSNE.h"
#import "DivvyDataset.h"

#include "tsne.h"


@implementation DivvyTSNE

@dynamic reducerID;
@dynamic name;

- (void) awakeFromInsert {
	[super awakeFromInsert];
	
	self.name = @"t-SNE";
	self.reducerID = [[NSProcessInfo processInfo] globallyUniqueString];
}

- (void) reduceDataset:(DivvyDataset *)dataset
           reducedData:(NSData *)reducedData {
	
	
	//float perplexity = 10.0;			// should come from the GUI
	
	// Run t-SNE code
	int no_dims = 2;
	float *newReducedData = (float*) [reducedData bytes];
	perform_tnse([dataset floatData], 
				[[dataset d] unsignedIntValue], 
				[[dataset n] unsignedIntValue], 
				newReducedData, no_dims, perplexity);
	
	// Print out reduced data
	/*for(int i = 0; i < [[dataset n] unsignedIntValue]; i++) {
		for(int j = 0; j < no_dims; j++) {
			printf("%f,", newReducedData[j * [[dataset n] unsignedIntValue] + i]);
		}
		printf("\n");
	 }*/
}

@end
