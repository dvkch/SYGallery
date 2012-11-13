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
-(void)setupCachedCellsArray;
@end


@implementation SYGalleryThumbView

@synthesize dataSource = _dataSource;
@synthesize actionDelegate = _actionDelegate;
@synthesize cacheImages = _cacheImages;
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
    self->_cacheImages = NO;
    
    self->_cellBorderColor = [UIColor blackColor];
    self->_cellBorderWidth = 1.f;
    
    /*********************************************/
    /**************  GRIDVIEW INIT  **************/
    /*********************************************/
    if(!self->_gridView)
        self->_gridView = [[GMGridView alloc] initWithFrame:
                           CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
    self->_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self->_gridView.backgroundColor = [UIColor clearColor];
    
    self->_gridView.style = GMGridViewStyleSwap;
    self->_gridView.itemSpacing = CELL_SPACING;
    self->_gridView.minEdgeInsets = UIEdgeInsetsMake(CELL_SPACING, CELL_SPACING, CELL_SPACING, CELL_SPACING);
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

-(void)setupCachedCellsArray {
    int capacity = [self numberOfItemsInGMGridView:self->_gridView];
    capacity = capacity < 0 ? 0 : capacity;
    
    if(self->_cacheImages) {
        self->_cachedCells = [NSMutableArray arrayWithCapacity:(uint)capacity];
        for (uint i = 0; i < (uint)capacity; ++i)
            [self->_cachedCells addObject:[[SYGalleryThumbCell alloc] init]];
    }
    
    else
        self->_cachedCells = nil;
}

#pragma mark - View methods

-(void)reloadGallery {
    [self setupCachedCellsArray];
    [self->_gridView reloadData];
}

-(void)setDataSource:(id<SYGalleryDataSource>)dataSource {
    self->_dataSource = dataSource;
    [self reloadGallery];
}

-(void)setActionDelegate:(id<SYGalleryThumbViewActions>)actionDelegate {
    self->_actionDelegate = actionDelegate;
    [self reloadGallery];
}

-(void)setCacheImages:(BOOL)cacheImages {
    self->_cacheImages = cacheImages;
    [self setupCachedCellsArray];
}

-(void)setEdit:(BOOL)edit {
    self->_edit = edit;
    [self->_gridView setEditing:edit animated:YES];
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

-(void)setCellBorderWidth:(CGFloat)width andColor:(UIColor*)color {
    self->_cellBorderColor = color;
    self->_cellBorderWidth = width;
    
    for (SYGalleryThumbCell *cell in self->_cachedCells) {
        [cell updateCellBorderWidth:width andColor:color];
        [cell setNeedsDisplay];
    }
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
    return CGSizeMake(CELL_SIZE, CELL_SIZE);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    
    if(index < 0)
        return  [[SYGalleryThumbCell alloc] initWithFrame:CGRectMake(0.f, 0.f, CELL_SIZE, CELL_SIZE)];

    SYGalleryThumbCell *cell = nil;
    NSString *cellIdentifier = @"photoCell";

    // loading cached cell if said so
    if(self->_cacheImages)
        cell = [self->_cachedCells objectAtIndex:(uint)index];
    else
        cell = (SYGalleryThumbCell *)[self->_gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // cell couldn't be loaded from cached nor queued reusable cells
    if(!cell)
        cell = [[SYGalleryThumbCell alloc] initWithFrame:CGRectMake(0.f, 0.f, CELL_SIZE, CELL_SIZE)];
    
    // caching cell if necessary
    if(self->_cacheImages)
        [self->_cachedCells replaceObjectAtIndex:(uint)index withObject:cell];
    
    [cell updateCellBorderWidth:self->_cellBorderWidth andColor:self->_cellBorderColor];
    
    SYGallerySourceType sourceType = [self.dataSource gallery:self
                                            sourceTypeAtIndex:(uint)index];
    
    if(!self->_cacheImages || !cell.hasBeenLoaded) {
        
        switch (sourceType) {
            case SYGallerySourceTypeDistant:
                [cell updateCellForUrl:[self.dataSource gallery:self
                                                     urlAtIndex:(uint)index
                                                        andSize:SYGalleryPhotoSizeThumb]];
                break;
            case SYGallerySourceTypeLocal:
                [cell updateCellForAbsolutePath:[self.dataSource gallery:self
                                                     absolutePathAtIndex:(uint)index
                                                                 andSize:SYGalleryPhotoSizeThumb]];
                break;
        }
    }
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {

    if(self.dataSource && index >= 0)
        return [self.dataSource gallery:self canDeleteAtIndex:(uint)index];
    
    return NO;
}

#pragma mark Protocol GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {

    self->_lastClickedItemIndex = (position < 0 || position >= (int)[self.dataSource numberOfItemsInGallery:self] ?
                                   0 :
                                   (uint)position);
    
    if(self.actionDelegate && position >= 0)
       [self.actionDelegate gallery:self didTapOnItemAtIndex:(uint)position];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView {
    return;
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index {
    if(self.actionDelegate && index >= 0)
        [self.actionDelegate gallery:self deletActionForItemAtIndex:(uint)index];
    
    if(self.dataSource && index >= 0)
        [self.dataSource gallery:self deleteItemInAtIndex:(uint)index];
}

- (void)GMGridView:(GMGridView *)gridView changedEdit:(BOOL)edit {
    if(self.actionDelegate)
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
