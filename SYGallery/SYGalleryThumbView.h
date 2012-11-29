//
//  SYGalleryThumbView.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
#import "GMGridView.h"

@interface SYGalleryThumbView : UIView <SYGalleryView,
GMGridViewActionDelegate,
GMGridViewDataSource,
GMGridViewSortingDelegate>
{
    GMGridView *_gridView;
    NSMutableArray *_cachedCells;
    
    UIColor *_cellBorderColor;
    CGFloat _cellBorderWidth;
}

@property (weak, nonatomic) id<SYGalleryDataSource> dataSource;
@property (weak, nonatomic) id<SYGalleryThumbViewActions> actionDelegate;
@property (nonatomic) BOOL cacheImages;
@property (nonatomic) BOOL edit;

@property (readonly) NSUInteger lastClickedItemIndex;

-(void)reloadGallery;
-(void)setCellBorderWidth:(CGFloat)width andColor:(UIColor*)color;

@end
