//
//  SYGalleryFullPage.m
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DACircularProgressView.h"

#import "SYGalleryFullPage.h"

@interface SYGalleryFullPage (Private)
-(void)loadView;

-(void)singleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer;
-(void)doubleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer;

-(CGFloat)calculateZoomScaleFit;
-(CGFloat)calculateZoomScaleFill;
-(CGFloat)calculateZoomScaleActualSizeWithAdditionnalFactor:(CGFloat)factor;
@end

@implementation SYGalleryFullPage

@synthesize pageNumber = _pageNumber;

#pragma mark - Initialization

-(id)initWithFrame:(CGRect)frame andPageNumber:(uint)pageNumber
{ if(self = [super initWithFrame:frame]) { [self loadView]; self->_pageNumber = pageNumber; } return self; }

-(id)initWithFrame:(CGRect)frame
{ return self = [self initWithFrame:frame andPageNumber:0]; }

#pragma mark - Private methods

-(void)loadView {
    
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    
    if (!self->_fullImageView)
        self->_fullImageView = [[UIImageView alloc] init];
    [self->_fullImageView setFrame:subViewFrame];
    [self->_fullImageView setBackgroundColor:[UIColor clearColor]];
    [self->_fullImageView setClipsToBounds:YES];
    [self->_fullImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self->_fullImageView setUserInteractionEnabled:YES];
    [self->_fullImageView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if([self->_fullImageView superview] == nil)
        [self addSubview:self->_fullImageView];
    
    if(!self->_circularProgressView)
        self->_circularProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(1000.f, 1000.f, 100.0f, 100.0f)];
    [self->_circularProgressView setHidden:YES];
    [self->_circularProgressView setRoundedCorners:NO];
    [self->_circularProgressView setTrackTintColor:[UIColor redColor]];
    [self->_circularProgressView setProgressTintColor:[UIColor greenColor]];
    
    if([self->_circularProgressView superview] == nil)
        [self addSubview:self->_circularProgressView];
    
    if (!self->_singleTapGestureRecognizer)
        self->_singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(singleTapOnImageView:)];
    self->_singleTapGestureRecognizer.numberOfTapsRequired = 1;
    if(self->_fullImageView)
        [self->_fullImageView addGestureRecognizer:self->_singleTapGestureRecognizer];
    
    if (!self->_doubleTapGestureRecognizer)
        self->_doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(doubleTapOnImageView:)];
    self->_doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    if(self->_fullImageView)
        [self->_fullImageView addGestureRecognizer:self->_doubleTapGestureRecognizer];
    

    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self setUserInteractionEnabled:YES];
    [self setContentMode:UIViewContentModeCenter];
    [self setScrollEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    [self setClipsToBounds:YES];
    [self setBounces:YES];
    [self setBouncesZoom:YES];

    [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    [self setDelegate:self];

    [self resetZoomFactors];
}

- (void)resetZoomFactors
{
    if(!self->_fullImageView ||
       !self->_fullImageView.image ||
       !self->_fullImageView.image.size.height ||
       !self->_fullImageView.image.size.width)
        return;
    
    // MANDATORY !!
    // before setting the frame we need to have a 1:1 scale between image view and scrollview
    [self setZoomScale:1.0f];
    self->_fullImageView.frame = CGRectMake(0.f, 0.f, self->_fullImageView.image.size.width, self->_fullImageView.image.size.height);
    
    [self setMaximumZoomScale:[self calculateZoomScaleActualSizeWithAdditionnalFactor:1.f]];
    [self setMinimumZoomScale:[self calculateZoomScaleFit]];
    [self setZoomScale:[self calculateZoomScaleFit]];
}

-(CGFloat)calculateZoomScaleFit {
    if(!self->_fullImageView ||
       !self->_fullImageView.image ||
       !self->_fullImageView.image.size.height ||
       !self->_fullImageView.image.size.width)
        return 1.f;
    
    CGFloat frameRatio = self.frame.size.height / self.frame.size.width;
    CGFloat imageRatio = self->_fullImageView.image.size.height / self->_fullImageView.image.size.width;
    
    if (frameRatio > imageRatio) // image height proportionnaly greater than frame height
        return self.frame.size.width / self->_fullImageView.image.size.width;
    else
        return self.frame.size.height / self->_fullImageView.image.size.height;
}

-(CGFloat)calculateZoomScaleFill {
    if(!self->_fullImageView ||
       !self->_fullImageView.image ||
       !self->_fullImageView.image.size.height ||
       !self->_fullImageView.image.size.width)
        return 1.f;
    
    CGFloat frameRatio = self.frame.size.height / self.frame.size.width;
    CGFloat imageRatio = self->_fullImageView.image.size.height / self->_fullImageView.image.size.width;
    
    if (frameRatio > imageRatio) // image height proportinnaly greater than frame height
        return self.frame.size.height / self->_fullImageView.image.size.height;
    else
        return self.frame.size.width / self->_fullImageView.image.size.width;
}

-(CGFloat)calculateZoomScaleActualSizeWithAdditionnalFactor:(CGFloat)factor {
    return 1.f * (factor == 0.f ? 1.f : factor);
}

#pragma mark - View methods

-(void)updateImageWithAbsolutePath:(NSString*)absolutePath {
    self.hasBeenLoaded = YES;
    [self->_fullImageView setImage:[UIImage imageWithContentsOfFile:absolutePath]];
    [self resetZoomFactors];
}

-(void)updateImageWithUrl:(NSString*)url {
    self.hasBeenLoaded = YES;
    
    // cannot use a block version of NSURLConnection because if we load another picture
    // while the first hasn't been loaded it may result in a bizarre behavior
    
    if(self->_picConnection)
        [self->_picConnection cancel];
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:5.f];
    self->_picConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    self->_picData = [NSMutableData data];
    [self->_picConnection start];
    [self->_circularProgressView setProgress:1.f];
    [self->_circularProgressView setHidden:NO];
    [self->_circularProgressView setNeedsDisplay];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetZoomFactors];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self->_fullImageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self->_fullImageView.frame = frameToCenter;
}

