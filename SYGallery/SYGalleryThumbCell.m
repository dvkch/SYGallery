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

@implementation SYGalleryThumbCell : GMGridViewCell

@synthesize hasBeenLoaded = _hasBeenLoaded;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) { [self resetCell]; }
    return self;
}

#pragma mark - Private methods
-(void)resetCell {
    self.hasBeenLoaded = NO;
    
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);

    if (!self->_mainView)
        self->_mainView = [[UIView alloc] init];
    [self->_mainView setFrame:subViewFrame];
    [self->_mainView setBackgroundColor:[UIColor whiteColor]];
    [self->_mainView setClipsToBounds:YES];
    [self->_mainView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self->_mainView.layer setBorderWidth:1.0f];
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
    [self resetCell];
    self.hasBeenLoaded = YES;
    
    [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self->_thumbImageView setImage:[UIImage imageWithContentsOfFile:absolutePath]];
}

-(void)updateCellForUrl:(NSString*)url {
    [self resetCell];
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
    [self resetCell];
    self.hasBeenLoaded = YES;
    
    [self->_thumbImageView setContentMode:UIViewContentModeCenter];
    [self->_thumbImageView setImage:[UIImage imageNamed:@"no_picture.png"]];
}

-(void)updateCellForText:(NSString *)text andFont:(UIFont*)font {
    [self resetCell];
    self.hasBeenLoaded = YES;
    
    CGFloat fontSize = self.frame.size.width * 0.4f;
    if(fontSize < 10.f)
        fontSize = 10.f;
    self->_label.font = font;
    self->_label.text = text;
    self->_label.textColor = [UIColor whiteColor];
    self->_label.textAlignment = NSTextAlignmentCenter;
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
