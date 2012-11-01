//
//  SYViewControllerThumbs.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//


// SPECIAL THX FOR Konstantin Leonov
// http://www.flickr.com/people/73003003@N07/
// FOR LOCAL PICTURES IN THIS EXAMPLE


#import "SYViewControllerThumbs.h"
#import "SYViewControllerFull.h"

#import "SYGalleryThumbView.h"
#import "SYGalleryFullView.h"

#import "SYDataSource.h"

@implementation SYViewControllerThumbs

#pragma mark - Initialization

#pragma mark - View lifecycle

AUTOROTATE_ALL_ORIENTATIONS

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.thumbsView setDataSource:[SYDataSource sharedDataSource]];
    [self.thumbsView setActionDelegate:self];
    [self.thumbsView setCacheImages:YES];
    [self.thumbsView reloadGallery];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueToFullSizeItem"]) {
        SYViewControllerFull *destination = segue.destinationViewController;
        [destination setFirstIndex:[self.thumbsView lastClickedItemIndex]];
    }
}

- (void)viewDidUnload {
    [self setSegmentedControl:nil];
    [self setThumbsView:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions

- (IBAction)editButtonClick:(id)sender {
    [self.thumbsView setEdit:!self.thumbsView.edit];
}

- (IBAction)segmentedControlClick:(id)sender {
    [[SYDataSource sharedDataSource] setUseLocalPathsNotDistantUrl:(self.segmentedControl.selectedSegmentIndex == 0)];
    [self.thumbsView reloadGallery];
}

#pragma mark - SYGalleryActions

- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndex:(NSUInteger)index
{
    [self performSegueWithIdentifier:@"segueToFullSizeItem" sender:self];
    
    /*
    [[[UIAlertView alloc] initWithTitle:@"Tapped"
                                message:[NSString stringWithFormat:@"Tapped on item %d", (int)index]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
    */
    
    NSLog(@"Tapped item at index %d", (int)index);
}

- (void)gallery:(id<SYGalleryView>)gallery deletActionForItemAtIndex:(NSUInteger)index
{
    NSLog(@"Delete action for at index %d", (int)index);
}

- (void)gallery:(id<SYGalleryView>)gallery changedEditStateTo:(BOOL)edit
{
    NSLog(@"Gallery in edit mode: %@", edit ? @"YES" : @"NO");
}

@end
