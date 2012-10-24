//
//  SYGalleryThumbCell.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "GMGridViewCell.h"

#define UIViewAutoresizingFlexibleMargins                 \
UIViewAutoresizingFlexibleBottomMargin    | \
UIViewAutoresizingFlexibleLeftMargin      | \
UIViewAutoresizingFlexibleRightMargin     | \
UIViewAutoresizingFlexibleTopMargin

@interface SYGalleryThumbCell : GMGridViewCell
-(void)updateCellForAbsolutePath:(NSString*)absolutePath;
-(void)updateCellForUrl:(NSString*)url;
-(void)updateCellForEmptyImage:(NSString*)customText;
@end
