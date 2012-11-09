//
//  SYGalleryActionView.m
//  SYGalleryExample
//
//  Created by rominet on 03/11/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SYGalleryActionView.h"

@interface SYGalleryActionView (Private)
-(void)loadView;

-(void)tapped:(id)sender;
-(void)actionTapped:(id)sender;

-(void)updateMainButtonFrame;
-(void)updateButtonContainer;

-(void)openActionList;
-(void)closeActionList;
@end

@implementation SYGalleryActionView

#warning ADD SET METHODS
@synthesize openingDirection = _openingDirection;
@synthesize position = _position;
@synthesize innerMargin = _innerMargin;
@synthesize actionButtonFonts = _actionButtonFonts;
@synthesize mainBackgroundColor = _mainBackgroundColor;
@synthesize opened;


#pragma mark - Initialization

-(id)init
{ if (self = [super init]) { [self loadView]; } return self; }

-(id)initWithCoder:(NSCoder *)aDecoder
{ if (self = [super initWithCoder:aDecoder]) { [self loadView]; } return self; }

- (id)initWithFrame:(CGRect)Frame
{ if (self = [super initWithFrame:Frame]) { [self loadView]; } return self; }


#pragma mark - Private methods

-(void)loadView {

    /*********************************************/
    /*************  PROPERTIES INIT  *************/
    /*********************************************/
    self->_buttons = [NSMutableArray array];
    self->_openingDirection = SYVerticalDirectionDownward;
    self->_actionButtonFonts = [UIFont systemFontOfSize:18.f];
    self->_mainBackgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    
    
    /*********************************************/
    /*************  MAIN BUTTON INIT  ************/
    /*********************************************/
    if(!self->_mainButton)
        self->_mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self->_mainButton setBackgroundColor:self->_mainBackgroundColor];
    
    [self->_mainButton setTitle:@"+" forState:UIControlStateNormal];
    [self->_mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self->_mainButton.titleLabel setFont:self->_actionButtonFonts];
    [self->_mainButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self->_mainButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self->_mainButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self->_mainButton setFrame:CGRectMake(0.f, 0.f, 0.f, 0.f)];
    [self->_mainButton setAutoresizingMask:UIViewAutoresizingNone];
    
    [self->_mainButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self->_mainButton.layer setBorderWidth:BORDER_WIDTH];
    [self->_mainButton.layer setCornerRadius:BORDER_RADIUS];
    
    if([self->_mainButton superview] == nil)
        [self addSubview:self->_mainButton];
    
    
    /*********************************************/
    /***********  BUTTON CONTAINER INIT  *********/
    /*********************************************/
    if(!self->_buttonsContainer)
        self->_buttonsContainer = [[UIView alloc] init];
    
    [self->_buttonsContainer setBackgroundColor:self->_mainBackgroundColor];
    [self->_buttonsContainer setHidden:YES];
    
    [self->_buttonsContainer.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self->_buttonsContainer.layer setBorderWidth:BORDER_WIDTH];
    [self->_buttonsContainer.layer setCornerRadius:BORDER_RADIUS];
    
    if([self->_buttonsContainer superview] == nil)
        [self addSubview:self->_buttonsContainer];
    
    
    /*********************************************/
    /****************  SELF INIT  ****************/
    /*********************************************/
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:
     UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self setHidden:[self->_buttons count] == 0];
    
    [self updateMainButtonFrame];
    self->_isActionListOpened = NO;
}

-(void)tapped:(id)sender {
    if(self->_isActionListOpened)
        [self closeActionList];
    else
        [self openActionList];
}

-(void)actionTapped:(id)sender {
    __block SYGalleryActionView *safeSelf = self;
    
    int64_t delayInMilliSeconds = 100.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliSeconds * (int64_t)NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [safeSelf closeActionList];
    });
}

