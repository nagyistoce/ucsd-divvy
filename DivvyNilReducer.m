//
//  DivvyNilReducer.m
//  Divvy
//
//  Created by Joshua Lewis on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyNilReducer.h"

#import "DivvyDataset.h"


@implementation DivvyNilReducer

@dynamic reducerID;
@dynamic name;

@dynamic d;

- (void) awakeFromInsert {
  [super awakeFromInsert];
  
  self.reducerID = [[NSProcessInfo processInfo] globallyUniqueString];
}

- (void) calculateD:(DivvyDataset *)dataset {
  // Add code here (default 2 for now)
}

- (void) reduceDataset:(DivvyDataset *)dataset
           reducedData:(NSData *)reducedData {
  int n = [dataset.n intValue];
  int d = [dataset.d intValue];
  
  float *data = [dataset floatData];
  
  // reducedData is by default the first two dimensions scaled to be between
  // 0 and 1
  float x, y, min, max;
  min = FLT_MAX;
  max = FLT_MIN;
  for(int i = 0; i < n; i++) {
    x = data[i * d];
    y = data[i * d + 1];
    
    if(x < min) min = x;
    if(x > max) max = x;
    if(y < min) min = y;
    if(y > max) max = y;
  }

  float *newReducedData = (float *)[reducedData bytes];
  
  for(int i = 0; i < n; i++) {
    newReducedData[i * 2] = (data[i * d] - min) / (max - min);
    newReducedData[i * 2 + 1] = (data[i * d + 1] - min) / (max - min);
  }
}

@end
