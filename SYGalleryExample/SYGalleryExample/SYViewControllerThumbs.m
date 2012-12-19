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
#import "SYGalleryAppearance.h"


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
    [self.thumbsView setAppearanceDelegate:[SYGalleryAppearance sharedAppearance]];
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
    [self setThumbsView:nil];
    [self setButtonLocalPics:nil];
    [self setButtonDistantPics:nil];
    [self setButtonText:nil];
    [self setButtonData:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions

- (IBAction)editButtonClick:(id)sender {
    [self.thumbsView setEdit:!self.thumbsView.edit];
}

- (IBAction)buttonLocalPicsClick:(id)sender {
    [[SYDataSource sharedDataSource] setSourceType:SYGallerySourceTypeImageLocal];
    [self.buttonLocalPics setTintColor:[UIColor blackColor]];
    [self.buttonDistantPics setTintColor:nil];
    [self.buttonText setTintColor:nil];
    [self.buttonData setTintColor:nil];
    [self.thumbsView reloadGallery];
}

- (IBAction)buttonDistPicsClick:(id)sender {
    [[SYDataSource sharedDataSource] setSourceType:SYGallerySourceTypeImageDistant];
    [self.buttonLocalPics setTintColor:nil];
    [self.buttonDistantPics setTintColor:[UIColor blackColor]];
    [self.buttonText setTintColor:nil];
    [self.buttonData setTintColor:nil];
    [self.thumbsView reloadGallery];
}

- (IBAction)buttonDataClick:(id)sender {
    [[SYDataSource sharedDataSource] setSourceType:SYGallerySourceTypeImageData];
    [self.buttonLocalPics setTintColor:nil];
    [self.buttonDistantPics setTintColor:nil];
    [self.buttonText setTintColor:nil];
    [self.buttonData setTintColor:[UIColor blackColor]];
    [self.thumbsView reloadGallery];
}

- (IBAction)buttonTextClick:(id)sender {
    [[SYDataSource sharedDataSource] setSourceType:SYGallerySourceTypeText];
    [self.buttonLocalPics setTintColor:nil];
    [self.buttonDistantPics setTintColor:nil];
    [self.buttonText setTintColor:[UIColor blackColor]];
    [self.buttonData setTintColor:nil];
    [self.thumbsView reloadGallery];
}

#pragma mark - SYGalleryActions

- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndex:(NSUInteger)index
{
    [self performSegueWithIdentifier:@"segueToFullSizeItem" sender:self];
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
