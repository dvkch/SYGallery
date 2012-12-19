//
//  SYGalleryThumbCell.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SYGalleryDelegates.h"
#import "SYGalleryThumbCell.h"
#import "GMGridViewCell.h"
#import "MKNumberBadgeView.h"

@interface SYGalleryThumbCell (Private)
-(void)setDefaults;
-(void)resetCellUsingDefaults:(BOOL)useDefaults;
@end

@implementation SYGalleryThumbCell : GMGridViewCell

@synthesize hasBeenLoaded = _hasBeenLoaded;
@synthesize cellSize = _cellSize;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) { [self resetCellUsingDefaults:YES]; }
    return self;
}

#pragma mark - Private methods

-(void)setDefaults {
    self->_badgeHidden = YES;
    self->_badgeValue = 0;
}

-(void)resetCellUsingDefaults:(BOOL)useDefaults {
    /*********************************************/
    /*************  PROPERTIES INIT  *************/
    /*********************************************/
    if(useDefaults)
        [self setDefaults];
    
    self.hasBeenLoaded = NO;
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    
    
    /*********************************************/
    /************  CONTENTVIEW INIT  *************/
    /*********************************************/
    if(!self.contentView)
        self.contentView = [[UIView alloc] initWithFrame:subViewFrame];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.contentView setClipsToBounds:NO];
    [self.contentView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    
    /*********************************************/
    /**************  MAINVIEW INIT  **************/
    /*********************************************/
    if (!self->_mainView)
        self->_mainView = [[UIView alloc] init];
    [self->_mainView setFrame:subViewFrame];
    [self->_mainView setClipsToBounds:YES];
    [self->_mainView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    // background color set via appearance delegate of SYGalleryThumbView
    
    if([self->_mainView superview] == nil)
        [self.contentView addSubview:self->_mainView];
    
    
    /*********************************************/
    /*************  TEXTLABEL INIT  **************/
    /*********************************************/
    if (!self->_textLabel)
        self->_textLabel = [[UILabel alloc] init];
    [self->_textLabel setFrame:subViewFrame];
    [self->_textLabel setBackgroundColor:[UIColor clearColor]];
    [self->_textLabel setClipsToBounds:YES];
    [self->_textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [self->_textLabel setNumberOfLines:0];
    [self->_textLabel setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if([self->_textLabel superview] == nil)
        [self->_mainView addSubview:self->_textLabel];
    
    
    /*********************************************/
    /*************  THUMBVIEW INIT  **************/
    /*********************************************/
    if(!self->_thumbImageView)
        self->_thumbImageView = [[UIImageView alloc] init];
    [self->_thumbImageView setFrame:subViewFrame];
    [self->_thumbImageView setClipsToBounds:YES];
    [self->_thumbImageView setBackgroundColor:[UIColor clearColor]];
    [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self->_thumbImageView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if([self->_thumbImageView superview] == nil)
        [self->_mainView addSubview:self->_thumbImageView];
    
    
    /*********************************************/
    /*************  BADGEVIEW INIT  **************/
    /*********************************************/
    // MKNumberBadgeView won't initialize properly if not using initWithFrame or initWithCoder
    if(!self->_badgeView)
        self->_badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.f)];
    CGFloat totalHeight = self->_badgeView.badgeSize.height + self->_badgeView.strokeWidth * 2.f;
    CGRect badgeFrame = CGRectMake(0.f, -3.f, self.frame.size.width + 2.f, totalHeight);
    [self->_badgeView setFrame:badgeFrame];
    [self->_badgeView setHidden:self->_badgeHidden];
    [self->_badgeView setShadow:NO];
    [self->_badgeView setValue:self->_badgeValue];
    [self->_badgeView setHideWhenZero:NO];
    [self->_badgeView setAlignment:UITextAlignmentRight];
    [self->_badgeView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    
    if([self->_badgeView superview] == nil)
        [self.contentView addSubview:self->_badgeView];
    
    
    /*********************************************/
    /********  ACTIVITY INDICATOR INIT  **********/
    /*********************************************/
    if(!self->_activityIndicatorView)
        self->_activityIndicatorView = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self->_activityIndicatorView setFrame:subViewFrame];
    [self->_activityIndicatorView setBackgroundColor:[UIColor clearColor]];
    [self->_activityIndicatorView setHidesWhenStopped:YES];
    [self->_activityIndicatorView stopAnimating];
    [self->_activityIndicatorView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    if([self->_activityIndicatorView superview] == nil)
        [self->_mainView addSubview:self->_activityIndicatorView];
}

#pragma mark - View methods
-(void)updateCellForAbsolutePath:(NSString*)absolutePath {
    [self resetCellUsingDefaults:NO];
    self.hasBeenLoaded = YES;
    
    [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self->_activityIndicatorView startAnimating];
    
    __block SYGalleryThumbCell *safeSelf = self;
    int64_t delayInMilliSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliSeconds * (int64_t)NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [safeSelf->_thumbImageView setImage:[UIImage imageWithContentsOfFile:absolutePath]];
        [safeSelf->_activityIndicatorView stopAnimating];
        [safeSelf setNeedsDisplay];
    });
}

-(void)updateCellForImage:(UIImage*)image {
    [self resetCellUsingDefaults:NO];
    self.hasBeenLoaded = YES;
    
    [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self->_activityIndicatorView startAnimating];
    
    __block SYGalleryThumbCell *safeSelf = self;
    int64_t delayInMilliSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliSeconds * (int64_t)NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [safeSelf->_thumbImageView setImage:image];
        [safeSelf->_activityIndicatorView stopAnimating];
        [safeSelf setNeedsDisplay];
    });
}

