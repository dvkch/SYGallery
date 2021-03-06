//
//  SYGalleryFullPage.m
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DACircularProgressView.h"
#import "NSURLConnection+Blocks.h"

#import "SYGalleryFullPage.h"

@interface SYGalleryFullPage (Private)
-(void)loadView;

-(void)updateImage_private:(UIImage *)image;

-(void)centerSubView:(UIView*)subview inView:(UIView*)view;

-(void)singleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer;
-(void)doubleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer;

-(CGFloat)calculateZoomScaleFit;
-(CGFloat)calculateZoomScaleFill;
-(CGFloat)calculateZoomScaleActualSizeWithAdditionnalFactor:(CGFloat)factor;
@end

@implementation SYGalleryFullPage

@synthesize pageNumber = _pageNumber;
@synthesize isZoomed = _isZoomed;
@synthesize actionDelegate = _actionDelegate;

#pragma mark - Initialization

-(id)initWithFrame:(CGRect)frame andPageNumber:(uint)pageNumber
{ if(self = [super initWithFrame:frame]) { [self loadView]; self->_pageNumber = pageNumber; } return self; }

-(id)initWithFrame:(CGRect)frame
{ return self = [self initWithFrame:frame andPageNumber:0]; }

#pragma mark - Private methods

-(void)loadView {
    
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    
    /*********************************************/
    /*************  SCROLLVIEW INIT  *************/
    /*********************************************/
    if (!self->_scrollView)
        self->_scrollView = [[UIScrollView alloc] init];
    [self->_scrollView setFrame:subViewFrame];
    [self->_scrollView setBackgroundColor:[UIColor clearColor]];
    [self->_scrollView setClipsToBounds:YES];
    [self->_scrollView setContentMode:UIViewContentModeCenter];
    [self->_scrollView setUserInteractionEnabled:YES];
    [self->_scrollView setAutoresizesSubviews:YES];
    
    [self->_scrollView setScrollEnabled:YES];
    [self->_scrollView setShowsHorizontalScrollIndicator:NO];
    [self->_scrollView setShowsVerticalScrollIndicator:NO];
    [self->_scrollView setBounces:YES];
    [self->_scrollView setBouncesZoom:YES];

    [self->_scrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    [self->_scrollView setDelegate:self];
    [self->_scrollView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleMargins];
    
    if([self->_scrollView superview] == nil)
        [self addSubview:self->_scrollView];
    
    /*********************************************/
    /**************  IMAGEVIEW INIT  *************/
    /*********************************************/
    if (!self->_fullImageView)
        self->_fullImageView = [[UIImageView alloc] init];
    [self->_fullImageView setFrame:subViewFrame];
    [self->_fullImageView setBackgroundColor:[UIColor clearColor]];
    [self->_fullImageView setClipsToBounds:YES];
    [self->_fullImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self->_fullImageView setUserInteractionEnabled:YES];
    [self->_fullImageView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleMargins];
    
    if([self->_fullImageView superview] == nil)
        [self->_scrollView addSubview:self->_fullImageView];
    
    /*********************************************/
    /**************  TEXTVIEW INIT  **************/
    /*********************************************/
    if (!self->_fullTextView)
        self->_fullTextView = [[UITextView alloc] init];
    [self->_fullTextView setFrame:subViewFrame];
    [self->_fullTextView setBackgroundColor:[UIColor clearColor]];
    [self->_fullTextView setClipsToBounds:YES];
    [self->_fullTextView setTextAlignment:NSTextAlignmentCenter];
    [self->_fullTextView setUserInteractionEnabled:YES];
    [self->_fullTextView setEditable:NO];
    [self->_fullTextView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleMargins];
    
    if([self->_fullTextView superview] == nil)
        [self->_scrollView addSubview:self->_fullTextView];
    
    /*********************************************/
    /************  PROGRESSVIEW INIT  ************/
    /*********************************************/
    CGFloat progressSize = SYGALLERY_IPAD ? 120.f : 80.f;
    if(!self->_circularProgressView)
        self->_circularProgressView = [[DACircularProgressView alloc]
                                       initWithFrame:CGRectMake(0.f, 0.f, progressSize, progressSize)];
    [self->_circularProgressView setHidden:YES];
    [self->_circularProgressView setRoundedCorners:YES];
    [self->_circularProgressView setTrackTintColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.2f]];
    [self->_circularProgressView setProgressTintColor:[UIColor whiteColor]];
    
    if([self->_circularProgressView superview] == nil)
        [self addSubview:self->_circularProgressView];
    
    
    /*********************************************/
    /**************  SINGLETAP INIT  *************/
    /*********************************************/
    
    if (!self->_singleTapGestureRecognizer)
        self->_singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(singleTapOnImageView:)];
    self->_singleTapGestureRecognizer.numberOfTapsRequired = 1;
    if(self->_fullImageView)
        [self->_fullImageView addGestureRecognizer:self->_singleTapGestureRecognizer];
    if(self->_fullTextView)
        [self->_fullTextView addGestureRecognizer:self->_singleTapGestureRecognizer];
    
    /*********************************************/
    /**************  DOUBLETAP INIT  *************/
    /*********************************************/
    if (!self->_doubleTapGestureRecognizer)
        self->_doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(doubleTapOnImageView:)];
    self->_doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    if(self->_fullImageView)
        [self->_fullImageView addGestureRecognizer:self->_doubleTapGestureRecognizer];
    if(self->_fullTextView)
        [self->_fullTextView addGestureRecognizer:self->_doubleTapGestureRecognizer];
    

    /*********************************************/
    /****************  SELF INIT  ****************/
    /*********************************************/
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:
     UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self setUserInteractionEnabled:YES];
    [self setContentMode:UIViewContentModeCenter];
    [self setClipsToBounds:YES];

    [self resetZoomFactors];
}

