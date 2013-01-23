//
//  SYGalleryThumbView.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYGalleryThumbView.h"
#import "GMGridView.h"
#import "SYGalleryThumbCell.h"

@interface SYGalleryThumbView (Private)
-(void)loadView;
@end


@implementation SYGalleryThumbView

@synthesize dataSource = _dataSource;
@synthesize actionDelegate = _actionDelegate;
@synthesize edit = _edit;
@synthesize lastClickedItemIndex = _lastClickedItemIndex;

#pragma mark - Initialization

-(id)init
{ if (self = [super init]) { [self loadView]; } return self; }

-(id)initWithCoder:(NSCoder *)aDecoder
{ if (self = [super initWithCoder:aDecoder]) { [self loadView]; } return self; }

- (id)initWithFrame:(CGRect)Frame
{ if (self = [super initWithFrame:Frame]) { [self loadView]; } return self; }


#pragma mark - Private methods

-(void)loadView {
    
    /*********************************************/
    /*************  PROPERTIES INIT  *************/
    /*********************************************/
    self->_edit = NO;
    
    /*********************************************/
    /**************  GRIDVIEW INIT  **************/
    /*********************************************/
    if(!self->_gridView)
        self->_gridView = [[GMGridView alloc] initWithFrame:
                           CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
    self->_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self->_gridView.backgroundColor = [UIColor clearColor];
    
    self->_gridView.style = GMGridViewStyleSwap;
    self->_gridView.itemSpacing = SYGALLERY_DEFAULT_CELL_SPACING;
    self->_gridView.minEdgeInsets = UIEdgeInsetsMake(SYGALLERY_DEFAULT_CELL_SPACING, SYGALLERY_DEFAULT_CELL_SPACING,
                                                     SYGALLERY_DEFAULT_CELL_SPACING, SYGALLERY_DEFAULT_CELL_SPACING);
    self->_gridView.centerGrid = NO;
    self->_gridView.showsVerticalScrollIndicator = YES;
    self->_gridView.showsHorizontalScrollIndicator = NO;
    self->_gridView.alwaysBounceVertical = YES;
    
    // so that cells cannot be moved
    self->_gridView.enableEditOnLongPress = NO;
    self->_gridView.sortingDelegate = nil;
    
    self->_gridView.actionDelegate = self;
    self->_gridView.dataSource = self;

    if([self->_gridView superview] == nil)
        [self addSubview:self->_gridView];
    
    /*********************************************/
    /****************  SELF INIT  ****************/
    /*********************************************/
    self.clipsToBounds = YES;
}

#pragma mark - View methods

-(void)reloadGalleryAndKeepEditState:(BOOL)keepEditState {
    [self setEdit:keepEditState && self.edit];
    CGFloat cellSpacing = SYGALLERY_DEFAULT_CELL_SPACING;
    if([self.appearanceDelegate respondsToSelector:@selector(galleryThumbCellSpacing:)])
        cellSpacing = [self.appearanceDelegate galleryThumbCellSpacing:self];
    
    self->_gridView.itemSpacing = cellSpacing;
    self->_gridView.minEdgeInsets = UIEdgeInsetsMake(cellSpacing, cellSpacing, cellSpacing, cellSpacing);
    
    [self->_gridView reloadData];
}

-(void)setDataSource:(id<SYGalleryDataSource>)dataSource {
    self->_dataSource = dataSource;
    [self reloadGalleryAndKeepEditState:NO];
}

-(void)setActionDelegate:(id<SYGalleryThumbViewActions>)actionDelegate {
    self->_actionDelegate = actionDelegate;
    [self reloadGalleryAndKeepEditState:NO];
}

-(void)setEdit:(BOOL)edit {
    self->_edit = edit;
    [self->_gridView setEditing:edit];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self->_gridView setFrame:
     CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self->_gridView setBackgroundColor:backgroundColor];
}

