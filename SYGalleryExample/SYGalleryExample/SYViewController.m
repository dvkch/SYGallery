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
                                 @"http://farm8.staticflickr.com/7035/6772235451_6ebca876b9_s.jpg",
                                 @"http://farm8.staticflickr.com/7003/6772237041_23d0e89284_s.jpg",
                                 @"http://farm8.staticflickr.com/7170/6772238039_e75820a2de_s.jpg",
                                 @"http://farm8.staticflickr.com/7003/6772239185_5862f29b50_s.jpg",
                                 @"http://farm8.staticflickr.com/7147/6772240411_4bcd40e9ca_s.jpg",
                                 @"http://farm8.staticflickr.com/7033/6772241725_1ef1296a06_s.jpg",
                                 @"http://farm8.staticflickr.com/7151/6772243099_8648e2f452_s.jpg",
                                 @"http://farm8.staticflickr.com/7022/6772244303_e1c9c05058_s.jpg",
                                 @"http://farm8.staticflickr.com/7174/6772245689_1c5ae1822d_s.jpg",
                                 
                                 @"http://farm8.staticflickr.com/7026/6772247177_eccaec2996_s.jpg",
                                 @"http://farm8.staticflickr.com/7029/6772248589_d04668283d_s.jpg",
                                 @"http://farm8.staticflickr.com/7175/6772249739_4de39786c7_s.jpg",
                                 @"http://farm8.staticflickr.com/7147/6772251009_777317e594_s.jpg",
                                 @"http://farm8.staticflickr.com/7034/6772252053_3efcc8f1a8_s.jpg",
                                 @"http://farm8.staticflickr.com/7144/6772253275_86c835a077_s.jpg",
                                 @"http://farm8.staticflickr.com/7164/6807594349_412b21e344_s.jpg",
                                 @"http://farm8.staticflickr.com/7034/6772256117_bd257a76fe_s.jpg",
                                 @"http://farm8.staticflickr.com/7023/6772257455_5a9656102f_s.jpg",
                                 
                                 @"http://farm8.staticflickr.com/7156/6772258387_e1aa8b5670_s.jpg",
                                 @"http://farm8.staticflickr.com/7028/6772259495_f84e1b8570_s.jpg",
                                 
                                 @"http://farm7.staticflickr.com/6233/6324518502_1c3136ff40_s.jpg",
                                 @"http://farm7.staticflickr.com/6059/6323762655_4007ce8520_s.jpg",
                                 @"http://farm7.staticflickr.com/6236/6324517764_de1df32ebe_s.jpg",
                                 @"http://farm7.staticflickr.com/6192/6132622831_cd6cc1caca_s.jpg",
                                 @"http://farm7.staticflickr.com/6173/6132675139_dd4d8f6cf5_s.jpg",
                                 @"http://farm7.staticflickr.com/6073/6133223046_9b534aa334_s.jpg",
                                 @"http://farm7.staticflickr.com/6074/6132821783_febf9e9904_s.jpg",
                                 @"http://farm7.staticflickr.com/6079/6133378862_e482333e7f_s.jpg",
                                 @"http://farm7.staticflickr.com/6215/6363743545_2fa45c5f7c_s.jpg",
                                 
                                 @"http://farm7.staticflickr.com/6109/6363745095_f379391121_s.jpg",
                                 @"http://farm7.staticflickr.com/6117/6363746609_6b912b1f3f_s.jpg",
                                 @"http://farm7.staticflickr.com/6098/6363747947_0745476dc9_s.jpg",
                                 @"http://farm8.staticflickr.com/7163/6407056643_2155c2e141_s.jpg",
                                 @"http://farm8.staticflickr.com/7165/6407059881_1dc7940411_s.jpg",
                                 @"http://farm8.staticflickr.com/7142/6408034643_2f2913b8fb_s.jpg",
                                 @"http://farm8.staticflickr.com/7035/6408036239_bc80730a6f_s.jpg",
                                 @"http://farm8.staticflickr.com/7160/6408037557_cf05fdb2e6_s.jpg",
                                 @"http://farm8.staticflickr.com/7025/6408039143_ab93bbbcd4_s.jpg",
                                 
                                 @"http://farm8.staticflickr.com/7013/6408040221_5ef3291562_s.jpg",
                                 @"http://farm8.staticflickr.com/7020/6408041639_763c09cd16_s.jpg",
                                 @"http://farm8.staticflickr.com/7028/6408043061_e7493dcf30_s.jpg",
                                 @"http://farm8.staticflickr.com/7168/6408044361_fc0fbd5ecd_s.jpg",
                                 @"http://farm7.staticflickr.com/6226/6408045667_1f447b1367_s.jpg",
                                 nil];
    
    self->_distantPathsFulls = [NSMutableArray arrayWithObjects:
                                @"http://farm8.staticflickr.com/7035/6772235451_6ebca876b9.jpg",
                                @"http://farm8.staticflickr.com/7003/6772237041_23d0e89284.jpg",
                                @"http://farm8.staticflickr.com/7170/6772238039_e75820a2de.jpg",
                                @"http://farm8.staticflickr.com/7003/6772239185_5862f29b50.jpg",
                                @"http://farm8.staticflickr.com/7147/6772240411_4bcd40e9ca.jpg",
                                @"http://farm8.staticflickr.com/7033/6772241725_1ef1296a06.jpg",
                                @"http://farm8.staticflickr.com/7151/6772243099_8648e2f452.jpg",
                                @"http://farm8.staticflickr.com/7022/6772244303_e1c9c05058.jpg",
                                @"http://farm8.staticflickr.com/7174/6772245689_1c5ae1822d.jpg",
                                
                                @"http://farm8.staticflickr.com/7026/6772247177_eccaec2996.jpg",
                                @"http://farm8.staticflickr.com/7029/6772248589_d04668283d.jpg",
                                @"http://farm8.staticflickr.com/7175/6772249739_4de39786c7.jpg",
                                @"http://farm8.staticflickr.com/7147/6772251009_777317e594.jpg",
                                @"http://farm8.staticflickr.com/7034/6772252053_3efcc8f1a8.jpg",
                                @"http://farm8.staticflickr.com/7144/6772253275_86c835a077.jpg",
                                @"http://farm8.staticflickr.com/7164/6807594349_412b21e344.jpg",
                                @"http://farm8.staticflickr.com/7034/6772256117_bd257a76fe.jpg",
                                @"http://farm8.staticflickr.com/7023/6772257455_5a9656102f.jpg",
                                
                                @"http://farm8.staticflickr.com/7156/6772258387_e1aa8b5670.jpg",
                                @"http://farm8.staticflickr.com/7028/6772259495_f84e1b8570.jpg",
                                
                                @"http://farm7.staticflickr.com/6233/6324518502_1c3136ff40.jpg",
                                @"http://farm7.staticflickr.com/6059/6323762655_4007ce8520.jpg",
                                @"http://farm7.staticflickr.com/6236/6324517764_de1df32ebe.jpg",
                                @"http://farm7.staticflickr.com/6192/6132622831_cd6cc1caca.jpg",
                                @"http://farm7.staticflickr.com/6173/6132675139_dd4d8f6cf5.jpg",
                                @"http://farm7.staticflickr.com/6073/6133223046_9b534aa334.jpg",
                                @"http://farm7.staticflickr.com/6074/6132821783_febf9e9904.jpg",
                                @"http://farm7.staticflickr.com/6079/6133378862_e482333e7f.jpg",
                                @"http://farm7.staticflickr.com/6215/6363743545_2fa45c5f7c.jpg",
                                
                                @"http://farm7.staticflickr.com/6109/6363745095_f379391121.jpg",
                                @"http://farm7.staticflickr.com/6117/6363746609_6b912b1f3f.jpg",
                                @"http://farm7.staticflickr.com/6098/6363747947_0745476dc9.jpg",
                                @"http://farm8.staticflickr.com/7163/6407056643_2155c2e141.jpg",
                                @"http://farm8.staticflickr.com/7165/6407059881_1dc7940411.jpg",
                                @"http://farm8.staticflickr.com/7142/6408034643_2f2913b8fb.jpg",
                                @"http://farm8.staticflickr.com/7035/6408036239_bc80730a6f.jpg",
                                @"http://farm8.staticflickr.com/7160/6408037557_cf05fdb2e6.jpg",
                                @"http://farm8.staticflickr.com/7025/6408039143_ab93bbbcd4.jpg",
                                
                                @"http://farm8.staticflickr.com/7013/6408040221_5ef3291562.jpg",
                                @"http://farm8.staticflickr.com/7020/6408041639_763c09cd16.jpg",
                                @"http://farm8.staticflickr.com/7028/6408043061_e7493dcf30.jpg",
                                @"http://farm8.staticflickr.com/7168/6408044361_fc0fbd5ecd.jpg",
                                @"http://farm7.staticflickr.com/6226/6408045667_1f447b1367.jpg",
                                nil];

    [self.thumbsView setDataSource:self];
    [self.thumbsView setActionDelegate:self];
    [self.thumbsView setCacheImages:YES];
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

    NSLog(@"INFO: Displaying %d items", numberOfItems);
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
