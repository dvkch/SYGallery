//
//  SYViewControllerFull.h
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYGalleryFullView;

@interface SYViewControllerFull : UIViewController

@property (weak, nonatomic) IBOutlet SYGalleryFullView *fullPicView;
@property (nonatomic) NSUInteger firstIndex;

@end
