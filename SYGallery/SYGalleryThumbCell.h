//
//  SYGalleryThumbCell.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "GMGridViewCell.h"

@class MKNumberBadgeView;

@interface SYGalleryThumbCell : GMGridViewCell {
@private
    UIView *_mainView;
    UIImageView *_thumbImageView;
    UILabel *_textLabel;
    MKNumberBadgeView *_badgeView;
    
    NSUInteger _badgeValue;
    BOOL _badgeHidden;
    
    UIActivityIndicatorView *_activityIndicatorView;
}

-(void)updateCellForImage:(UIImage*)image andShowActivityIndicator:(BOOL)showActivityIndicator;
-(void)updateCellForAbsolutePath:(NSString*)absolutePath andShowActivityIndicator:(BOOL)showActivityIndicator;
-(void)updateCellForUrl:(NSString*)url;
-(void)updateCellForMissingImage;
-(void)updateCellForText:(NSString *)text andTextColor:(UIColor*)textColor andTextFont:(UIFont*)textFont;

-(void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color;
-(void)setBadgeValue:(NSUInteger)value;
-(void)setBadgeHidden:(BOOL)badgeHidden;

-(void)setBackgroundColor:(UIColor *)backgroundColor;
-(UIColor*)backgroundColor;

@property (atomic) CGFloat cellSize;

@end
