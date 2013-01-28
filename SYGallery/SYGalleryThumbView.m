//
//  SYGalleryThumbView.m
//  SYGalleryExample
//
//  Created by rominet on 24/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYGalleryThumbView.h"
#import "PSTCollectionView.h"
#import "SYGalleryThumbCell.h"
#import "SYGalleryThumbHeaderView.h"

@interface SYGalleryThumbView (Private)
-(void)loadView;
@end

@implementation SYGalleryThumbView

@synthesize dataSource = _dataSource;
@synthesize actionDelegate = _actionDelegate;
@synthesize multiSelect = _multiSelect;
@synthesize lastClickedItemIndexPath = _lastClickedItemIndexPath;

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
    self->_multiSelect = NO;
    
    /*********************************************/
    /*************  FLOWLAYOUT INIT  *************/
    /*********************************************/
    if(!self->_flowLayout)
    {
        self->_flowLayout = [[PSUICollectionViewFlowLayout alloc] init];
        
        [self->_flowLayout setHeaderReferenceSize:SYGALLERY_DEFAULT_HEADER_SIZE];
        [self->_flowLayout setItemSize:CGSizeMake(SYGALLERY_DEFAULT_CELL_SIZE, SYGALLERY_DEFAULT_CELL_SIZE)];
        [self->_flowLayout setMinimumInteritemSpacing:SYGALLERY_DEFAULT_CELL_SPACING];
        [self->_flowLayout setMinimumLineSpacing:SYGALLERY_DEFAULT_CELL_SPACING];
        [self->_flowLayout setSectionInset:UIEdgeInsetsMake(SYGALLERY_DEFAULT_CELL_SPACING,
                                                            SYGALLERY_DEFAULT_CELL_SPACING,
                                                            SYGALLERY_DEFAULT_CELL_SPACING,
                                                            SYGALLERY_DEFAULT_CELL_SPACING)];
    }
    
    /*********************************************/
    /**************  GRIDVIEW INIT  **************/
    /*********************************************/
    if(!self->_gridView) {
        CGRect frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
        self->_gridView = [[PSUICollectionView alloc] initWithFrame:frame
                                               collectionViewLayout:self->_flowLayout];
    }
    self->_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self->_gridView.backgroundColor = [UIColor clearColor];
    
    self->_gridView.showsVerticalScrollIndicator = YES;
    self->_gridView.showsHorizontalScrollIndicator = NO;
    self->_gridView.alwaysBounceVertical = YES;
    
    self->_gridView.delegate = self;
    self->_gridView.dataSource = self;
    
    [self->_gridView registerClass:[SYGalleryThumbCell class]
        forCellWithReuseIdentifier:SYGALLERY_THUMB_REUSE_IDENTIFIER];
    [self->_gridView registerClass:[SYGalleryThumbHeaderView class]
        forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader
               withReuseIdentifier:SYGALLERY_THUMB_HEADER_REUSE_IDENTIFIER];
    
    if([self->_gridView superview] == nil)
        [self addSubview:self->_gridView];
    
    /*********************************************/
    /****************  SELF INIT  ****************/
    /*********************************************/
    self.clipsToBounds = YES;
}

#pragma mark - View methods

