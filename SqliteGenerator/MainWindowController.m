//
//  MainWindowController.m
//  SqliteGenerator
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"

@implementation MainWindowController

@synthesize tablesArray = _tablesArray;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _tablesArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self.tablesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"asdfasdf", @"tablename", nil]];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)dumpClicked:(id)sender {
    
}

- (IBAction)generateClicked:(id)sender {
    
}

- (void)dealloc
{
    [_tablesArray release];
    [super dealloc];
}

@end
