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

#define CELL_SIZE 75.f
#define CELL_SPACING 4.f

@interface SYGalleryThumbView : UIView <SYGalleryView,
GMGridViewActionDelegate,
GMGridViewDataSource,
GMGridViewSortingDelegate>
{
    GMGridView *_gridView;
}

@property (weak, nonatomic) id<SYGalleryDataSource> dataSource;
@property (weak, nonatomic) id<SYGalleryActions> actionDelegate;

-(void)reloadGallery;

@end
