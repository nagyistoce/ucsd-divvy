//
//  DivvyClustererPanel.m
//  Divvy
//
//  Created by Joshua Lewis on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyKMeansController.h"
#import "DivvyAppDelegate.h"

@implementation DivvyKMeansController

-(IBAction) changeK:(id)sender {
  DivvyAppDelegate *delegate = [NSApp delegate];
  [delegate clustererChanged];
  [delegate reloadSelectedDatasetViewImage];
}

@end
