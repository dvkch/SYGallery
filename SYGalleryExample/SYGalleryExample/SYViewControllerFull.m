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
#import "SYAppearance.h"

@interface SYViewControllerFull ()
-(void)imageAction1;
@end

@implementation SYViewControllerFull

@synthesize firstIndex = _firstIndex;

#pragma mark - SYGalleryFullpageActions

- (void)gallery:(id<SYGalleryView>)gallery showedUpPictureAtIndex:(NSUInteger)index {
    [self setTitle:[NSString stringWithFormat:@"%d / %d", index +1, [[SYDataSource sharedDataSource] numberOfItemsInGallery:self->_fullPicView]]];
}

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
    [self.fullPicView setActionDelegate:self];
    [self.fullPicView setAppearanceDelegate:[SYAppearance sharedAppearance]];
    [self.fullPicView addActionWithName:@"Show details" andTarget:self andSelector:@selector(imageAction1) andTag:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"loaded index %d in gallery <%@: 0x%x>", [self firstIndex], [self.fullPicView class], self.fullPicView);
    [self.fullPicView reloadGalleryAndScrollToIndex:[self firstIndex]];
}

-(void)imageAction1 {
    SYGallerySourceType sourceType = [[SYDataSource sharedDataSource] gallery:self.fullPicView
                                                            sourceTypeAtIndex:[self.fullPicView currentIndexCalculated]];
    
    if(sourceType == SYGallerySourceTypeImageLocal)
    {
        NSString *filePath = [[SYDataSource sharedDataSource] gallery:self.fullPicView
                                                  absolutePathAtIndex:[self.fullPicView currentIndexCalculated]
                                                              andSize:SYGalleryPhotoSizeFull];
        
        NSFileManager *dm = [NSFileManager defaultManager];
        NSDictionary *attrs = [dm attributesOfItemAtPath:filePath error:nil];
        unsigned long long size = [attrs fileSize];
        
        NSString *details = [NSString stringWithFormat:@"Filepath: %@\n\nSize: %lldB", filePath, size];
        
        [[[UIAlertView alloc] initWithTitle:@"Details"
                                    message:details
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
    else if(sourceType == SYGallerySourceTypeImageDistant)
    {
        NSString *fileURL = [[SYDataSource sharedDataSource] gallery:self.fullPicView
                                                          urlAtIndex:[self.fullPicView currentIndexCalculated]
                                                              andSize:SYGalleryPhotoSizeFull];
        
        NSString *details = [NSString stringWithFormat:@"FileURL: %@", fileURL];
        
        [[[UIAlertView alloc] initWithTitle:@"Details"
                                    message:details
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
    else if(sourceType == SYGallerySourceTypeText)
    {
        [[[UIAlertView alloc] initWithTitle:@"Details"
                                    message:@"Displaying text"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
    
    NSLog(@"Action done for image %d", [self.fullPicView currentIndexCalculated]);
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
