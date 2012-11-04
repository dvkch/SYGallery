//
//  SYGalleryThumbCell.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "GMGridViewCell.h"

@interface SYGalleryThumbCell : GMGridViewCell <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
@private
    UIView *_mainView;
    UIImageView *_thumbImageView;
    UILabel *_label;
    
    UIColor* _cellBorderColor;
    CGFloat _cellBorderWidth;
    
    UIActivityIndicatorView *_activityIndicatorView;
    NSURLConnection *_thumbLoadConnection;
    NSMutableData *_thumbLoadData;
}

-(void)updateCellForAbsolutePath:(NSString*)absolutePath;
-(void)updateCellForUrl:(NSString*)url;
-(void)updateCellForMissingImage;
-(void)updateCellForText:(NSString *)text andFont:(UIFont*)font;
-(void)updateCellBorderWidth:(CGFloat)width andColor:(UIColor*)color;

@property (atomic) BOOL hasBeenLoaded;

@end