- (void)resetZoomFactors
{
    if(self->_sourceType == SYGallerySourceTypeText) {
        [self->_scrollView setZoomScale:1.f];
        [self->_scrollView setMinimumZoomScale:1.f];
        [self->_scrollView setMaximumZoomScale:1.f];
        [self setNeedsLayout];
        return;
    }
    
    if(!self->_fullImageView ||
       !self->_fullImageView.image ||
       !self->_fullImageView.image.size.height ||
       !self->_fullImageView.image.size.width)
        return;
    
    // MANDATORY !!
    // before setting the frame we need to have a 1:1 scale between image view and scrollview
    [self->_scrollView setZoomScale:1.0f];
    self->_fullImageView.frame = CGRectMake(0.f, 0.f, self->_fullImageView.image.size.width, self->_fullImageView.image.size.height);
    
    [self->_scrollView setMaximumZoomScale:[self calculateZoomScaleActualSizeWithAdditionnalFactor:1.f]];
    [self->_scrollView setMinimumZoomScale:[self calculateZoomScaleFit]];
    [self->_scrollView setZoomScale:[self calculateZoomScaleFit]];
    
    [self setNeedsLayout];
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

-(void)centerSubView:(UIView*)subview inView:(UIView*)view {
    // http://stackoverflow.com/questions/1316451/center-content-of-uiscrollview-when-smaller

    CGSize boundsSize = view.bounds.size;
    CGRect frameToCenter = subview.frame;
    
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
    
    subview.frame = frameToCenter;
}

-(void)updateImage_private:(UIImage *)image
{
    [self->_circularProgressView setHidden:YES];
    [self->_fullTextView setHidden:YES];
    
    [self->_fullImageView setImage:image];
    [self->_fullImageView setHidden:NO];
    
    [self resetZoomFactors];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - View methods

-(void)updateImageWithImage:(UIImage*)image
{
    self->_sourceType = SYGallerySourceTypeImageData;
    
    [self performSelectorOnMainThread:@selector(updateImage_private:)
                           withObject:image
                        waitUntilDone:NO
                                modes:SYGALLERY_REFRESH_RUNLOOP_MODES];
}

-(void)updateImageWithAbsolutePath:(NSString*)absolutePath
{
    self->_sourceType = SYGallerySourceTypeImageLocal;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:absolutePath];
        [self performSelectorOnMainThread:@selector(updateImage_private:)
                               withObject:image
                            waitUntilDone:NO
                                    modes:SYGALLERY_REFRESH_RUNLOOP_MODES];
    });
}

