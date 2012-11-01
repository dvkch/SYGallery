//
//  SYGalleryThumbCell.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SYGalleryThumbCell.h"
#import "GMGridViewCell.h"


@interface SYGalleryThumbCell (Private)
-(void)setDefaults;
-(void)resetCellUsingDefaults:(BOOL)useDefaults;
@end

@implementation SYGalleryThumbCell : GMGridViewCell

@synthesize hasBeenLoaded = _hasBeenLoaded;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) { [self resetCellUsingDefaults:YES]; }
    return self;
}

#pragma mark - Private methods

-(void)setDefaults {
    self->_cellBorderColor = [UIColor blackColor];
    self->_cellBorderWidth = 1.f;
}

-(void)resetCellUsingDefaults:(BOOL)useDefaults {
    if(useDefaults)
        [self setDefaults];
    
    self.hasBeenLoaded = NO;
    
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);

    if (!self->_mainView)
        self->_mainView = [[UIView alloc] init];
    [self->_mainView setFrame:subViewFrame];
    [self->_mainView setBackgroundColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.8f]];
    [self->_mainView setClipsToBounds:YES];
    [self->_mainView.layer setBorderColor:self->_cellBorderColor.CGColor];
    [self->_mainView.layer setBorderWidth:self->_cellBorderWidth];
    [self->_mainView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if (!self->_label)
        self->_label = [[UILabel alloc] init];
    [self->_label setFrame:subViewFrame];
    [self->_label setBackgroundColor:[UIColor clearColor]];
    [self->_label setClipsToBounds:YES];
    [self->_label setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if(!self->_thumbImageView)
        self->_thumbImageView = [[UIImageView alloc] init];
    [self->_thumbImageView setFrame:subViewFrame];
    [self->_thumbImageView setClipsToBounds:YES];
    [self->_thumbImageView setBackgroundColor:[UIColor clearColor]];
    [self->_thumbImageView setContentMode:UIViewContentModeCenter];
    [self->_thumbImageView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if(!self->_activityIndicatorView)
        self->_activityIndicatorView = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self->_activityIndicatorView setFrame:subViewFrame];
    [self->_activityIndicatorView setBackgroundColor:[UIColor clearColor]];
    [self->_activityIndicatorView setHidesWhenStopped:YES];
    [self->_activityIndicatorView stopAnimating];
    [self->_activityIndicatorView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    [self->_mainView addSubview:self->_thumbImageView];
    [self->_mainView addSubview:self->_label];
    [self->_mainView addSubview:self->_activityIndicatorView];

    self.contentView = self->_mainView;
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

-(void)updateCellForText:(NSString *)text andFont:(UIFont*)font {
    [self resetCellUsingDefaults:NO];
    self.hasBeenLoaded = YES;
    
    CGFloat fontSize = self.frame.size.width * 0.4f;
    if(fontSize < 10.f)
        fontSize = 10.f;
    self->_label.font = font;
    self->_label.text = text;
    self->_label.textColor = [UIColor whiteColor];
    self->_label.textAlignment = NSTextAlignmentCenter;
}

-(void)updateCellBorderWidth:(CGFloat)width andColor:(UIColor*)color {
    self->_cellBorderColor = color;
    self->_cellBorderWidth = width;
    
    if (self->_mainView) {
        [self->_mainView.layer setBorderColor:self->_cellBorderColor.CGColor];
        [self->_mainView.layer setBorderWidth:self->_cellBorderWidth];
    }
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