-(void)updateCellForUrl:(NSString*)url {
    [self resetCellUsingDefaults:NO];
    self.hasBeenLoaded = YES;
    
    // cannot use a block version of NSURLConnection because if we load another picture
    // while the first hasn't been loaded it may result in a bizarre behavior

    if(self->_thumbLoadConnection)
        [self->_thumbLoadConnection cancel];
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:5.];
    self->_thumbLoadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    self->_thumbLoadData = [NSMutableData data];
    [self->_thumbLoadConnection start];
    [self->_activityIndicatorView startAnimating];
}

-(void)updateCellForMissingImage {
    [self resetCellUsingDefaults:NO];
    self.hasBeenLoaded = YES;
    
    [self->_thumbImageView setContentMode:UIViewContentModeCenter];
    [self->_thumbImageView setImage:[UIImage imageNamed:@"no_picture.png"]];
}

-(void)updateCellForText:(NSString *)text andTextColor:(UIColor*)textColor andTextFont:(UIFont *)textFont {
    [self resetCellUsingDefaults:NO];
    self.hasBeenLoaded = YES;
    
    self->_textLabel.text = text;
    self->_textLabel.textColor = textColor ? textColor : [UIColor whiteColor];
    self->_textLabel.textAlignment = NSTextAlignmentCenter;
    
    if(textFont) {
        [self->_textLabel setFont:textFont];
    }
    else {
        CGFloat calcFontSize = 1.f;
        CGFloat maxWidth = self.cellSize - 4.f;
        CGFloat maxHeight = self.cellSize - 4.f;
        CGSize calcSize = CGSizeMake(0.f, 0.f);
        while(calcSize.width < maxWidth && calcSize.height < maxHeight) {
            calcFontSize = calcFontSize + .5f;
            calcSize = [text sizeWithFont:[UIFont systemFontOfSize:calcFontSize]
                        constrainedToSize:CGSizeMake(maxWidth, maxHeight)
                            lineBreakMode:UILineBreakModeWordWrap];
        }
        calcFontSize = calcFontSize - .5f;
        [self->_textLabel setFont:[UIFont systemFontOfSize:calcFontSize]];
    }
}

-(void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color
{
    if(color == nil)
        color = [UIColor clearColor];
    
    if (self->_mainView) {
        [self->_mainView.layer setBorderColor:color.CGColor];
        [self->_mainView.layer setBorderWidth:width];
    }
}

-(void)setBadgeValue:(NSUInteger)value
{
    self->_badgeValue = value;
    if (!self->_badgeHidden)
        [self->_badgeView setValue:self->_badgeValue];
}

-(void)setBadgeHidden:(BOOL)badgeHidden
{
    self->_badgeHidden = badgeHidden;
    if(badgeHidden) {
        [self->_badgeView setHideWhenZero:YES];
        [self->_badgeView setValue:0];
    }
    else {
        [self->_badgeView setValue:self->_badgeValue];
        [self->_badgeView setHideWhenZero:NO];
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [self->_mainView setBackgroundColor:backgroundColor];
}

-(UIColor*)backgroundColor {
    return self->_mainView.backgroundColor;
}

#pragma mark - NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self->_thumbLoadData setLength:0];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self->_thumbLoadData appendData:data];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    __block SYGalleryThumbCell *safeSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [safeSelf->_activityIndicatorView stopAnimating];
        [safeSelf->_thumbImageView setImage:[UIImage imageWithData:self->_thumbLoadData]];
        [safeSelf setNeedsDisplay];
        
        safeSelf->_thumbLoadData = nil;
        safeSelf->_thumbLoadConnection = nil;
    });
    
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    __block SYGalleryThumbCell *safeSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [safeSelf->_activityIndicatorView stopAnimating];
        
        safeSelf->_thumbLoadData = nil;
        safeSelf->_thumbLoadConnection = nil;
        safeSelf.hasBeenLoaded = NO;
    });
}

/*
@property (nonatomic, strong) UIView *contentView;         // The contentView - default is nil
@property (nonatomic, strong) UIImage *deleteButtonIcon;   // Delete button image
@property (nonatomic) CGPoint deleteButtonOffset;          // Delete button offset relative to the origin
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
*/

@end
