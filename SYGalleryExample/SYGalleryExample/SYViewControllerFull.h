//
//  SYViewControllerFull.h
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
@class SYGalleryFullView;

@interface SYViewControllerFull : UIViewController <SYGalleryFullViewActions>

@property (weak, nonatomic) IBOutlet SYGalleryFullView *fullPicView;
@property (nonatomic) NSIndexPath *firstIndexPath;

@end
