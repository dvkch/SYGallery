//
//  SYGalleryFullPage.h
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"
@class DACircularProgressView;

@interface SYGalleryFullPage : UIView
<SYGalleryView, NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    UITapGestureRecognizer *_singleTapGestureRecognizer;
    UITapGestureRecognizer *_doubleTapGestureRecognizer;
    DACircularProgressView *_circularProgressView;

    NSURLConnection *_picConnection;
    long long _picDataExpectedLenght;
    NSMutableData *_picData;
	NSTimer *_tapTimer;
}

@property (atomic) uint pageNumber;
@property (atomic) BOOL hasBeenLoaded;
@property (readonly) BOOL isZoomed;
@property (atomic) id<SYGalleryFullViewActions> actionDelegate;

-(id)initWithFrame:(CGRect)frame andPageNumber:(uint)pageNumber;

-(void)updateImageWithAbsolutePath:(NSString*)absolutePath;
-(void)updateImageWithUrl:(NSString*)url;
-(void)resetZoomFactors;

@end