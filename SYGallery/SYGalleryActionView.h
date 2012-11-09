//
//  SYGalleryActionView.h
//  SYGalleryExample
//
//  Created by rominet on 03/11/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN_MAINBUTTON_BUTTONCONTAINER 10.f
#define MARGIN_ACTIONBUTTON_IN 4.f
#define BORDER_RADIUS 5.f
#define BORDER_WIDTH 1.f

typedef enum {
    SYVerticalDirectionUpward,
    SYVerticalDirectionDownward
} SYVerticalDirection;

typedef enum {
    SYPositionTopLeft,
    SYPositionTopMiddle,
    SYPositionTopRight,
    SYPositionCenterLeft,
    SYPositionCenterMiddle,
    SYPositionCenterRight,
    SYPositionBottomLeft,
    SYPositionBottomMiddle,
    SYPositionBottomRight
} SYPosition;

@interface SYGalleryActionView : UIView {
    UIButton *_mainButton;
    NSMutableArray *_buttons;
    UIView *_buttonsContainer;
    BOOL _isActionListOpened;
}

-(void)addActionWithName:(NSString *)name
               andTarget:(id)target
             andSelector:(SEL)selector
                  andTag:(NSInteger)tag;

-(void)removeActionWithTag:(NSInteger)tag;

@property (nonatomic) SYVerticalDirection openingDirection;
@property (nonatomic) SYPosition position;
@property (nonatomic) UIEdgeInsets innerMargin;

@property (nonatomic) UIFont *actionButtonFonts;
@property (nonatomic) UIColor *mainBackgroundColor;

@property (nonatomic) BOOL opened;

@end
