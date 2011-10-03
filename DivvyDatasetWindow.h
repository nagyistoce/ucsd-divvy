//
//  DivvyDatasetWindow.h
//  Divvy
//
//  Created by Joshua Lewis on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface DivvyDatasetWindow : NSWindowController

@property (retain) IBOutlet IKImageBrowserView *datasetViewsBrowser;
@property (retain) IBOutlet NSArrayController *datasetViewsArrayController;

- (IBAction)editDatasetViews:sender;

@end
