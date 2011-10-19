//
//  DivvyPluginManager.m
//  Divvy
//
//  Created by Joshua Lewis on 7/26/11.
//  Copyright 2011 UCSD. All rights reserved.
//
//  This class uses code based on the CDPlugin project on the Cocoa
//  is my girlfriend blog

#import "DivvyPluginManager.h"

#import "DivvyClusterer.h"
#import "DivvyReducer.h"
#import "DivvyDatasetVisualizer.h"
#import "DivvyPointVisualizer.h"

@implementation DivvyPluginManager

@synthesize pluginClasses;
@synthesize pluginModels;
@synthesize pluginModelsWithExistingStore;

+ (id)shared;
{
  static DivvyPluginManager *sharedInstance;
  if (!sharedInstance) {
    sharedInstance = [[DivvyPluginManager alloc] init]; // I think it's OK to just let this get destroyed at application termination--no need to balance with a release
  }
  return sharedInstance;
}

- (id)init
{
  if (!(self = [super init])) return nil;
  
  //Find the plugins
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *plugins = [fileManager contentsOfDirectoryAtPath:[self applicationSupportFolder] error:nil];
  
  //Load all of the plugins
  NSMutableArray *loadArray = [NSMutableArray array];
  for (NSString *pluginPath in plugins) {
    if (![pluginPath hasSuffix:@".plugin"]) continue;

    NSBundle *pluginBundle = [NSBundle bundleWithPath:pluginPath];
    Class principalClass = [pluginBundle principalClass];
    
    if (![principalClass conformsToProtocol:@protocol(DivvyClusterer)] &&
        ![principalClass conformsToProtocol:@protocol(DivvyReducer)] &&
        ![principalClass conformsToProtocol:@protocol(DivvyDatasetVisualizer)] &&
        ![principalClass conformsToProtocol:@protocol(DivvyPointVisualizer)]) continue;

    [loadArray addObject:principalClass];
  }
  
  self.pluginClasses = loadArray;
  
  return self;
}

- (void) dealloc {
  [pluginClasses release];
  [pluginModels release];
  
  [super dealloc];
}

- (NSArray*)pluginModels;
{
  if (pluginModels) return pluginModels;
  
  [self initModels];
  
  return self.pluginModels;
}

- (NSArray*)pluginModelsWithExistingStore;
{
  if (pluginModelsWithExistingStore) return pluginModelsWithExistingStore;
  
  [self initModels];
  
  return self.pluginModelsWithExistingStore;
}

- (void) initModels {
  // FileManager for checking whether a store already exists
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  NSMutableArray *models = [NSMutableArray array];
  NSMutableArray *modelsWithExistingStore = [NSMutableArray array];
  
  for (Class aClass in [self pluginClasses]) {
    NSBundle *myBundle = [NSBundle bundleForClass:aClass];
    NSArray *bundles = [NSArray arrayWithObject:myBundle];
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];
    [models addObject:managedObjectModel];
    
    NSString *path = [[self applicationSupportFolder] stringByAppendingFormat:@"/%@.storedata", NSStringFromClass(aClass)];
    if ([fileManager fileExistsAtPath:path])
      [modelsWithExistingStore addObject:managedObjectModel];
    
    [managedObjectModel release];
  }
  
  self.pluginModels = models;
  self.pluginModelsWithExistingStore = modelsWithExistingStore;
  
}

- (NSString*)applicationSupportFolder 
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] :NSTemporaryDirectory();
  return [basePath stringByAppendingPathComponent:@"Divvy"];
}

@end
