//
//  SYViewControllerFull.m
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYViewControllerFull.h"
#import "SYGalleryFullView.h"
#import "SYDataSource.h"

@interface SYViewControllerFull ()

@end

@implementation SYViewControllerFull

@synthesize firstIndex = _firstIndex;

AUTOROTATE_ALL_ORIENTATIONS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) { ; }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.fullPicView setDataSource:[SYDataSource sharedDataSource] andFirstItemToShow:[self firstIndex]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFullPicView:nil];
    [super viewDidUnload];
}
@end
