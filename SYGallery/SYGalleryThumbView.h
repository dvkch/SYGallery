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

#define CELL_SIZE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 120.f : 75.f)
#define CELL_SPACING ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 6.99f : 4.f)

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
@property (weak, nonatomic) id<SYGalleryActions> actionDelegate;
@property (nonatomic) BOOL cacheImages;
@property (nonatomic) BOOL edit;

@property (readonly) NSUInteger lastClickedItemIndex;

-(void)reloadGallery;
-(void)setCellBorderWidth:(CGFloat)width andColor:(UIColor*)color;

@end
