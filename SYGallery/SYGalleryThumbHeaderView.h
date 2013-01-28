//
//  SYGalleryThumbHeaderView.h
//  SYGalleryExample
//
//  Created by rominet on 28/01/13.
//  Copyright (c) 2013 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"

@interface SYGalleryThumbHeaderView : PSUICollectionReusableView {
@private
    UILabel *_label;
}

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIFont    *textFont;
@property (nonatomic)         CGRect     labelFrame;

-(void)setTitle:(NSString *)title andTextColor:(UIColor*)textColor andTextFont:(UIFont*)textFont;
@end