#pragma mark - GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    int numberOfItems = 0;
    if(self.dataSource)
        numberOfItems = (int)[self.dataSource numberOfItemsInGallery:self];
    numberOfItems = numberOfItems >= 0 ? numberOfItems : 0;
    
    return numberOfItems;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    CGFloat cellSize = SYGALLERY_DEFAULT_CELL_SIZE;
    if([self.appearanceDelegate respondsToSelector:@selector(galleryThumbCellSize:)])
        cellSize = [self.appearanceDelegate galleryThumbCellSize:self];
    
    return CGSizeMake(cellSize, cellSize);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    
    CGFloat cellSize = SYGALLERY_DEFAULT_CELL_SIZE;
    if([self.appearanceDelegate respondsToSelector:@selector(galleryThumbCellSize:)])
        cellSize = [self.appearanceDelegate galleryThumbCellSize:self];
    
    if(index < 0)
        return  [[SYGalleryThumbCell alloc] initWithFrame:CGRectMake(0.f, 0.f, cellSize, cellSize)];

    NSString *cellIdentifier = @"photoCell";
    SYGalleryThumbCell *cell = (SYGalleryThumbCell *)[self->_gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
        cell = [[SYGalleryThumbCell alloc] initWithFrame:CGRectMake(0.f, 0.f, cellSize, cellSize)];
    
    [cell setReuseIdentifier:cellIdentifier];
    [cell setCellSize:cellSize];
    
    UIColor *borderColor = SYGALLERY_DEFAULT_CELL_BORDER_COLOR;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:thumbBorderColorAtIndex:)])
        borderColor = [self.appearanceDelegate gallery:self thumbBorderColorAtIndex:(uint)index];
    
    CGFloat borderSize = SYGALLERY_DEFAULT_CELL_BORDER_SIZE;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:thumbBorderSizeAtIndex:)])
        borderSize = [self.appearanceDelegate gallery:self thumbBorderSizeAtIndex:(uint)index];
    
    UIColor *backColor = SYGALLERY_DEFAULT_CELL_BACKGROUND_COLOR;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:thumbBackgroundColor:)])
        backColor = [self.appearanceDelegate gallery:self thumbBackgroundColor:(uint)index];
    
    [cell setBorderWidth:borderSize andColor:borderColor];
    [cell setBackgroundColor:backColor];
    
    SYGallerySourceType sourceType = [self.dataSource gallery:self
                                            sourceTypeAtIndex:(uint)index];
    
    UIColor *textColor = nil;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:textColorAtIndex:andSize:)])
        textColor = [self.appearanceDelegate gallery:self textColorAtIndex:(uint)index andSize:SYGalleryPhotoSizeThumb];
    
    UIFont *textFont = nil;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:textFontAtIndex:andSize:)])
        textFont = [self.appearanceDelegate gallery:self textFontAtIndex:(uint)index andSize:SYGalleryPhotoSizeThumb];
    
    switch (sourceType) {
        case SYGallerySourceTypeImageData:
            [cell updateCellForImage:[self.dataSource gallery:self
                                                  dataAtIndex:(uint)index
                                                      andSize:SYGalleryPhotoSizeThumb]];
            break;
        case SYGallerySourceTypeImageDistant:
            [cell updateCellForUrl:[self.dataSource gallery:self
                                                 urlAtIndex:(uint)index
                                                    andSize:SYGalleryPhotoSizeThumb]];
            break;
        case SYGallerySourceTypeImageLocal:
            [cell updateCellForAbsolutePath:[self.dataSource gallery:self
                                                 absolutePathAtIndex:(uint)index
                                                             andSize:SYGalleryPhotoSizeThumb]];
            break;
        case SYGallerySourceTypeText:
            [cell updateCellForText:[self.dataSource gallery:self
                                                 textAtIndex:(uint)index
                                                     andSize:SYGalleryPhotoSizeThumb]
                       andTextColor:textColor
                        andTextFont:textFont];
            break;
    }
    
    BOOL showBadge = NO;
    NSUInteger badgeValue = 0;
    if([self.dataSource respondsToSelector:@selector(gallery:shouldDisplayBadgeAtIndex:)])
        showBadge = [self.dataSource gallery:self shouldDisplayBadgeAtIndex:(uint)index];
    
    if([self.dataSource respondsToSelector:@selector(gallery:badgeValueAtIndex:)])
        badgeValue = [self.dataSource gallery:self badgeValueAtIndex:(uint)index];
    
    if(showBadge)
        [cell setBadgeValue:badgeValue];
    
    [cell setBadgeHidden:!showBadge];
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {

    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(gallery:canDeleteAtIndex:)] &&
       index >= 0)
        return [self.dataSource gallery:self canDeleteAtIndex:(uint)index];
    
    return NO;
}

#pragma mark Protocol GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {

    self->_lastClickedItemIndex = (position < 0 || position >= (int)[self.dataSource numberOfItemsInGallery:self] ?
                                   0 :
                                   (uint)position);
    
    if(self.actionDelegate &&
       [self.actionDelegate respondsToSelector:@selector(gallery:didTapOnItemAtIndex:)] &&
       position >= 0)
        
        [self.actionDelegate gallery:self didTapOnItemAtIndex:(uint)position];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView {
    return;
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index {
    if(self.actionDelegate &&
       [self.actionDelegate respondsToSelector:@selector(gallery:deletActionForItemAtIndex:)] &&
       index >= 0)
        
        [self.actionDelegate gallery:self deletActionForItemAtIndex:(uint)index];
    
    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(gallery:deleteItemInAtIndex:)] &&
       index >= 0)
        [self.dataSource gallery:self deleteItemInAtIndex:(uint)index];
}

- (void)GMGridView:(GMGridView *)gridView changedEdit:(BOOL)edit {
    if(self.actionDelegate
       && [self.actionDelegate respondsToSelector:@selector(gallery:changedEditStateTo:)])
        
        [self.actionDelegate gallery:self changedEditStateTo:edit];
}

#pragma mark Protocol GMGridViewSortingDelegate

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex {
    return;
}
- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2 {
    return;
}
- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell {
    return;
}
- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell {
    return;
}
- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)view atIndex:(NSInteger)index {
    return NO;
}

#pragma mark Protocol GMGridViewTransformationDelegate
/*
- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell
             atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
}
- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index {
    
}
- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell {
    
}
- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(GMGridViewCell *)cell {
    
}
- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell {
    
}
*/
@end