-(void)updateMainButtonFrame {
    
    CGFloat fX = 0.f;
    CGFloat fY = 0.f;
    CGFloat fWH = 0.f;

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self->_mainButton.titleLabel setFont:[UIFont systemFontOfSize:24.f]];
        fWH = 31.25f;
    }
    else {
        [self->_mainButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        fWH = 25.f;
    }

    switch (self->_position) {
        case SYPositionTopLeft:
            fY = self->_innerMargin.top;
            fX = self->_innerMargin.left;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleBottomMargin];
            break;
        case SYPositionTopMiddle:
            fY = self->_innerMargin.top;
            fX = self->_innerMargin.left + (self.frame.size.width - self->_innerMargin.left - self->_innerMargin.right - fWH) /2.f;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleBottomMargin];
            break;
        case SYPositionTopRight:
            fY = self->_innerMargin.top;
            fX = self.frame.size.width - self->_innerMargin.right - fWH;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin |
             UIViewAutoresizingFlexibleBottomMargin];
            break;
        case SYPositionCenterLeft:
            fY = self->_innerMargin.top + (self.frame.size.height - self->_innerMargin.top - self->_innerMargin.bottom - fWH) /2.f;
            fX = self->_innerMargin.left;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ];
            break;
        case SYPositionCenterMiddle:
            fY = self->_innerMargin.top + (self.frame.size.height - self->_innerMargin.top - self->_innerMargin.bottom - fWH) /2.f;
            fX = self->_innerMargin.left + (self.frame.size.width - self->_innerMargin.left - self->_innerMargin.right - fWH) /2.f;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ];
            break;
        case SYPositionCenterRight:
            fY = self->_innerMargin.top + (self.frame.size.height - self->_innerMargin.top - self->_innerMargin.bottom - fWH) /2.f;
            fX = self.frame.size.width - self->_innerMargin.right - fWH;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin |
             UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ];
            break;
        case SYPositionBottomLeft:
            fY = self.frame.size.height - self->_innerMargin.bottom - fWH;
            fX = self->_innerMargin.left;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleTopMargin ];
            break;
        case SYPositionBottomMiddle:
            fY = self.frame.size.height - self->_innerMargin.bottom - fWH;
            fX = self->_innerMargin.left + (self.frame.size.width - self->_innerMargin.left - self->_innerMargin.right - fWH) /2.f;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleTopMargin ];
            break;
        case SYPositionBottomRight:
            fY = self.frame.size.height - self->_innerMargin.bottom - fWH;
            fX = self.frame.size.width - self->_innerMargin.right - fWH;
            [self->_mainButton setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin |
             UIViewAutoresizingFlexibleTopMargin ];
            break;
            
        default:
            break;
    }
    
    [self->_mainButton setFrame:CGRectMake(fX, fY, fWH, fWH)];
    [self->_mainButton setNeedsDisplay];
    [self->_mainButton setNeedsLayout];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

-(void)updateButtonContainer {
    
    CGFloat maxWidth = 0.f;
    CGFloat maxHeight = 0.f;
    for (UIButton *button in self->_buttons)
    {
        [button.titleLabel setFont:self->_actionButtonFonts];
        CGSize textSize = [[button titleForState:UIControlStateNormal] sizeWithFont:button.titleLabel.font];
        maxWidth = MAX(textSize.width, maxWidth);
        maxHeight = MAX(textSize.height, maxHeight);
    }

    maxHeight = 1.1f * maxHeight; // spacing
    
    NSUInteger nbButtons = [self->_buttons count];
    
    CGFloat totalWidth = maxWidth + 2.f * MARGIN_ACTIONBUTTON_IN;
    CGFloat totalHeight = maxHeight * nbButtons;
    CGFloat originX = self->_mainButton.frame.origin.x;
    CGFloat originY = self.openingDirection == SYVerticalDirectionDownward ?
        self->_mainButton.frame.origin.y + self->_mainButton.frame.size.height + MARGIN_MAINBUTTON_BUTTONCONTAINER :
        self->_mainButton.frame.origin.y - totalHeight - MARGIN_MAINBUTTON_BUTTONCONTAINER;

    [self->_buttonsContainer setFrame:CGRectMake(originX, originY, totalWidth, totalHeight)];
    
    for (UIView* subv in [self->_buttonsContainer subviews])
        [subv removeFromSuperview];
    
    uint i = 0;
    for (UIButton* button in self->_buttons)
    {
        [button setFrame:CGRectMake(0.f, (CGFloat)i * maxHeight,
                                    maxWidth + 2.f * MARGIN_ACTIONBUTTON_IN, maxHeight)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.f, MARGIN_ACTIONBUTTON_IN,
                                                    0.f, MARGIN_ACTIONBUTTON_IN)];
        [self->_buttonsContainer addSubview:button];
        ++i;
    }
    
}

