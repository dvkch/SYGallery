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
#import "SYAppearance.h"


@implementation SYViewControllerThumbs

#pragma mark - Initialization

#pragma mark - View lifecycle

AUTOROTATE_ALL_ORIENTATIONS

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.thumbsView setDataSource:[SYDataSource sharedDataSource]];
    [self.thumbsView setActionDelegate:self];
    [self.thumbsView setAppearanceDelegate:[SYAppearance sharedAppearance]];
    [self.thumbsView reloadGallery];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.thumbsView deselectAllAnimated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"segueToFullSizeItem"]) {
        SYViewControllerFull *destination = segue.destinationViewController;
        [destination setFirstIndexPath:[self.thumbsView lastClickedItemIndexPath]];
    }
}

- (void)viewDidUnload {
    [self setThumbsView:nil];
    [self setButtonMultiSelect:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions

- (IBAction)buttonMultiSelectClick:(id)sender {
    [self.thumbsView setMultiSelect:!self.thumbsView.multiSelect];
    if(self.thumbsView.multiSelect)
        [self.buttonMultiSelect setTitle:@"Multiselect ON"];
    else
        [self.buttonMultiSelect setTitle:@"Multiselect OFF"];
}

#pragma mark - SYGalleryActions

- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped item at path %@", indexPath);
    
    if(!self.thumbsView.multiSelect)
        [self performSegueWithIdentifier:@"segueToFullSizeItem" sender:self];
}

@end
