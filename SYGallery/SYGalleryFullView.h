//
//  SYGalleryFullView.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
@class SYGalleryActionView;

#define PAGE_MARGIN 20.f

@interface SYGalleryFullView : UIScrollView <SYGalleryView, UIScrollViewDelegate> {
@private
    UIScrollView *_scrollView;
    NSMutableArray *_galleryPages;
    SYGalleryActionView *_actionListView;
    dispatch_queue_t _loadImageQueue;
}

@property (weak, nonatomic) id<SYGalleryDataSource> dataSource;
@property (weak, nonatomic) id<SYGalleryFullViewActions> actionDelegate;
@property (weak, nonatomic) id<SYGalleryAppearence> appearanceDelegate;

-(void)setDataSource:(id<SYGalleryDataSource>)dataSource andFirstItemToShow:(NSUInteger)firstItem;
-(void)reloadGalleryAndScrollToIndex:(NSUInteger)index;
-(void)scrollToPage:(uint)pageIndex animated:(BOOL)animated;

-(uint)currentIndexCalculated;

-(void)addActionWithName:(NSString *)name
               andTarget:(id)target
             andSelector:(SEL)selector
                  andTag:(NSInteger)tag;

-(void)removeActionWithTag:(NSInteger)tag;

@end
