//
//  SYGalleryThumbView.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
#import "PSTCollectionView.h"

@interface SYGalleryThumbView : UIView <SYGalleryView,
PSTCollectionViewDataSource,
PSTCollectionViewDelegate,
PSTCollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    PSUICollectionView *_gridView;
    PSUICollectionViewFlowLayout *_flowLayout;
}

@property (weak, nonatomic) id<SYGalleryDataSource> dataSource;
@property (weak, nonatomic) id<SYGalleryThumbViewActions> actionDelegate;
@property (weak, nonatomic) id<SYGalleryAppearence> appearanceDelegate;

@property (nonatomic) BOOL multiSelect;
@property (readonly) NSIndexPath *lastClickedItemIndexPath;
@property (readonly) NSArray *selectedIndexPaths;

-(void)reloadGallery;
-(void)deselectAllAnimated:(BOOL)animated;

@end
