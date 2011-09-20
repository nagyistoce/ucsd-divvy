//
//  DivvyTSNEController.m
//  Divvy
//
//  Created by Laurens van der Maaten on 8/18/11.
//  Copyright 2011 Delft University of Technology. All rights reserved.
//

#import "DivvyIsomapController.h"
#import "DivvyAppDelegate.h"

@implementation DivvyIsomapController

-(IBAction) changeK:(id)sender {
    DivvyAppDelegate *delegate = [NSApp delegate];
    [delegate reducerChanged];
    [delegate reloadSelectedDatasetViewImage];
}

@end
