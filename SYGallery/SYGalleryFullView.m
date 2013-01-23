//
//  SYGalleryFullView.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SYGalleryFullView.h"
#import "SYGalleryFullPage.h"
#import "SYGalleryActionView.h"

#import "UIView+Infos.h"

@interface SYGalleryFullView (Private)
-(void)loadView;

-(uint)numberOfPictures;

-(CGRect)frameForPageIndex:(uint)index;
-(void)updatePageFrame:(uint)index;
-(void)updatePagesFrames;

-(void)resetPageZoomsAtIndex:(uint)index;
-(void)resetPagesZooms;

-(void)loadPageAtIndex:(uint)pageIndex;
-(void)loadPagesCloseToVisibleIncludingCurrentIndex:(BOOL)includingCurrentIndex;

-(void)unloadPageAtIndex:(uint)pageIndex;
-(void)unloadPagesHidden;

-(void)updateScrollView;
@end

@implementation SYGalleryFullView

@synthesize dataSource = _dataSource;
@synthesize actionDelegate = _actionDelegate;

#pragma mark - Initialization

-(id)init
{ if (self = [super init]) { [self loadView]; } return self; }

-(id)initWithCoder:(NSCoder *)aDecoder
{ if (self = [super initWithCoder:aDecoder]) { [self loadView]; } return self; }

- (id)initWithFrame:(CGRect)Frame
{ if (self = [super initWithFrame:Frame]) { [self loadView]; } return self; }

#pragma mark - Private methods

-(void)loadView {
    self.backgroundColor = [UIColor blackColor];
    
    CGRect subViewFrame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    
    /*********************************************/
    /*************  SCROLLVIEW INIT  *************/
    /*********************************************/

    if (!self->_scrollView)
        self->_scrollView = [[UIScrollView alloc] init];
    [self->_scrollView setFrame:subViewFrame];
    [self->_scrollView setClipsToBounds:YES];
    [self->_scrollView setAlwaysBounceVertical:NO];
    [self->_scrollView setDirectionalLockEnabled:YES];
    [self->_scrollView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self->_scrollView setPagingEnabled:YES];
    [self->_scrollView setShowsHorizontalScrollIndicator:NO];
    [self->_scrollView setShowsVerticalScrollIndicator:NO];
    [self->_scrollView setScrollsToTop:NO];
    [self->_scrollView setDelegate:self];
    
    if([self->_scrollView superview] == nil)
        [self addSubview:self->_scrollView];
    
    
    /*********************************************/
    /*************  ACTIONLIST INIT  *************/
    /*********************************************/
    if(!self->_actionListView)
        self->_actionListView = [[SYGalleryActionView alloc] init];
    
    [self->_actionListView setFrame:subViewFrame];
    [self->_actionListView setOpeningDirection:SYVerticalDirectionUpward];
    [self->_actionListView setPosition:SYPositionBottomLeft];
    [self->_actionListView setInnerMargin:UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f)];
    [self->_actionListView setAutoresizingMask:
     UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if([self->_actionListView superview] == nil)
        [self addSubview:self->_actionListView];
    
}

-(uint)numberOfPictures {
    uint n = 0;
    if(self.dataSource)
        n = [self.dataSource numberOfItemsInGallery:self];

    return n;
}

-(CGRect)frameForPageIndex:(uint)index {
    
    CGFloat innerMargin = 0.f; //10.f;
    CGFloat margin = 0; //index <= 0 ? 0 : index * PAGE_MARGIN;
    CGRect frame = CGRectMake(self->_scrollView.frame.size.width * index + margin + innerMargin,
                              0.f + innerMargin,
                              self->_scrollView.frame.size.width - 2.f * innerMargin,
                              self->_scrollView.frame.size.height - 2.f * innerMargin);
    
    return frame;
}

- (void)updatePagesFrames
{
	for(uint i = 0; i < [self numberOfPictures]; i++)
         [self updatePageFrame:i];
}

-(void)updatePageFrame:(uint)index {
    SYGalleryFullPage *page = [self->_galleryPages objectAtIndex:index];
    if(![page isKindOfClass:[NSNull class]])
        page.frame = [self frameForPageIndex:index];
}

