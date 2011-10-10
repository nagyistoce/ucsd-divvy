//
//  DivvyDatasetPanel.m
//  Divvy
//
//  Created by Joshua Lewis on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyAppDelegate.h"
#import "DivvyDatasetsPanel.h"
#import "DivvyDataset.h"

@implementation DivvyDatasetsPanel

@synthesize datasetsTable;
@synthesize datasetsArrayController;

- (IBAction) editDatasets:(id)sender {
  NSInteger selectedSegment = [sender selectedSegment];
  NSInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];
  
  if (clickedSegmentTag == 0) // Add button
    [[NSApp delegate] openDatasets:sender];
  else // Remove button
    [[NSApp delegate] closeDatasets:sender];
}

- (void) dealloc {
  [self.datasetsTable release];
  [self.datasetsArrayController release];
  
  [super dealloc];
}

@end
