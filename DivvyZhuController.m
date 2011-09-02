//
//  DivvyZhuController.m
//  Divvy
//
//  Created by Joshua Lewis on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyZhuController.h"

#import "DivvyAppDelegate.h"


@implementation DivvyZhuController

- (IBAction) changeLineWidth:(id)sender {
  DivvyAppDelegate *delegate = [NSApp delegate];
  [delegate pointVisualizerChanged];
  [delegate reloadSelectedDatasetViewImage];}

@end