-(void)updateImageWithUrl:(NSString*)url
{
    self->_sourceType = SYGallerySourceTypeImageDistant;
    
    [self->_fullTextView setHidden:YES];
    [self->_fullImageView setHidden:NO];
    
    if(self->_picConnection)
        [self->_picConnection cancel];
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:5.f];
    self->_picConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    self->_picData = [NSMutableData data];
    self->_picDataExpectedLenght = 0;

    [self->_picConnection start];
    [self->_circularProgressView setProgress:0.f];
    [self->_circularProgressView setHidden:NO];
    [self->_circularProgressView setNeedsDisplay];
    [self setNeedsDisplay];
}

-(void)updateTextWithString:(NSString *)text andTextColor:(UIColor*)textColor andTextFont:(UIFont *)textFont
{
    self->_sourceType = SYGallerySourceTypeText;
    
    [self->_circularProgressView setHidden:YES];
    [self->_fullImageView setHidden:YES];
    
    [self->_fullTextView setText:text];
    [self->_fullTextView setTextColor:(textColor ? textColor : [UIColor whiteColor])];
    [self->_fullTextView setFont:textFont];
    
    [self->_fullTextView setHidden:NO];
    [self->_fullTextView sizeToFit];
    [self resetZoomFactors];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetZoomFactors];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self centerSubView:self->_circularProgressView inView:self];
    [self centerSubView:self->_fullImageView        inView:self->_scrollView];
    [self centerSubView:self->_fullTextView         inView:self->_scrollView];
}

-(BOOL)isZoomed {
    return [self->_scrollView zoomScale] != [self->_scrollView minimumZoomScale];
}

#pragma mark - UIGestureRecognizer


-(void)singleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer {
    ;
}

-(void)doubleTapOnImageView:(UIGestureRecognizer*)gestureRecognizer {
    
    if(self->_sourceType == SYGallerySourceTypeText) {
        return;
    }
    
    if([self isZoomed])
        [self->_scrollView setZoomScale:self->_scrollView.minimumZoomScale animated:YES];
    else
    {
        // define a rect to zoom to.
        CGPoint touchCenter = [gestureRecognizer locationInView:self->_fullImageView];
        CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self->_scrollView.maximumZoomScale,
                                         self.frame.size.height / self->_scrollView.maximumZoomScale);
        CGPoint zoomPoint = touchCenter;// CGPointMake(touchCenter.x * self.zoomScale, touchCenter.y * self.zoomScale);
        
        CGFloat x = zoomPoint.x - zoomRectSize.width * .5f;
        CGFloat y = zoomPoint.y - zoomRectSize.height * .5f;
        CGRect zoomArea = CGRectMake(x < 0.f ? 0.f : x,
                                     y < 0.f ? 0.f : y,
                                     zoomRectSize.width,
                                     zoomRectSize.height);
        
        [self->_scrollView zoomToRect:zoomArea animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if(self->_sourceType == SYGallerySourceTypeText)
        return self->_fullTextView;
    else
        return self->_fullImageView;
}

#pragma mark - NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self->_picData setLength:0];
    self->_picDataExpectedLenght = response.expectedContentLength;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self->_picData appendData:data];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    __block SYGalleryFullPage *safeSelf = self;

    CGFloat progress = 0.f;
    if(self->_picDataExpectedLenght > 0)
        progress = (CGFloat)[self->_picData length] / (CGFloat)self->_picDataExpectedLenght;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [safeSelf->_circularProgressView setProgress:progress animated:YES];
    });
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    __block SYGalleryFullPage *safeSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [safeSelf->_circularProgressView setHidden:YES];
        [safeSelf->_fullImageView setImage:[UIImage imageWithData:self->_picData]];
        [safeSelf resetZoomFactors];
        [safeSelf setNeedsDisplay];
        [safeSelf setNeedsLayout];

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
    });
}


@end
