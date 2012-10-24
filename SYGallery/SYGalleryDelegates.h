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

@protocol SYGalleryView
@end

typedef enum {
    SYGallerySourceTypeLocal,
    SYGallerySourceTypeDistant
} SYGallerySourceType;

typedef enum {
    SYGalleryPhotoSizeThumb,
    SYGalleryPhotoSizeFull
} SYGalleryPhotoSize;

@protocol SYGalleryDataSource <NSObject>
- (NSUInteger)numberOfItemsInGallery:(id<SYGalleryView>)gallery;
- (SYGallerySourceType)gallery:(id<SYGalleryView>)gallery sourceTypeAtIndex:(NSUInteger)index;

- (NSString*)gallery:(id<SYGalleryView>)gallery absolutePathAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;
- (NSString*)gallery:(id<SYGalleryView>)gallery urlAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size;

- (BOOL)gallery:(id<SYGalleryView>)gallery canDeleteAtIndex:(NSUInteger)index;
@end

@protocol SYGalleryActions <NSObject>
- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndex:(NSUInteger)index;
- (void)gallery:(id<SYGalleryView>)gallery processDeleteActionForItemAtIndex:(NSUInteger)index;
- (void)gallery:(id<SYGalleryView>)gallery changedEditStateTo:(BOOL)edit;
@end
