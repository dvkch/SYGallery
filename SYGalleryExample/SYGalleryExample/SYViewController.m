//
//  SYViewController.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYViewController.h"
#import "SYGalleryThumbView.h"
#import "SYGalleryFullView.h"

@implementation SYViewController

#pragma mark - Initialization
/*
-(id)init
{ if (self = [super init]) { [self loadView]; } return self; }

-(id)initWithCoder:(NSCoder *)aDecoder
{ if (self = [super initWithCoder:aDecoder]) { [self loadView]; } return self; }

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) { [self loadView]; } return self; }
*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self->_localPathsThumbs = [NSMutableArray arrayWithObjects:
                               @"a", @"a", @"a", @"a", nil];
    self->_localPathsFulls = [NSMutableArray arrayWithObjects:
                              @"a", @"a", @"a", @"a", nil];
    
    self->_distantPathsThumbs = [NSMutableArray arrayWithObjects:
                                 @"a", @"a", @"a", @"a", @"a", @"a",
                                 @"a", @"a", @"a", @"a", @"a", @"a",
                                 @"a", @"a", @"a", @"a", @"a", @"a",
                                 @"a", @"a", @"a", @"a", @"a", @"a",
                                 @"a", @"a", @"a", @"a", @"a", @"a",
                                 @"a", @"a", @"a", @"a", @"a", @"a",
                                 nil];
    self->_distantPathsFulls = [NSMutableArray arrayWithObjects:
                                @"a", @"a", @"a", @"a", @"a", @"a",
                                @"a", @"a", @"a", @"a", @"a", @"a",
                                @"a", @"a", @"a", @"a", @"a", @"a",
                                @"a", @"a", @"a", @"a", @"a", @"a",
                                @"a", @"a", @"a", @"a", @"a", @"a",
                                @"a", @"a", @"a", @"a", @"a", @"a",
                                nil];

    [self.thumbsView setBackgroundColor:[UIColor redColor]];
    [self.thumbsView setDataSource:self];
    [self.thumbsView setActionDelegate:self];
    [self.thumbsView reloadGallery];
    
    //    self->_fullView = [[SYGalleryFullView alloc] init];
    //    [self->_fullView setDataSource:self];
    //    [self->_fullView setActionDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)segmentedControlClick:(id)sender {
    [self.thumbsView reloadGallery];
}


#pragma mark - SYGalleryDataSource

- (NSUInteger)numberOfItemsInGallery:(id<SYGalleryView>)gallery
{
    uint numberOfItems = 0;
    if(self.segmentedControl.selectedSegmentIndex == 0)
        numberOfItems = [self->_localPathsFulls count];
    else
        numberOfItems = [self->_distantPathsFulls count];

    NSLog(@"%d items in gallery, %d locals, %d distants",
          numberOfItems,
          [self->_localPathsFulls count],
          [self->_distantPathsFulls count]);

    return numberOfItems;
}

- (SYGallerySourceType)gallery:(id<SYGalleryView>)gallery sourceTypeAtIndex:(NSUInteger)index
{
    if(self.segmentedControl.selectedSegmentIndex == 0)
        return SYGallerySourceTypeLocal;
    else
        return SYGallerySourceTypeDistant;
}

- (NSString*)gallery:(id<SYGalleryView>)gallery absolutePathAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return [self->_localPathsThumbs objectAtIndex:index];
    else
        return [self->_localPathsFulls objectAtIndex:index];
}

- (NSString*)gallery:(id<SYGalleryView>)gallery urlAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return [self->_distantPathsThumbs objectAtIndex:index];
    else
        return [self->_distantPathsFulls objectAtIndex:index];
}

- (BOOL)gallery:(id<SYGalleryView>)gallery canDeleteAtIndex:(NSUInteger)index
{
    // even indexes only
    return index % 2 == 0;
}


#pragma mark - SYGalleryActions

- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndex:(NSUInteger)index
{
    [[[UIAlertView alloc] initWithTitle:@"Tapped"
                                message:[NSString stringWithFormat:@"Tapped on item %d", (int)index]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
    
    NSLog(@"Tapped item at index %d", (int)index);
}

- (void)gallery:(id<SYGalleryView>)gallery processDeleteActionForItemAtIndex:(NSUInteger)index
{
    NSLog(@"Deleting item at index %d", (int)index);
    
    if([self gallery:self.thumbsView sourceTypeAtIndex:index] == SYGallerySourceTypeDistant) {
        [self->_distantPathsFulls removeObjectAtIndex:index];
        [self->_distantPathsThumbs removeObjectAtIndex:index];
    }
    else {
        [self->_localPathsFulls removeObjectAtIndex:index];
        [self->_localPathsThumbs removeObjectAtIndex:index];
    }
}

- (void)gallery:(id<SYGalleryView>)gallery changedEditStateTo:(BOOL)edit
{
    NSLog(@"Gallery in edit mode: %@", edit ? @"YES" : @"NO");
}

- (void)viewDidUnload {
    [self setSegmentedControl:nil];
    [self setThumbsView:nil];
    [super viewDidUnload];
}

@end