-(void)reloadGallery {
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

-(void)setAppearanceDelegate:(id<SYGalleryAppearence>)appearanceDelegate
{
    self->_appearanceDelegate = appearanceDelegate;
    if(self->_flowLayout && appearanceDelegate)
    {
        CGFloat cellSpacing = SYGALLERY_DEFAULT_CELL_SPACING;
        if([self.appearanceDelegate respondsToSelector:@selector(galleryThumbCellSpacing:)])
            cellSpacing = [self.appearanceDelegate galleryThumbCellSpacing:self];
        
        [self->_flowLayout setMinimumInteritemSpacing:cellSpacing];
        [self->_flowLayout setMinimumLineSpacing:cellSpacing];
        [self->_flowLayout setSectionInset:UIEdgeInsetsMake(cellSpacing, cellSpacing, cellSpacing, cellSpacing)];
        
        CGFloat cellSize = SYGALLERY_DEFAULT_CELL_SIZE;
        if([self.appearanceDelegate respondsToSelector:@selector(galleryThumbCellSize:)])
            cellSize = [self.appearanceDelegate galleryThumbCellSize:self];
        
        [self->_flowLayout setItemSize:CGSizeMake(cellSize, cellSize)];
        
        if(![self.dataSource respondsToSelector:@selector(gallery:titleForSection:)])
            [self->_flowLayout setHeaderReferenceSize:CGSizeZero];
    }
}

-(void)setMultiSelect:(BOOL)multiSelect {
    [self->_gridView setAllowsMultipleSelection:multiSelect];
}

-(BOOL)multiSelect {
    return self->_gridView.allowsMultipleSelection;
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

-(NSArray *)selectedIndexPaths
{
    return [self->_gridView indexPathsForSelectedItems];
}

-(void)deselectAllAnimated:(BOOL)animated
{
    NSArray *selectedPaths = [self selectedIndexPaths];
    for(NSIndexPath *path in selectedPaths)
        [self->_gridView deselectItemAtIndexPath:path animated:animated];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int numberOfSections = 0;
    if(self.dataSource)
        numberOfSections = (int)[self.dataSource numberOfSectionsInGallery:self];
    numberOfSections = numberOfSections >= 0 ? numberOfSections : 0;
    
    return numberOfSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section < 0)
        return 0;
    
    int numberOfItems = 0;
    if(self.dataSource)
        numberOfItems = (int)[self.dataSource gallery:self numberOfItemsInSection:(uint)section];
    numberOfItems = numberOfItems >= 0 ? numberOfItems : 0;
    
    return numberOfItems;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView
                    cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = self->_flowLayout ? self->_flowLayout.itemSize : CGSizeMake(5.f, 5.f);
    
    if(indexPath.row < 0 || indexPath.section < 0)
        return  [[SYGalleryThumbCell alloc] initWithFrame:CGRectMake(0.f, 0.f, 10.f, 10.f)];

    SYGalleryThumbCell *cell = (SYGalleryThumbCell *)[self->_gridView dequeueReusableCellWithReuseIdentifier:SYGALLERY_THUMB_REUSE_IDENTIFIER forIndexPath:indexPath];
    
    if(!cell)
        cell = [[SYGalleryThumbCell alloc] initWithFrame:CGRectMake(0.f, 0.f, cellSize.width, cellSize.height)];
    
    [cell setCellSize:cellSize];
    
    UIColor *borderColor = SYGALLERY_DEFAULT_CELL_BORDER_COLOR;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:thumbBorderColorAtIndexPath:)])
        borderColor = [self.appearanceDelegate gallery:self thumbBorderColorAtIndexPath:indexPath];
    
    CGFloat borderSize = SYGALLERY_DEFAULT_CELL_BORDER_SIZE;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:thumbBorderSizeAtIndexPath:)])
        borderSize = [self.appearanceDelegate gallery:self thumbBorderSizeAtIndexPath:indexPath];
    
    UIColor *backColor = SYGALLERY_DEFAULT_CELL_BACKGROUND_COLOR;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:thumbBackgroundColorAtIndexPath:)])
        backColor = [self.appearanceDelegate gallery:self thumbBackgroundColorAtIndexPath:indexPath];
    
    [cell setBorderWidth:borderSize andColor:borderColor];
    [cell setBackgroundColor:backColor];
    
    SYGallerySourceType sourceType = [self.dataSource gallery:self
                                            sourceTypeAtIndexPath:indexPath];
    
    UIColor *textColor = nil;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:textColorAtIndexPath:andSize:)])
        textColor = [self.appearanceDelegate gallery:self
                                textColorAtIndexPath:indexPath
                                             andSize:SYGalleryItemSizeThumb];
    
    UIFont *textFont = nil;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:textFontAtIndexPath:andSize:)])
        textFont = [self.appearanceDelegate gallery:self
                                textFontAtIndexPath:indexPath
                                            andSize:SYGalleryItemSizeThumb];
    
    BOOL showActivityIndicator = YES;
    if([self.appearanceDelegate respondsToSelector:@selector(gallery:showActivityIndicatorForThumbnailAtIndexPath:)])
        showActivityIndicator = [self.appearanceDelegate gallery:self showActivityIndicatorForThumbnailAtIndexPath:indexPath];    
    
    switch (sourceType) {
        case SYGallerySourceTypeImageData:
            [cell updateCellForImage:[self.dataSource gallery:self
                                              dataAtIndexPath:indexPath
                                                      andSize:SYGalleryItemSizeThumb]
            andShowActivityIndicator:showActivityIndicator];
            break;
        case SYGallerySourceTypeImageDistant:
            [cell updateCellForUrl:[self.dataSource gallery:self
                                             urlAtIndexPath:indexPath
                                                    andSize:SYGalleryItemSizeThumb]];
            break;
        case SYGallerySourceTypeImageLocal:
            [cell updateCellForAbsolutePath:[self.dataSource gallery:self
                                             absolutePathAtIndexPath:indexPath
                                                             andSize:SYGalleryItemSizeThumb]
                   andShowActivityIndicator:showActivityIndicator];
            break;
        case SYGallerySourceTypeText:
            [cell updateCellForText:[self.dataSource gallery:self
                                             textAtIndexPath:indexPath
                                                     andSize:SYGalleryItemSizeThumb]
                       andTextColor:textColor
                        andTextFont:textFont];
            break;
    }
    
    BOOL showBadge = NO;
    NSUInteger badgeValue = 0;
    if([self.dataSource respondsToSelector:@selector(gallery:shouldDisplayBadgeAtIndexPath:)])
        showBadge = [self.dataSource gallery:self shouldDisplayBadgeAtIndexPath:indexPath];
    
    if([self.dataSource respondsToSelector:@selector(gallery:badgeValueAtIndexPath:)])
        badgeValue = [self.dataSource gallery:self badgeValueAtIndexPath:indexPath];
    
    if(showBadge)
        [cell setBadgeValue:badgeValue];
    
    [cell setBadgeHidden:!showBadge];
    
    return cell;
}

