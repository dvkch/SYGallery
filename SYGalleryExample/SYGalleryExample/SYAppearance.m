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
    return 75.f;
}

- (CGFloat)galleryThumbCellSpacing:(id<SYGalleryView>)gallery
{
    return 4.f;
}

-(UIColor *)gallery:(id<SYGalleryView>)gallery textColorAtIndexPath:(NSIndexPath *)indexPath andSize:(SYGalleryItemSize)size
{
    if(size == SYGalleryItemSizeThumb)
        return [UIColor blackColor];
    else
        return [UIColor whiteColor];
}

-(UIFont *)gallery:(id<SYGalleryView>)gallery textFontAtIndexPath:(NSIndexPath *)indexPath andSize:(SYGalleryItemSize)size
{
    if(size == SYGalleryItemSizeThumb)
        return (indexPath.row == 0 ?
                [UIFont fontWithName:@"AppleColorEmoji" size:50.f] :
                nil); // nil will cause the gallery to choose the right size to make the text fit
    else
        return (indexPath.row == 0 ?
                [UIFont fontWithName:@"AppleColorEmoji" size:50.f] :
                [UIFont systemFontOfSize:10.f]);
}


- (UIColor*)gallery:(id<SYGalleryView>)gallery thumbBorderColorAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)gallery:(id<SYGalleryView>)gallery thumbBorderSizeAtIndexPath:(NSIndexPath *)indexPath
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

- (UIColor*)gallery:(id<SYGalleryView>)gallery thumbBackgroundColorAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIColor colorWithWhite:0.5f alpha:.6f];
}

@end
