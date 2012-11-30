//
//  SYGalleryAppearance.h
//  SYGalleryExample
//
//  Created by rominet on 11/30/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"

@interface SYGalleryAppearance : NSObject <SYGalleryAppearence>

+(SYGalleryAppearance*)sharedAppearance;

@end