-(PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView
            viewForSupplementaryElementOfKind:(NSString *)kind
                                  atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if([self.dataSource respondsToSelector:@selector(gallery:titleForSection:)])
        title = [self.dataSource gallery:self titleForSection:(uint)indexPath.section];
    else
        return nil;
    
    SYGalleryThumbHeaderView *headerView = [self->_gridView dequeueReusableSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:SYGALLERY_THUMB_HEADER_REUSE_IDENTIFIER forIndexPath:indexPath];
    
    if(!headerView)
        headerView = [[SYGalleryThumbHeaderView alloc] init];
    
    [headerView setTitle:title andTextColor:[UIColor blackColor] andTextFont:[UIFont boldSystemFontOfSize:16.f]];
    
    CGFloat spacing = self->_flowLayout.sectionInset.left;
    CGRect labelFrame = CGRectMake(spacing, 0.f,
                                   SYGALLERY_DEFAULT_HEADER_SIZE.width - 2 * spacing,
                                   SYGALLERY_DEFAULT_HEADER_SIZE.height);
    
    [headerView setLabelFrame:labelFrame];
    
    return headerView;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    int row = indexPath.row;
    int section = indexPath.section;
    if(row < 0 || section < 0)
        return;
    
    self->_lastClickedItemIndexPath = indexPath;
    
    if(self.actionDelegate &&
       [self.actionDelegate respondsToSelector:@selector(gallery:didTapOnItemAtIndexPath:)])
        
        [self.actionDelegate gallery:self didTapOnItemAtIndexPath:indexPath];
}


#pragma mark - UICollectionViewDelegateFlowLayout

@end



