//
//  SYAppearance.m
//  SYGalleryExample
//
//  Created by rominet on 11/30/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYAppearance.h"
#import "SYDataSource.h"

@implementation SYAppearance

+(SYAppearance *)sharedAppearance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (CGFloat)galleryThumbCellSize:(id<SYGalleryView>)gallery
{
    return 60.f;
}

- (CGFloat)galleryThumbCellSpacing:(id<SYGalleryView>)gallery
{
    return 2.f;
}

-(UIColor *)gallery:(id<SYGalleryView>)gallery textColorAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return [UIColor blackColor];
    else
        return [UIColor whiteColor];
}

-(UIFont *)gallery:(id<SYGalleryView>)gallery textFontAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return nil; // will select proper font size to fit in view
    else
        return (index == 0 ? [UIFont systemFontOfSize:50.f] : [UIFont systemFontOfSize:10.f]);
}


- (UIColor*)gallery:(id<SYGalleryView>)gallery thumbBorderColorAtIndex:(NSUInteger)index
{
    switch ([[SYDataSource sharedDataSource] sourceType]) {
        case SYGallerySourceTypeImageLocal:
            return [UIColor blackColor];
            break;
        case SYGallerySourceTypeImageDistant:
            return [UIColor colorWithWhite:1.f alpha:.4f];
            break;
        case SYGallerySourceTypeImageData:
            return [UIColor clearColor];
            break;
        case SYGallerySourceTypeText:
            return SYGALLERY_DEFAULT_CELL_BORDER_COLOR;
            break;
    }
    return nil;
}

- (CGFloat)gallery:(id<SYGalleryView>)gallery thumbBorderSizeAtIndex:(NSUInteger)index
{
    switch ([[SYDataSource sharedDataSource] sourceType]) {
        case SYGallerySourceTypeImageLocal:
            return 1.f;
            break;
        case SYGallerySourceTypeImageDistant:
            return 4.f;
            break;
        case SYGallerySourceTypeImageData:
            return 1.f;
            break;
        case SYGallerySourceTypeText:
            return SYGALLERY_DEFAULT_CELL_BORDER_SIZE;
            break;
    }
    return 0.f;
}

- (UIColor*)gallery:(id<SYGalleryView>)gallery thumbBackgroundColor:(NSUInteger)index
{
    return [UIColor colorWithWhite:0.5f alpha:.6f];
}

@end
