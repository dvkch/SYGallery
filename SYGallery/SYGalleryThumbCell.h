//
//  SYGalleryThumbCell.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "GMGridViewCell.h"

@class MKNumberBadgeView;

@interface SYGalleryThumbCell : GMGridViewCell <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
@private
    UIView *_mainView;
    UIImageView *_thumbImageView;
    UILabel *_label;
    MKNumberBadgeView *_badgeView;
    
    UIColor* _cellBorderColor;
    CGFloat _cellBorderWidth;
    
    NSUInteger _badgeValue;
    BOOL _badgeHidden;
    
    UIActivityIndicatorView *_activityIndicatorView;
    NSURLConnection *_thumbLoadConnection;
    NSMutableData *_thumbLoadData;
}

-(void)updateCellForAbsolutePath:(NSString*)absolutePath;
-(void)updateCellForUrl:(NSString*)url;
-(void)updateCellForMissingImage;
-(void)updateCellForText:(NSString *)text andFont:(UIFont*)font;

-(void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color;
-(void)setBadgeValue:(NSUInteger)value;
-(void)setBadgeHidden:(BOOL)badgeHidden;

@property (atomic) BOOL hasBeenLoaded;

@end
