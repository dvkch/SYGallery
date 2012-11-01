//
//  SYGalleryFullView.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"

#define PAGE_MARGIN 20.f

@interface SYGalleryFullView : UIScrollView <SYGalleryView, UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    NSMutableArray *_galleryPages;
}

@property (weak, nonatomic) id<SYGalleryDataSource> dataSource;
@property (weak, nonatomic) id<SYGalleryActions> actionDelegate;

-(void)setDataSource:(id<SYGalleryDataSource>)dataSource andFirstItemToShow:(NSUInteger)firstItem;
-(void)reloadGalleryAndScrollToIndex:(NSUInteger)index;
-(void)scrollToPage:(uint)pageIndex animated:(BOOL)animated;

@end
