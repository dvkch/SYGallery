//
//  SYGalleryThumbCell.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYGalleryThumbCell.h"
#import "GMGridViewCell.h"

@implementation SYGalleryThumbCell : GMGridViewCell

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) { ; }
    return self;
}

#pragma mark - View methods
-(void)updateCellForAbsolutePath:(NSString*)absolutePath {
    
}

-(void)updateCellForUrl:(NSString*)url {
    
}

-(void)updateCellForEmptyImage:(NSString*)customText {
    UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
    
    CGFloat fontSize = self.frame.size.width * 0.4f;
    if(fontSize < 10.f)
        fontSize = 10.f;
    
    label.font = [UIFont fontWithName:@"EuphemiaUCAS" size:fontSize];
    label.text = customText && ![customText isEqualToString:@""] ? customText : @"X";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.contentView = label;
}

/*
@property (nonatomic, strong) UIView *contentView;         // The contentView - default is nil
@property (nonatomic, strong) UIImage *deleteButtonIcon;   // Delete button image
@property (nonatomic) CGPoint deleteButtonOffset;          // Delete button offset relative to the origin
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
*/

@end
