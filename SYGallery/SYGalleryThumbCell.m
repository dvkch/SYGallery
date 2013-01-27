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
#import "MKNumberBadgeView.h"
#import "NSURLConnection+Blocks.h"

@interface SYGalleryThumbSelectionBackgroundView : UIView
@end

@interface SYGalleryThumbCell (Private)
-(void)resetCellUsingDefaults;
-(void)updateCellForImage_private:(UIImage *)image;
@end

@implementation SYGalleryThumbCell

@synthesize cellSize = _cellSize;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) { [self resetCellUsingDefaults]; }
    return self;
}

#pragma mark - Private methods

-(void)resetCellUsingDefaults {
    /*********************************************/
    /*************  PROPERTIES INIT  *************/
    /*********************************************/
    self->_badgeHidden = YES;
    self->_badgeValue = 0;
    
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    
    if(!self.selectedBackgroundView)
    {
        self.selectedBackgroundView = [[SYGalleryThumbSelectionBackgroundView alloc] init];
        [self.selectedBackgroundView setFrame:CGRectMake(-2.f, -2.f, 79.f, 79.f)];
    }
    
    /*********************************************/
    /************  CONTENTVIEW INIT  *************/
    /*********************************************/
    [self.contentView setClipsToBounds:NO];
    [self.contentView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
#warning MainView really necessary ? (for badge maybe)
    /*********************************************/
    /**************  MAINVIEW INIT  **************/
    /*********************************************/
    if (!self->_mainView)
    {
        self->_mainView = [[UIView alloc] init];
        [self->_mainView setFrame:subViewFrame];
        [self->_mainView setClipsToBounds:YES];
        [self->_mainView setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        // background color set via appearance delegate of SYGalleryThumbView
    }
    
    if([self->_mainView superview] == nil)
        [self.contentView addSubview:self->_mainView];
    
    
    /*********************************************/
    /*************  TEXTLABEL INIT  **************/
    /*********************************************/
    if (!self->_textLabel)
    {
        self->_textLabel = [[UILabel alloc] init];
        [self->_textLabel setFrame:subViewFrame];
        [self->_textLabel setBackgroundColor:[UIColor clearColor]];
        [self->_textLabel setClipsToBounds:YES];
        [self->_textLabel setLineBreakMode:UILineBreakModeWordWrap];
        [self->_textLabel setNumberOfLines:0];
        [self->_textLabel setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    
    if([self->_textLabel superview] == nil)
        [self->_mainView addSubview:self->_textLabel];
    
    
    /*********************************************/
    /*************  THUMBVIEW INIT  **************/
    /*********************************************/
    if(!self->_thumbImageView)
    {
        self->_thumbImageView = [[UIImageView alloc] init];
        [self->_thumbImageView setFrame:subViewFrame];
        [self->_thumbImageView setClipsToBounds:YES];
        [self->_thumbImageView setBackgroundColor:[UIColor clearColor]];
        [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self->_thumbImageView setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    [self->_thumbImageView setImage:nil];
    
    if([self->_thumbImageView superview] == nil)
        [self->_mainView addSubview:self->_thumbImageView];
    
    
    /*********************************************/
    /*************  BADGEVIEW INIT  **************/
    /*********************************************/
    // MKNumberBadgeView won't initialize properly if not using initWithFrame or initWithCoder
    if(!self->_badgeView)
    {
        self->_badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.f)];
        CGFloat totalHeight = self->_badgeView.badgeSize.height + self->_badgeView.strokeWidth * 2.f;
        CGRect badgeFrame = CGRectMake(0.f, -3.f, self.frame.size.width + 2.f, totalHeight);
        [self->_badgeView setFrame:badgeFrame];
        [self->_badgeView setHideWhenZero:NO];
        [self->_badgeView setAlignment:UITextAlignmentRight];
        [self->_badgeView setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        [self->_badgeView setShadow:NO];
        [self->_badgeView setValue:self->_badgeValue];
        [self->_badgeView setHidden:self->_badgeHidden];
    }
    
    if([self->_badgeView superview] == nil)
        [self.contentView addSubview:self->_badgeView];
    
    
    /*********************************************/
    /********  ACTIVITY INDICATOR INIT  **********/
    /*********************************************/
    if(!self->_activityIndicatorView)
    {
        self->_activityIndicatorView = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self->_activityIndicatorView setFrame:subViewFrame];
        [self->_activityIndicatorView setBackgroundColor:[UIColor clearColor]];
        [self->_activityIndicatorView setHidesWhenStopped:YES];
        [self->_activityIndicatorView stopAnimating];
        [self->_activityIndicatorView setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }

    if([self->_activityIndicatorView superview] == nil)
        [self->_mainView addSubview:self->_activityIndicatorView];
}

-(void)updateCellForImage_private:(UIImage *)image
{
    [self->_activityIndicatorView stopAnimating];
    if(self->_sourceType == SYGallerySourceTypeText)
        return;
    
    [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self->_thumbImageView setImage:image];
}


#pragma mark - View methods
-(void)updateCellForAbsolutePath:(NSString*)absolutePath andShowActivityIndicator:(BOOL)showActivityIndicator {
    self->_sourceType = SYGallerySourceTypeImageLocal;
    [self->_thumbImageView setImage:nil];
    [self->_textLabel setText:@""];
    
    [self->_thumbImageView setContentMode:UIViewContentModeScaleAspectFill];
    if(showActivityIndicator)
        [self->_activityIndicatorView startAnimating];
    
    __block SYGalleryThumbCell *safeSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:absolutePath];
        [safeSelf performSelectorOnMainThread:@selector(updateCellForImage_private:)
                                   withObject:image
                                waitUntilDone:NO
                                        modes:SYGALLERY_REFRESH_RUNLOOP_MODES];
    });
}

-(void)updateCellForImage:(UIImage*)image andShowActivityIndicator:(BOOL)showActivityIndicator {
    self->_sourceType = SYGallerySourceTypeImageData;
    [self->_thumbImageView setImage:nil];
    [self->_textLabel setText:@""];
    
    if(showActivityIndicator)
        [self->_activityIndicatorView startAnimating];
    
    [self performSelectorOnMainThread:@selector(updateCellForImage_private:)
                           withObject:image
                        waitUntilDone:NO
                                modes:SYGALLERY_REFRESH_RUNLOOP_MODES];
}

-(void)updateCellForUrl:(NSString*)url {
    self->_sourceType = SYGallerySourceTypeImageDistant;
    [self->_thumbImageView setImage:nil];
    [self->_textLabel setText:@""];
    
    [self->_activityIndicatorView startAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:5.];
    
    [NSURLConnection asyncRequest:request success:^(NSData *data, NSURLResponse *response)
     {
        [self performSelectorOnMainThread:@selector(updateCellForImage_private:)
                               withObject:[UIImage imageWithData:data]
                            waitUntilDone:NO
                                    modes:SYGALLERY_REFRESH_RUNLOOP_MODES];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     }
                          failure:^(NSData *data, NSError *err)
     {
        [self performSelectorOnMainThread:@selector(updateCellForMissingImage)
                               withObject:nil
                            waitUntilDone:NO
                                    modes:SYGALLERY_REFRESH_RUNLOOP_MODES];
        
        [self->_activityIndicatorView stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     }];
}

-(void)updateCellForMissingImage {
    [self->_thumbImageView setImage:nil];
    [self->_textLabel setText:@""];
    
    [self->_thumbImageView setContentMode:UIViewContentModeCenter];
    [self->_thumbImageView setImage:[UIImage imageNamed:@"no_picture.png"]];
}

-(void)updateCellForText:(NSString *)text andTextColor:(UIColor*)textColor andTextFont:(UIFont *)textFont {
    self->_sourceType = SYGallerySourceTypeText;
    [self->_thumbImageView setImage:nil];
    [self->_textLabel setText:@""];
    
    self->_textLabel.text = text;
    self->_textLabel.textColor = textColor ? textColor : [UIColor whiteColor];
    self->_textLabel.textAlignment = NSTextAlignmentCenter;
    
    if(textFont) {
        [self->_textLabel setFont:textFont];
    }
    else {
        CGFloat calcFontSize = 1.f;
        CGFloat maxWidth = self.cellSize.width - 4.f;
        CGFloat maxHeight = self.cellSize.height - 4.f;
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
    [self->_badgeView setValue:self->_badgeValue];
}

-(void)setBadgeHidden:(BOOL)badgeHidden
{
    self->_badgeHidden = badgeHidden;
    [self->_badgeView setHidden:badgeHidden];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [self->_mainView setBackgroundColor:backgroundColor];
}

-(UIColor*)backgroundColor {
    return self->_mainView.backgroundColor;
}


@end

// Thanks to https://github.com/ldesroziers/NRGridView.git
@implementation SYGalleryThumbSelectionBackgroundView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setOpaque:NO];
        [self setContentMode:UIViewContentModeRedraw];
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat cornerRadius = 5.;
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:[self bounds]
                                                           cornerRadius:cornerRadius];
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, [roundedPath CGPath]);
    CGContextClip(ctx);
    
    CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[2] = {0.0, 1.0};
    CGColorRef top, bottom;
    top = [[UIColor colorWithRed:108.f/255.f green:178.f/255.f blue:226.f/255.f alpha:1.] CGColor];
    bottom = [[UIColor colorWithRed:59.f/255.f green:136.f/255.f blue:206.f/255.f alpha:1.] CGColor];
    
    CGFloat components[8] = {CGColorGetComponents(top)[0],CGColorGetComponents(top)[1],CGColorGetComponents(top)[2],CGColorGetComponents(top)[3]
        ,CGColorGetComponents(bottom)[0],CGColorGetComponents(bottom)[1],CGColorGetComponents(bottom)[2],CGColorGetComponents(bottom)[3]};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(spaceRef, components, locations, (size_t)2);
    CGContextDrawLinearGradient(ctx, gradient, [self bounds].origin, CGPointMake(CGRectGetMinX([self bounds]), CGRectGetMaxY([self bounds])), (CGGradientDrawingOptions)NULL);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(spaceRef);
    
    CGContextRestoreGState(ctx);
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, 1);
    CGPathRef translatedPath = CGPathCreateCopyByTransformingPath([roundedPath CGPath], &translation);
    
    CGContextSaveGState(ctx);
    CGContextBeginTransparencyLayer(ctx, NULL);
    
    CGContextAddPath(ctx, [roundedPath CGPath]);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:95.f/255.f green:165.f/255.f blue:220.f/255.f alpha:1.] CGColor]);
    CGContextFillPath(ctx);
    
    CGContextAddPath(ctx, translatedPath);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextFillPath(ctx);
    
    CGPathRelease(translatedPath);
    CGContextEndTransparencyLayer(ctx);
    CGContextRestoreGState(ctx);
    
    
    CGContextSaveGState(ctx);
    CGContextBeginTransparencyLayer(ctx, NULL);
    
    CGContextAddPath(ctx, [roundedPath CGPath]);
    CGContextSetFillColorWithColor(ctx, [[[UIColor whiteColor] colorWithAlphaComponent:0.15f] CGColor]);
    CGContextFillPath(ctx);
    
    translation = CGAffineTransformMakeTranslation(0, 2);
    translatedPath = CGPathCreateCopyByTransformingPath([roundedPath CGPath], &translation);
    
    CGContextAddPath(ctx, translatedPath);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextFillPath(ctx);
    
    CGPathRelease(translatedPath);
    CGContextEndTransparencyLayer(ctx);
    CGContextRestoreGState(ctx);
    
    
    CGContextSaveGState(ctx);
    CGContextBeginTransparencyLayer(ctx, NULL);
    
    CGContextAddPath(ctx, [roundedPath CGPath]);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:55.f/255.f green:124.f/255.f blue:191.f/255.f alpha:1.] CGColor]);
    CGContextFillPath(ctx);
    
    translation = CGAffineTransformMakeTranslation(0, -1);
    translatedPath = CGPathCreateCopyByTransformingPath([roundedPath CGPath], &translation);
    
    CGContextAddPath(ctx, translatedPath);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextFillPath(ctx);
    
    CGPathRelease(translatedPath);
    CGContextEndTransparencyLayer(ctx);
    CGContextRestoreGState(ctx);
    
}

@end

