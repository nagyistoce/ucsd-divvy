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

- (void) loadWindow {
  [super loadWindow];
}

- (IBAction) editDatasets:(id)sender {
  NSInteger selectedSegment = [sender selectedSegment];
  NSInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];
  
  if (clickedSegmentTag == 0) // Add button
    [[NSApp delegate] openDatasets:sender];
  else // Remove button
    [[NSApp delegate] closeDatasets:sender];
}

- (void) windowDidLoad {
  [super windowDidLoad];
  
  // Load the datasets from the managed object context early so that we can set the saved selection in applicationDidFinishLaunching
  NSError *error = nil;
  [self.datasetsArrayController fetchWithRequest:nil merge:NO error:&error];
}

- (void) dealloc {
  [self.datasetsTable release];
  [self.datasetsArrayController release];
  
  [super dealloc];
}

@end