-(void)updateScrollView {
	float contentWidth = self.frame.size.width * [self numberOfPictures];
	[self->_scrollView setContentSize:CGSizeMake(contentWidth, self->_scrollView.frame.size.height)];
}

-(void)resetPagesZooms {
    for(uint i = 0; i < [self numberOfPictures]; ++i)
        [self resetPageZoomsAtIndex:i];
}

-(void)resetPageZoomsAtIndex:(uint)index {
    
    if(index >= [self numberOfPictures])
        return;
    
    SYGalleryFullPage *page = [self->_galleryPages objectAtIndex:index];
    if(![page isKindOfClass:[NSNull class]])
        [[self->_galleryPages objectAtIndex:index] resetZoomFactors];
}

#pragma mark - View methods

-(uint)currentIndexCalculated {
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    return (uint)(floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
}

-(void)setFrame:(CGRect)frame {
    NSUInteger currentIndex = [self currentIndexCalculated];
    [super setFrame:frame];

    [self updateScrollView];
    [self updatePagesFrames];
    [self resetPagesZooms];
    [self scrollToPage:currentIndex animated:NO];

    [self setNeedsDisplay];
    [self setNeedsLayout];
}

-(void)setDataSource:(id<SYGalleryDataSource>)dataSource {
    self->_dataSource = dataSource;
    [self reloadGalleryAndScrollToIndex:0];
}

-(void)setDataSource:(id<SYGalleryDataSource>)dataSource andFirstItemToShow:(NSUInteger)firstItem {
    self->_dataSource = dataSource;
    [self reloadGalleryAndScrollToIndex:firstItem];
}

-(void)setActionDelegate:(id<SYGalleryFullViewActions>)actionDelegate {
    self->_actionDelegate = actionDelegate;
    if([self.actionDelegate respondsToSelector:@selector(gallery:showedUpPictureAtIndex:)])
        [self.actionDelegate gallery:self showedUpPictureAtIndex:[self currentIndexCalculated]];
}

-(void)reloadGalleryAndScrollToIndex:(NSUInteger)index {
    uint picCount = [self numberOfPictures];
    
    for(UIView *subview in [self->_scrollView subviews])
        [subview removeFromSuperview];
    
    self->_galleryPages = [[NSMutableArray alloc] init];
    for (uint i = 0; i < picCount; i++)
        [self->_galleryPages addObject:[NSNull null]];
    
    NSUInteger indexToLoad = index >= [self numberOfPictures] ? 0 : index;
    
    [self loadPageAtIndex:indexToLoad];
    
    [self updateScrollView];
    [self updatePagesFrames];
    [self resetPagesZooms];

    [self scrollToPage:indexToLoad animated:NO];
    
    if(self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(gallery:showedUpPictureAtIndex:)])
        [self.actionDelegate gallery:self showedUpPictureAtIndex:indexToLoad];
}

-(void)loadPageAtIndex:(uint)pageIndex {
        
    if (pageIndex >= [self numberOfPictures] || ! self.dataSource)
        return;
    
    // loads page from array, replaces the placeholder if necessary
    __block SYGalleryFullPage *pageView = [self->_galleryPages objectAtIndex:pageIndex];
    if (![pageView isKindOfClass:[NSNull class]])
        return;
    
    pageView = [[SYGalleryFullPage alloc] initWithFrame:[self frameForPageIndex:pageIndex]
                                          andPageNumber:pageIndex];
    pageView.autoresizesSubviews = YES;
    pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self->_galleryPages replaceObjectAtIndex:pageIndex withObject:pageView];
    
    SYGallerySourceType sourceType = [self.dataSource gallery:self
                                            sourceTypeAtIndex:(uint)pageIndex];
    
    UIColor *textColor = nil;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:textColorAtIndex:andSize:)])
        textColor = [self.appearanceDelegate gallery:self textColorAtIndex:(uint)pageIndex andSize:SYGalleryPhotoSizeFull];
    UIFont *textFont = nil;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:textFontAtIndex:andSize:)])
        textFont = [self.appearanceDelegate gallery:self textFontAtIndex:(uint)pageIndex andSize:SYGalleryPhotoSizeFull];
    
    switch (sourceType) {
        case SYGallerySourceTypeImageData:
            [pageView updateImageWithImage:[self.dataSource gallery:self
                                                        dataAtIndex:(uint)pageIndex
                                                            andSize:SYGalleryPhotoSizeFull]];
            break;
        case SYGallerySourceTypeImageDistant:
            [pageView updateImageWithUrl:[self.dataSource gallery:self
                                                       urlAtIndex:(uint)pageIndex
                                                          andSize:SYGalleryPhotoSizeFull]];
            break;
        case SYGallerySourceTypeImageLocal:
            [pageView updateImageWithAbsolutePath:[self.dataSource gallery:self
                                                       absolutePathAtIndex:(uint)pageIndex
                                                                   andSize:SYGalleryPhotoSizeFull]];
            break;
        case SYGallerySourceTypeText:
            [pageView updateTextWithString:[self.dataSource gallery:self
                                                        textAtIndex:(uint)pageIndex
                                                            andSize:SYGalleryPhotoSizeFull]
                              andTextColor:textColor
                               andTextFont:textFont];
            
        default:
            break;
    }

    [self->_scrollView addSubview:pageView];
}

