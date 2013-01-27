//
//  SYGalleryDelegates.h
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYGalleryThumbView;
@class SYGalleryFullView;

#define SYGALLERY_IPAD  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define SYGALLERY_DEFAULT_CELL_SIZE (SYGALLERY_IPAD ? 120.f : 75.f)
#define SYGALLERY_DEFAULT_CELL_SPACING (SYGALLERY_IPAD ? 6.99f : 4.f)

#define SYGALLERY_DEFAULT_CELL_BORDER_SIZE 1.f
#define SYGALLERY_DEFAULT_CELL_BORDER_COLOR [UIColor colorWithWhite:0.f alpha:.4f]
#define SYGALLERY_DEFAULT_CELL_BACKGROUND_COLOR [UIColor colorWithWhite:1.f alpha:.4f]

#define SYGALLERY_INT_BETWEEN_A_AND_B(i, A, B) (i >= MIN(A, B) && i <= MAX(A, B))

#define SYGALLERY_THUMB_REUSE_IDENTIFIER     @"SYGALLERY_THUMB_REUSE_IDENTIFIER"

//#define SYGALLERY_REFRESH_RUNLOOP_MODES @[NSRunLoopCommonModes]
#define SYGALLERY_REFRESH_RUNLOOP_MODES @[(NSString*)kCFRunLoopDefaultMode]

@protocol SYGalleryView
@end

#define UIViewAutoresizingFlexibleMargins   \
UIViewAutoresizingFlexibleBottomMargin    | \
UIViewAutoresizingFlexibleLeftMargin      | \
UIViewAutoresizingFlexibleRightMargin     | \
UIViewAutoresizingFlexibleTopMargin

typedef enum {
    SYGallerySourceTypeImageData,
    SYGallerySourceTypeImageLocal,
    SYGallerySourceTypeImageDistant,
    SYGallerySourceTypeText
} SYGallerySourceType;

typedef enum {
    SYGalleryItemSizeThumb,
    SYGalleryItemSizeFull
} SYGalleryItemSize;

@protocol SYGalleryDataSource <NSObject>
@required
- (NSUInteger)numberOfSectionsInGallery:(id<SYGalleryView>)gallery;
- (NSUInteger)totalNumberOfItemsInGallery:(id<SYGalleryView>)gallery;
- (NSUInteger)gallery:(id<SYGalleryView>)gallery numberOfItemsInSection:(NSUInteger)section;
- (SYGallerySourceType)gallery:(id<SYGalleryView>)gallery sourceTypeAtIndexPath:(NSIndexPath*)indexPath;

- (NSString*)gallery:(id<SYGalleryView>)gallery absolutePathAtIndexPath:(NSIndexPath*)indexPath andSize:(SYGalleryItemSize)size;
- (NSString*)gallery:(id<SYGalleryView>)gallery urlAtIndexPath:(NSIndexPath*)indexPath andSize:(SYGalleryItemSize)size;
- (NSString*)gallery:(id<SYGalleryView>)gallery textAtIndexPath:(NSIndexPath*)indexPath andSize:(SYGalleryItemSize)size;
- (UIImage*)gallery:(id<SYGalleryView>)gallery dataAtIndexPath:(NSIndexPath*)indexPath andSize:(SYGalleryItemSize)size;
@optional
- (NSString*)gallery:(id<SYGalleryView>)gallery titleForSection:(NSUInteger)section;
- (BOOL)gallery:(id<SYGalleryView>)gallery shouldDisplayBadgeAtIndexPath:(NSIndexPath*)indexPath;
- (NSUInteger)gallery:(id<SYGalleryView>)gallery badgeValueAtIndexPath:(NSIndexPath*)indexPath;
@end

@protocol SYGalleryAppearence <NSObject>
@optional
- (CGFloat)galleryThumbCellSize:(id<SYGalleryView>)gallery;
- (CGFloat)galleryThumbCellSpacing:(id<SYGalleryView>)gallery;

- (UIColor*)gallery:(id<SYGalleryView>)gallery textColorAtIndexPath:(NSIndexPath*)indexPath andSize:(SYGalleryItemSize)size;
- (UIFont*)gallery:(id<SYGalleryView>)gallery textFontAtIndexPath:(NSIndexPath*)indexPath andSize:(SYGalleryItemSize)size;

- (BOOL)gallery:(id<SYGalleryView>)gallery showActivityIndicatorForThumbnailAtIndexPath:(NSIndexPath*)indexPath;

- (UIColor*)gallery:(id<SYGalleryView>)gallery thumbBorderColorAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)gallery:(id<SYGalleryView>)gallery thumbBorderSizeAtIndexPath:(NSIndexPath*)indexPath;
- (UIColor*)gallery:(id<SYGalleryView>)gallery thumbBackgroundColorAtIndexPath:(NSIndexPath*)indexPath;
@end

@protocol SYGalleryThumbViewActions <NSObject>
@optional
- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)gallery:(id<SYGalleryView>)gallery changedEditStateTo:(BOOL)edit;
@end

@protocol SYGalleryFullViewActions <NSObject>
@optional
- (void)gallery:(id<SYGalleryView>)gallery showedUpPictureAtIndexPath:(NSIndexPath*)indexPath;
@end