-(void)openActionList {
    
    [self updateButtonContainer];

    [self->_buttonsContainer setAlpha:0.f];
    [self->_buttonsContainer setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self->_buttonsContainer setAlpha:1.f];
    } completion:^(BOOL finished) {
        self->_isActionListOpened = YES;
    }];
}

-(void)closeActionList {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self->_buttonsContainer setAlpha:0.f];
    } completion:^(BOOL finished) {
        [self->_buttonsContainer setHidden:YES];
        self->_isActionListOpened = NO;
    }];
}

-(UIImage*)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - View methods

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self->_mainButton pointInside:[self convertPoint:point toView:self->_mainButton] withEvent:event]
    | [self->_buttonsContainer pointInside:[self convertPoint:point toView:self->_buttonsContainer] withEvent:event];
}

-(void)setOpeningDirection:(SYVerticalDirection)openingDirection {
    self->_openingDirection = openingDirection;
    
    [self updateButtonContainer];
}

-(void)setPosition:(SYPosition)position
{
    self->_position = position;
    
    [self updateMainButtonFrame];
    [self updateButtonContainer];
}

-(void)setFont:(UIFont *)font {
    self->_actionButtonFonts = font;
    
    [self updateMainButtonFrame];
    [self updateButtonContainer];
}

-(void)setMainBackgroundColor:(UIColor *)mainBackgroundColor {
    self->_mainBackgroundColor = mainBackgroundColor;
    
    [self->_buttonsContainer setBackgroundColor:self->_mainBackgroundColor];
    [self->_mainButton setBackgroundColor:self->_mainBackgroundColor];
}

-(void)setInnerMargin:(UIEdgeInsets)innerMargin {
    self->_innerMargin = innerMargin;
    
    [self updateMainButtonFrame];
    [self updateButtonContainer];
}

-(void)setOpened:(BOOL)_opened {
    if(_opened)
        [self openActionList];
    else
        [self closeActionList];
}

-(BOOL)opened {
    return self->_isActionListOpened;
}

-(void)addActionWithName:(NSString *)name
               andTarget:(id)target
             andSelector:(SEL)selector
                  andTag:(NSInteger)tag
{
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setTitle:name forState:UIControlStateNormal];
    [actionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [actionButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [actionButton.layer setMasksToBounds:YES];
    [actionButton.layer setCornerRadius:BORDER_RADIUS];
    
    [actionButton setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:.5f green:.73f blue:.93f alpha:.9f]]
                            forState:UIControlStateHighlighted];
    
    [actionButton addTarget:target
                     action:selector
           forControlEvents:UIControlEventTouchUpInside];
    
    [actionButton addTarget:self
                     action:@selector(actionTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [actionButton setTag:tag];
    
    [self->_buttons addObject:actionButton];
    
    [self setHidden:[self->_buttons count] == 0];
}

-(void)removeActionWithTag:(NSInteger)tag
{
    for(UIButton *button in self->_buttons)
        if(button.tag == tag)
        {
            [self->_buttons removeObject:button];
            break;
        }
    
    [self setHidden:[self->_buttons count] == 0];
}

@end