-(void)loadPagesCloseToVisibleIncludingCurrentIndex:(BOOL)includingCurrentIndex
{
    int currentIndex = (int)[self currentIndexCalculated];
    int pagesCount   = (int)[self numberOfPictures];
    
    for(int i = 0; i < pagesCount; ++i)
        if(SYGALLERY_INT_BETWEEN_A_AND_B(i, currentIndex-2, currentIndex+2)
           && ((currentIndex == i && includingCurrentIndex) || currentIndex != i))
            [self loadPageAtIndex:(uint)i];
}

-(void)unloadPageAtIndex:(uint)pageIndex
{
    if (pageIndex >= [self numberOfPictures] || ! self.dataSource)
        return;
    
    SYGalleryFullPage *page = [self->_galleryPages objectAtIndex:pageIndex];
    if(![page isKindOfClass:[NSNull class]])
        [page removeFromSuperview];
    
    [self->_galleryPages replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
}

-(void)unloadPagesHidden
{
    int currentIndex = (int)[self currentIndexCalculated];
    int pagesCount   = (int)[self numberOfPictures];
    
    @autoreleasepool {
        for(int i = 0; i < pagesCount; ++i)
            if(!SYGALLERY_INT_BETWEEN_A_AND_B(i, currentIndex-2, currentIndex+2))
                [self unloadPageAtIndex:(uint)i];
    }
}

-(void)scrollToPage:(uint)pageIndex animated:(BOOL)animated {
    
    CGRect rect = CGRectMake(self->_scrollView.frame.size.width * pageIndex,
                             0.f,
                             self->_scrollView.frame.size.width,
                             self->_scrollView.frame.size.height);

    [self loadPageAtIndex:pageIndex];
    [self setNeedsDisplay];
    [self setNeedsLayout];
    
    [self->_scrollView scrollRectToVisible:rect
                                  animated:animated];
}

-(void)addActionWithName:(NSString *)name andTarget:(id)target andSelector:(SEL)selector andTag:(NSInteger)tag {
    [self->_actionListView addActionWithName:name andTarget:target andSelector:selector andTag:tag];
}

-(void)removeActionWithTag:(NSInteger)tag {
    [self->_actionListView removeActionWithTag:tag];
}

#pragma mark - UIScrollViewDelegate<NSObject>

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self->_actionListView setOpened:NO];
    
    uint currentIndex = [self currentIndexCalculated];
    
    [self loadPageAtIndex:currentIndex];
    [self unloadPagesHidden];
    [self loadPagesCloseToVisibleIncludingCurrentIndex:NO];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    uint currentIndex = [self currentIndexCalculated];
    if(self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(gallery:showedUpPictureAtIndex:)])
        [self.actionDelegate gallery:self showedUpPictureAtIndex:currentIndex];
    
    for (UIView *subview in [self->_scrollView subviews])
        if([subview isKindOfClass:[SYGalleryFullPage class]])
            [(SYGalleryFullPage*)subview resetZoomFactors];
}

@end