-(BOOL)isZoomed {
    return [self zoomScale] != [self minimumZoomScale];
}

#pragma mark - UIGestureRecognizer


-(void)singleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer {
    ;
}

-(void)doubleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer {
    
    if([self isZoomed])
        [self setZoomScale:self.minimumZoomScale animated:YES];
    else
    {
        // define a rect to zoom to.
        CGPoint touchCenter = [gestureRecognizer locationInView:self->_fullImageView];
        CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale,
                                         self.frame.size.height / self.maximumZoomScale);
        CGPoint zoomPoint = touchCenter;// CGPointMake(touchCenter.x * self.zoomScale, touchCenter.y * self.zoomScale);
        
        CGFloat x = zoomPoint.x - zoomRectSize.width * .5f;
        CGFloat y = zoomPoint.y - zoomRectSize.height * .5f;
        CGRect zoomArea = CGRectMake(x < 0.f ? 0.f : x,
                                     y < 0.f ? 0.f : y,
                                     zoomRectSize.width,
                                     zoomRectSize.height);
        
        [self zoomToRect:zoomArea animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self->_fullImageView;
}

#pragma mark - NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self->_picData setLength:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self->_picData appendData:data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    __block SYGalleryFullPage *safeSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [safeSelf->_circularProgressView setHidden:YES];
        [safeSelf->_fullImageView setImage:[UIImage imageWithData:self->_picData]];
        [safeSelf resetZoomFactors];
        [safeSelf setNeedsDisplay];
        
        safeSelf->_picData = nil;
        safeSelf->_picConnection = nil;
    });
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)connection:(SYGalleryFullPage *)connection didFailWithError:(NSError *)error {
    __block SYGalleryFullPage *safeSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [safeSelf->_circularProgressView setHidden:YES];
        
        safeSelf->_picData = nil;
        safeSelf->_picConnection = nil;
        safeSelf.hasBeenLoaded = NO;
    });
}


@end
