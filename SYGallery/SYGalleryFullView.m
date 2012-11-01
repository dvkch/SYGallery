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

@interface SYGalleryFullView (Private)
-(void)loadView;
-(void)layoutViews;

-(uint)numberOfPictures;

-(CGRect)frameForPageIndex:(uint)index;
-(void)updatePageFrame:(uint)index;
-(void)updatePagesFrames;

-(void)resetPageZoomsAtIndex:(uint)index;
-(void)resetPagesZooms;

-(void)loadPageAtIndex:(uint)pageIndex;

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
}

-(uint)numberOfPictures {
    uint n = 0;
    if(self.dataSource)
        n = [self.dataSource numberOfItemsInGallery:self];

    return n;
}

-(uint)currentIndexCalculated {
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    return (uint)(floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
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
    SYGalleryFullPage *page = [self->_galleryPages objectAtIndex:index];
    if(![page isKindOfClass:[NSNull class]])
        [[self->_galleryPages objectAtIndex:index] resetZoomFactors];
}

-(void)layoutViews {
    [self updateScrollView];
    [self updatePagesFrames];
}

#pragma mark - View methods
/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currentPageOffset = [hostingScrollView contentOffset].x / [hostingScrollView bounds].size.width;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    //  Layout changed instantly at this time.
    //  So we have to force to set offset instantly by setting animation to NO.
    [hostingScrollView setContentOffset:CGPointMake([hostingScrollView bounds].size.width * currentPageOffset, 0.0f) animated:NO];
}
*/

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

-(void)reloadGalleryAndScrollToIndex:(NSUInteger)index {
    uint picCount = [self numberOfPictures];
    
    self->_galleryPages = [[NSMutableArray alloc] init];
    for (uint i = 0; i < picCount; i++)
        [self->_galleryPages addObject:[NSNull null]];
    
    NSUInteger indexToLoad = index >= [self numberOfPictures] ? 0 : index;
    [self layoutViews];
    [self scrollToPage:indexToLoad animated:NO];
}

-(void)loadPageAtIndex:(uint)pageIndex {

    if (pageIndex >= [self numberOfPictures] || ! self.dataSource)
        return;
    
    // loads page from array, replaces the placeholder if necessary
    SYGalleryFullPage *pageView = [self->_galleryPages objectAtIndex:pageIndex];
    if (![pageView isKindOfClass:[NSNull class]])
        return;
    
    pageView = [[SYGalleryFullPage alloc] initWithFrame:[self frameForPageIndex:pageIndex]
                                          andPageNumber:pageIndex];
    pageView.autoresizesSubviews = YES;
    pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self->_galleryPages replaceObjectAtIndex:pageIndex withObject:pageView];
    
    SYGallerySourceType sourceType = [self.dataSource gallery:self
                                            sourceTypeAtIndex:(uint)pageIndex];
    
    if(sourceType == SYGallerySourceTypeDistant)
        [pageView updateImageWithUrl:[self.dataSource gallery:self
                                                   urlAtIndex:(uint)pageIndex
                                                      andSize:SYGalleryPhotoSizeFull]];
    else
        [pageView updateImageWithAbsolutePath:[self.dataSource gallery:self
                                                   absolutePathAtIndex:(uint)pageIndex
                                                               andSize:SYGalleryPhotoSizeFull]];
    
    [self->_scrollView addSubview:pageView];
}

-(void)scrollToPage:(uint)pageIndex animated:(BOOL)animated {
    
    CGRect rect = CGRectMake(self->_scrollView.frame.size.width * pageIndex,
                             0.f,
                             self->_scrollView.frame.size.width,
                             self->_scrollView.frame.size.height);

    [self loadPageAtIndex:pageIndex];
    [self->_scrollView scrollRectToVisible:rect
                                  animated:animated];
}

#pragma mark - UIScrollViewDelegate<NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    NSUInteger currentIndex = [self currentIndexCalculated];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    if(currentIndex != 0)
        [self loadPageAtIndex:currentIndex -1];
    [self loadPageAtIndex:currentIndex];
    [self loadPageAtIndex:currentIndex +1];

    // A possible optimization would be to unload the views+controllers which are no longer visible
}

/*
// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// called on finger up if the user dragged. velocity is in points/second.
// targetContentOffset may be changed to adjust where the scroll view comes
// to rest. not called when pagingEnabled is YES
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

// return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
}

// called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView
                          withView:(UIView *)view {
    
}

// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale {
    
}

// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
}
*/

@end
