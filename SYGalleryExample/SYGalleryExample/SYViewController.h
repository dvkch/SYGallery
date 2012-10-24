//
//  SYViewController.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
@class SYGalleryThumbView;
@class SYGalleryFullView;

@interface SYViewController : UIViewController <SYGalleryDataSource, SYGalleryActions> {
@private
    NSMutableArray *_localPathsThumbs;
    NSMutableArray *_localPathsFulls;
    NSMutableArray *_distantPathsThumbs;
    NSMutableArray *_distantPathsFulls;
}

@property (weak, nonatomic) IBOutlet SYGalleryThumbView *thumbsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
