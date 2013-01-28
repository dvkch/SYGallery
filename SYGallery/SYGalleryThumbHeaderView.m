//
//  SYGalleryThumbHeaderView.m
//  SYGalleryExample
//
//  Created by rominet on 28/01/13.
//  Copyright (c) 2013 Syan. All rights reserved.
//

#import "SYGalleryThumbHeaderView.h"
#import "SYGalleryDelegates.h"

@interface SYGalleryThumbHeaderView (Private)
-(void)loadView;
@end

@implementation SYGalleryThumbHeaderView

@synthesize title       = _title;
@synthesize textColor   = _textColor;
@synthesize textFont    = _textFont;
@synthesize labelFrame  = _labelFrame;


-(id)init
{ if(self = [super init]) { [self loadView]; }; return self; }

-(id)initWithCoder:(NSCoder *)aDecoder
{ if(self = [super initWithCoder:aDecoder]) { [self loadView]; }; return self; }

-(id)initWithFrame:(CGRect)frame
{ if(self = [super initWithFrame:frame]) { [self loadView]; }; return self; }


-(void)loadView
{
    [self setReuseIdentifier:SYGALLERY_THUMB_HEADER_REUSE_IDENTIFIER];
    
    if(!self->_label)
    {
        self->_label = [[UILabel alloc] init];
        [self->_label setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self->_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self->_label];
    }
    
    [self->_label setFrame:[self bounds]];
}

-(void)setTitle:(NSString *)title andTextColor:(UIColor*)textColor andTextFont:(UIFont*)textFont
{
    [self setTitle:title];
    [self setTextColor:textColor];
    [self setTextFont:textFont];
}

-(void)setTitle:(NSString *)title
{
    [self->_label setText:title];
}

-(NSString *)title
{
    return [self->_label text];
}

-(void)setTextColor:(UIColor *)textColor
{
    [self->_label setTextColor:textColor];
}

-(UIColor *)textColor
{
    return [self->_label textColor];
}

-(void)setTextFont:(UIFont *)textFont
{
    [self->_label setFont:textFont];
}

-(UIFont *)textFont
{
    return [self->_label font];
}

-(void)setLabelFrame:(CGRect)labelFrame
{
    [self->_label setFrame:labelFrame];
}

-(CGRect)labelFrame
{
    return [self->_label frame];
}

@end
