//
//  DivvyDatasetViewPanel.h
//  Divvy
//
//  Created by Joshua Lewis on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DivvyDatasetViewPanel : NSWindowController

@property (retain) IBOutlet NSView *datasetVisualizerView;
@property (retain) IBOutlet NSView *pointVisualizerView;
@property (retain) IBOutlet NSView *clustererView;
@property (retain) IBOutlet NSView *reducerView;

@property (retain) IBOutlet NSPopUpButton *datasetVisualizerPopUp;
@property (retain) IBOutlet NSPopUpButton *pointVisualizerPopUp;
@property (retain) IBOutlet NSPopUpButton *clustererPopUp;
@property (retain) IBOutlet NSPopUpButton *reducerPopUp;

@property (retain) IBOutlet NSButton *datasetVisualizerDisclosureButton;
@property (retain) IBOutlet NSButton *pointVisualizerDisclosureButton;
@property (retain) IBOutlet NSButton *clustererDisclosureButton;
@property (retain) IBOutlet NSButton *reducerDisclosureButton;

@property (retain) IBOutlet NSArrayController *datasetVisualizerArrayController;
@property (retain) IBOutlet NSArrayController *pointVisualizerArrayController;
@property (retain) IBOutlet NSArrayController *clustererArrayController;
@property (retain) IBOutlet NSArrayController *reducerArrayController;

@property (retain) IBOutlet NSObjectController *datasetVisualizerController;
@property (retain) IBOutlet NSObjectController *pointVisualizerController;
@property (retain) IBOutlet NSObjectController *clustererController;
@property (retain) IBOutlet NSObjectController *reducerController;

@property (retain) IBOutlet NSTextField *selectViewTextField;

@property (retain) NSMutableArray *datasetVisualizerViewControllers;
@property (retain) NSMutableArray *pointVisualizerViewControllers;
@property (retain) NSMutableArray *clustererViewControllers;
@property (retain) NSMutableArray *reducerViewControllers;

- (IBAction) datasetVisualizerSelect:(id)sender;
- (IBAction) pointVisualizerSelect:(id)sender;
- (IBAction) clustererSelect:(id)sender;
- (IBAction) reducerSelect:(id)sender;

- (void) reflow;

@end
