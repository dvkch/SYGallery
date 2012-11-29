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

#define DEFAULT_CELL_SIZE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 120.f : 75.f)
#define DEFAULT_CELL_SPACING ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 6.99f : 4.f)

@protocol SYGalleryView
@end

#define UIViewAutoresizingFlexibleMargins                 \
UIViewAutoresizingFlexibleBottomMargin    | \
UIViewAutoresizingFlexibleLeftMargin      | \
UIViewAutoresizingFlexibleRightMargin     | \
UIViewAutoresizingFlexibleTopMargin

typedef enum {
    SYGallerySourceTypeImageLocal,
    SYGallerySourceTypeImageDistant,
    SYGallerySourceTypeText
} SYGallerySourceType;

typedef enum {
    SYGalleryPhotoSizeThumb,
    SYGalleryPhotoSizeFull
} SYGalleryPhotoSize;

@protocol SYGalleryDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInGallery:(id<SYGalleryView>)gallery;
- (SYGallerySourceType)gallery:(id<SYGalleryView>)gallery sourceTypeAtIndex:(NSUInteger)index;

- (NSString*)gallery:(id<SYGalleryView>)gallery absolutePathAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;
- (NSString*)gallery:(id<SYGalleryView>)gallery urlAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;
- (NSString*)gallery:(id<SYGalleryView>)gallery textAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;
@optional
- (BOOL)gallery:(id<SYGalleryView>)gallery canDeleteAtIndex:(NSUInteger)index;
- (void)gallery:(id<SYGalleryView>)gallery deleteItemInAtIndex:(NSUInteger)index;

- (CGFloat)galleryThumbCellSize:(id<SYGalleryView>)gallery;
- (CGFloat)galleryThumbCellSpacing:(id<SYGalleryView>)gallery;

- (BOOL)gallery:(id<SYGalleryView>)gallery shouldDisplayBadgeAtIndex:(NSUInteger)index;
- (NSUInteger)gallery:(id<SYGalleryView>)gallery badgeValueAtIndex:(NSUInteger)index;
- (UIColor*)gallery:(id<SYGalleryView>)gallery textColorAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;
- (UIFont*)gallery:(id<SYGalleryView>)gallery textFontAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;
@end

@protocol SYGalleryThumbViewActions <NSObject>
@optional
- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndex:(NSUInteger)index;
- (void)gallery:(id<SYGalleryView>)gallery deletActionForItemAtIndex:(NSUInteger)index;
- (void)gallery:(id<SYGalleryView>)gallery changedEditStateTo:(BOOL)edit;
@end

@protocol SYGalleryFullViewActions <NSObject>
@optional
- (void)gallery:(id<SYGalleryView>)gallery showedUpPictureAtIndex:(NSUInteger)index;
@end
