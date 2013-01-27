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

@synthesize firstIndexPath = _firstIndexPath;

#pragma mark - SYGalleryFullpageActions

- (void)gallery:(id<SYGalleryView>)gallery showedUpPictureAtIndexPath:(NSIndexPath *)indexPath {
    [self setTitle:[NSString stringWithFormat:@"%d / %d",
                    indexPath.row +1,
                    [[SYDataSource sharedDataSource] gallery:gallery
                                      numberOfItemsInSection:(uint)indexPath.section]]];
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
    [self.fullPicView setDataSource:[SYDataSource sharedDataSource]
            andFirstIndexPathToShow:[self firstIndexPath]];
    
    [self.fullPicView setActionDelegate:self];
    [self.fullPicView setAppearanceDelegate:[SYAppearance sharedAppearance]];
    [self.fullPicView addActionWithName:@"Show details" andTarget:self andSelector:@selector(imageAction1) andTag:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"fullpage gallery <%@: 0x%x> appeared with initial indexpath %@",
          [self.fullPicView class],
          &*self.fullPicView,
          [self firstIndexPath]);
    
    [self.fullPicView reloadGalleryAndScrollToIndexPath:[self firstIndexPath]];
}

-(void)imageAction1 {
    NSIndexPath *indexPath = [self.fullPicView currentIndexPathCalculated];
    
    SYGallerySourceType sourceType = [[SYDataSource sharedDataSource] gallery:self.fullPicView
                                                        sourceTypeAtIndexPath:indexPath];
    
    if(sourceType == SYGallerySourceTypeImageLocal)
    {
        NSString *filePath = [[SYDataSource sharedDataSource] gallery:self.fullPicView
                                              absolutePathAtIndexPath:indexPath
                                                              andSize:SYGalleryItemSizeFull];
        
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
                                                      urlAtIndexPath:indexPath
                                                             andSize:SYGalleryItemSizeFull];
        
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
