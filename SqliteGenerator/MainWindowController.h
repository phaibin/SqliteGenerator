//
//  MainWindowController.h
//  SqliteGenerator
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController

@property (nonatomic, retain) NSMutableArray *tablesArray;

- (IBAction)dumpClicked:(id)sender;
- (IBAction)generateClicked:(id)sender;

@end
