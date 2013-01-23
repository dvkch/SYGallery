//
//  SYViewControllerThumbs.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
@class SYGalleryThumbView;
@class SYGalleryFullView;

@interface SYViewControllerThumbs : UIViewController <SYGalleryThumbViewActions>

@property (weak, nonatomic) IBOutlet SYGalleryThumbView *thumbsView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonLocalPics;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDistantPics;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonEdit;

@end
