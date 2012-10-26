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

@interface SYGalleryThumbCell : GMGridViewCell <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
@private
    UIView *_mainView;
    UIImageView *_thumbImageView;
    UILabel *_label;
    UIActivityIndicatorView *_activityIndicatorView;
    NSURLConnection *_thumbLoadConnection;
    NSMutableData *_thumbLoadData;
}

-(void)resetCell;
-(void)updateCellForAbsolutePath:(NSString*)absolutePath;
-(void)updateCellForUrl:(NSString*)url;
-(void)updateCellForMissingImage;
-(void)updateCellForText:(NSString *)text andFont:(UIFont*)font;

@property (atomic) BOOL hasBeenLoaded;

@end
