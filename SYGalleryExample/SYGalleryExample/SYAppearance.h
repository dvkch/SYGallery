//
//  SYAppearance.h
//  SYGalleryExample
//
//  Created by rominet on 11/30/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"

@interface SYAppearance : NSObject <SYGalleryAppearence>

+(SYAppearance*)sharedAppearance;

@end
