//
//  SYDataSource.m
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYDataSource.h"

@implementation SYDataSource

@synthesize sourceType = _sourceType;

#pragma mark - Initialization

+(SYDataSource*)sharedDataSource {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if(!self)
        return nil;
    
    self->_sourceType = SYGallerySourceTypeImageLocal;
    self->_localPathsThumbs = [NSMutableArray arrayWithObjects:
                               @"1_s",
                               @"2_s",
                               @"3_s",
                               @"4_s",
                               @"5_s",
                               @"6_s",
                               nil];
    
    self->_localPathsFulls = [NSMutableArray arrayWithObjects:
                              @"1",
                              @"2",
                              @"3",
                              @"4",
                              @"5",
                              @"6",
                              nil];
    
    self->_distantPathsThumbs = [NSMutableArray arrayWithObjects:
                                 @"http://farm8.staticflickr.com/7035/6772235451_6ebca876b9_s.jpg",
                                 @"http://farm8.staticflickr.com/7003/6772237041_23d0e89284_s.jpg",
                                 @"http://farm8.staticflickr.com/7170/6772238039_e75820a2de_s.jpg",
                                 @"http://farm8.staticflickr.com/7003/6772239185_5862f29b50_s.jpg",
                                 @"http://farm8.staticflickr.com/7147/6772240411_4bcd40e9ca_s.jpg",
                                 @"http://farm8.staticflickr.com/7033/6772241725_1ef1296a06_s.jpg",
                                 @"http://farm8.staticflickr.com/7151/6772243099_8648e2f452_s.jpg",
                                 @"http://farm8.staticflickr.com/7022/6772244303_e1c9c05058_s.jpg",
                                 @"http://farm8.staticflickr.com/7174/6772245689_1c5ae1822d_s.jpg",
                                 
                                 @"http://farm8.staticflickr.com/7026/6772247177_eccaec2996_s.jpg",
                                 @"http://farm8.staticflickr.com/7029/6772248589_d04668283d_s.jpg",
                                 @"http://farm8.staticflickr.com/7175/6772249739_4de39786c7_s.jpg",
                                 @"http://farm8.staticflickr.com/7147/6772251009_777317e594_s.jpg",
                                 @"http://farm8.staticflickr.com/7034/6772252053_3efcc8f1a8_s.jpg",
                                 @"http://farm8.staticflickr.com/7144/6772253275_86c835a077_s.jpg",
                                 @"http://farm8.staticflickr.com/7164/6807594349_412b21e344_s.jpg",
                                 @"http://farm8.staticflickr.com/7034/6772256117_bd257a76fe_s.jpg",
                                 @"http://farm8.staticflickr.com/7023/6772257455_5a9656102f_s.jpg",
                                 
                                 @"http://farm8.staticflickr.com/7156/6772258387_e1aa8b5670_s.jpg",
                                 @"http://farm8.staticflickr.com/7028/6772259495_f84e1b8570_s.jpg",
                                 
                                 @"http://farm7.staticflickr.com/6233/6324518502_1c3136ff40_s.jpg",
                                 @"http://farm7.staticflickr.com/6059/6323762655_4007ce8520_s.jpg",
                                 @"http://farm7.staticflickr.com/6236/6324517764_de1df32ebe_s.jpg",
                                 @"http://farm7.staticflickr.com/6192/6132622831_cd6cc1caca_s.jpg",
                                 @"http://farm7.staticflickr.com/6173/6132675139_dd4d8f6cf5_s.jpg",
                                 @"http://farm7.staticflickr.com/6073/6133223046_9b534aa334_s.jpg",
                                 @"http://farm7.staticflickr.com/6074/6132821783_febf9e9904_s.jpg",
                                 @"http://farm7.staticflickr.com/6079/6133378862_e482333e7f_s.jpg",
                                 @"http://farm7.staticflickr.com/6215/6363743545_2fa45c5f7c_s.jpg",
                                 
                                 @"http://farm7.staticflickr.com/6109/6363745095_f379391121_s.jpg",
                                 @"http://farm7.staticflickr.com/6117/6363746609_6b912b1f3f_s.jpg",
                                 @"http://farm7.staticflickr.com/6098/6363747947_0745476dc9_s.jpg",
                                 @"http://farm8.staticflickr.com/7163/6407056643_2155c2e141_s.jpg",
                                 @"http://farm8.staticflickr.com/7165/6407059881_1dc7940411_s.jpg",
                                 @"http://farm8.staticflickr.com/7142/6408034643_2f2913b8fb_s.jpg",
                                 @"http://farm8.staticflickr.com/7035/6408036239_bc80730a6f_s.jpg",
                                 @"http://farm8.staticflickr.com/7160/6408037557_cf05fdb2e6_s.jpg",
                                 @"http://farm8.staticflickr.com/7025/6408039143_ab93bbbcd4_s.jpg",
                                 
                                 @"http://farm8.staticflickr.com/7013/6408040221_5ef3291562_s.jpg",
                                 @"http://farm8.staticflickr.com/7020/6408041639_763c09cd16_s.jpg",
                                 @"http://farm8.staticflickr.com/7028/6408043061_e7493dcf30_s.jpg",
                                 @"http://farm8.staticflickr.com/7168/6408044361_fc0fbd5ecd_s.jpg",
                                 @"http://farm7.staticflickr.com/6226/6408045667_1f447b1367_s.jpg",
                                 nil];
    
    self->_distantPathsFulls = [NSMutableArray arrayWithObjects:
                                @"http://farm8.staticflickr.com/7035/6772235451_6ebca876b9_b.jpg",
                                @"http://farm8.staticflickr.com/7003/6772237041_23d0e89284_b.jpg",
                                @"http://farm8.staticflickr.com/7170/6772238039_e75820a2de_b.jpg",
                                @"http://farm8.staticflickr.com/7003/6772239185_5862f29b50_b.jpg",
                                @"http://farm8.staticflickr.com/7147/6772240411_4bcd40e9ca_b.jpg",
                                @"http://farm8.staticflickr.com/7033/6772241725_1ef1296a06_b.jpg",
                                @"http://farm8.staticflickr.com/7151/6772243099_8648e2f452_b.jpg",
                                @"http://farm8.staticflickr.com/7022/6772244303_e1c9c05058_b.jpg",
                                @"http://farm8.staticflickr.com/7174/6772245689_1c5ae1822d_b.jpg",
                                
                                @"http://farm8.staticflickr.com/7026/6772247177_eccaec2996_b.jpg",
                                @"http://farm8.staticflickr.com/7029/6772248589_d04668283d_b.jpg",
                                @"http://farm8.staticflickr.com/7175/6772249739_4de39786c7_b.jpg",
                                @"http://farm8.staticflickr.com/7147/6772251009_777317e594_b.jpg",
                                @"http://farm8.staticflickr.com/7034/6772252053_3efcc8f1a8_b.jpg",
                                @"http://farm8.staticflickr.com/7144/6772253275_86c835a077_b.jpg",
                                @"http://farm8.staticflickr.com/7164/6807594349_412b21e344_b.jpg",
                                @"http://farm8.staticflickr.com/7034/6772256117_bd257a76fe_b.jpg",
                                @"http://farm8.staticflickr.com/7023/6772257455_5a9656102f_b.jpg",
                                
                                @"http://farm8.staticflickr.com/7156/6772258387_e1aa8b5670_b.jpg",
                                @"http://farm8.staticflickr.com/7028/6772259495_f84e1b8570_b.jpg",
                                
                                @"http://farm7.staticflickr.com/6233/6324518502_1c3136ff40_b.jpg",
                                @"http://farm7.staticflickr.com/6059/6323762655_4007ce8520_b.jpg",
                                @"http://farm7.staticflickr.com/6236/6324517764_de1df32ebe_b.jpg",
                                @"http://farm7.staticflickr.com/6192/6132622831_cd6cc1caca_b.jpg",
                                @"http://farm7.staticflickr.com/6173/6132675139_dd4d8f6cf5_b.jpg",
                                @"http://farm7.staticflickr.com/6073/6133223046_9b534aa334_b.jpg",
                                @"http://farm7.staticflickr.com/6074/6132821783_febf9e9904_b.jpg",
                                @"http://farm7.staticflickr.com/6079/6133378862_e482333e7f_b.jpg",
                                @"http://farm7.staticflickr.com/6215/6363743545_2fa45c5f7c_b.jpg",
                                
                                @"http://farm7.staticflickr.com/6109/6363745095_f379391121_b.jpg",
                                @"http://farm7.staticflickr.com/6117/6363746609_6b912b1f3f_b.jpg",
                                @"http://farm7.staticflickr.com/6098/6363747947_0745476dc9_b.jpg",
                                @"http://farm8.staticflickr.com/7163/6407056643_2155c2e141_b.jpg",
                                @"http://farm8.staticflickr.com/7165/6407059881_1dc7940411_b.jpg",
                                @"http://farm8.staticflickr.com/7142/6408034643_2f2913b8fb_b.jpg",
                                @"http://farm8.staticflickr.com/7035/6408036239_bc80730a6f_b.jpg",
                                @"http://farm8.staticflickr.com/7160/6408037557_cf05fdb2e6_b.jpg",
                                @"http://farm8.staticflickr.com/7025/6408039143_ab93bbbcd4_b.jpg",
                                
                                @"http://farm8.staticflickr.com/7013/6408040221_5ef3291562_b.jpg",
                                @"http://farm8.staticflickr.com/7020/6408041639_763c09cd16_b.jpg",
                                @"http://farm8.staticflickr.com/7028/6408043061_e7493dcf30_b.jpg",
                                @"http://farm8.staticflickr.com/7168/6408044361_fc0fbd5ecd_b.jpg",
                                @"http://farm7.staticflickr.com/6226/6408045667_1f447b1367_b.jpg",
                                nil];
    
    self->_textsThumbs = [@[@"😄", @"Loreum\nimpsum ten\nparagraphs\n(very long)"] mutableCopy];
    self->_textsFulls = [@[@"Smiling emoticon 😄",
                         @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris luctus, quam at gravida tincidunt, mauris metus semper lorem, vitae blandit orci nisi quis felis. Aenean tincidunt orci ac quam viverra tincidunt pulvinar nulla vulputate. Donec dapibus, ligula at consectetur fringilla, orci elit pellentesque justo, ut consequat lacus arcu eget lorem. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce tempus eleifend imperdiet. Quisque auctor ultricies ante, vehicula scelerisque purus auctor et. Nunc vehicula malesuada luctus. Aenean molestie posuere risus a sodales.\n\n\
                         Praesent sit amet metus ut ante accumsan mollis. Integer sit amet neque libero. Quisque hendrerit aliquam ornare. Maecenas at dolor justo. Sed viverra, nibh et egestas adipiscing, magna libero pharetra ipsum, in tincidunt velit arcu ac arcu. Nullam ipsum massa, congue bibendum tempus sit amet, fringilla at erat. Ut dui sapien, sodales quis aliquam vitae, ultrices vel dui. Sed ultrices pharetra lobortis. Sed at rhoncus lorem. Maecenas eu lectus at dui facilisis luctus pharetra et risus. Sed faucibus fermentum mi, quis laoreet erat malesuada a. Aenean eu fermentum risus. Morbi varius vestibulum leo in vulputate. Nam suscipit eros porttitor turpis sollicitudin sit amet ultrices leo fermentum.\n\n\
                         Morbi consectetur ipsum ut urna hendrerit pharetra. Duis sit amet nisl leo, sit amet malesuada lorem. Aenean luctus mauris ut arcu lobortis ac viverra ante molestie. Vestibulum ullamcorper, ligula non consectetur hendrerit, turpis nunc fringilla elit, non bibendum mauris mauris a augue. Morbi tincidunt convallis nibh, a posuere neque porttitor feugiat. Integer dapibus auctor turpis, vel cursus ligula sagittis in. Quisque molestie nunc ut sem semper sagittis. Fusce non dui vitae erat vulputate iaculis. Aliquam erat dui, eleifend quis lobortis a, dignissim in enim. Sed risus mi, molestie sit amet consequat non, elementum posuere ipsum. Suspendisse pulvinar ligula vitae dui elementum quis scelerisque diam tempor. Nulla facilisi. Nulla lobortis congue enim et faucibus. In posuere varius luctus. Nam egestas ante quis tellus eleifend convallis. Nunc justo metus, tincidunt sed hendrerit sit amet, volutpat non tellus.\n\n\
                         Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Etiam in ipsum sit amet orci hendrerit aliquet eu eu nibh. Integer venenatis turpis urna. Sed sollicitudin enim eu ipsum viverra eu scelerisque nunc feugiat. Mauris risus urna, imperdiet non ultrices in, viverra vel quam. Nam a pulvinar lorem. Ut vitae rhoncus magna. Nulla pretium aliquam faucibus. Aliquam nec urna justo, in rutrum ligula. Cras imperdiet dignissim nulla sed auctor. In feugiat sagittis dolor, ac bibendum purus consectetur quis.\n\n\
                         Praesent bibendum vulputate massa, viverra consequat felis rhoncus nec. Pellentesque vehicula ullamcorper dolor, ullamcorper ullamcorper sem vulputate nec. Vestibulum est purus, pretium ut commodo et, cursus a ipsum. Fusce nec congue eros. Nunc et felis et lectus tempus lobortis. Proin ultrices sodales augue sed fringilla. Nulla ac magna in risus posuere egestas accumsan nec urna. In a laoreet est. Donec at urna at elit pharetra mattis id non lacus. Donec fermentum adipiscing mauris vel dictum.\n\n\
                         Praesent mauris leo, fringilla vitae eleifend in, vulputate nec dui. Morbi scelerisque facilisis elit, sed aliquet elit viverra ut. Aenean ac leo vel dolor sagittis egestas a in libero. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis posuere accumsan suscipit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas vel venenatis lorem. Phasellus in nisi dui.\n\n\
                         Integer volutpat tortor porttitor nibh commodo quis tempor urna lobortis. Sed nisl urna, accumsan et varius ac, mattis tempus ligula. Nam rutrum consectetur turpis quis placerat. Aenean tellus purus, convallis eu malesuada nec, commodo eu risus. Sed vestibulum, est sodales vulputate sagittis, eros mauris vulputate odio, nec ultrices justo odio non nisl. Sed scelerisque convallis augue, in vulputate orci hendrerit nec. Morbi congue, enim nec faucibus faucibus, dolor risus adipiscing augue, a condimentum est neque vel augue.\n\n\
                         Nullam id varius leo. Sed vel luctus nulla. Maecenas diam arcu, scelerisque sed cursus sed, gravida at arcu. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed id orci massa. Quisque nunc dolor, cursus et sagittis et, molestie in ligula. Pellentesque quam leo, pulvinar vel luctus quis, placerat nec lectus. Sed molestie varius mi non consectetur.\n\n\
                         Proin pellentesque varius est, a lacinia tellus ultrices pharetra. Aliquam tortor nisi, condimentum ac cursus vel, dapibus nec nisi. Donec nunc sem, fermentum a gravida at, adipiscing auctor velit. Nam varius nunc non dolor ullamcorper auctor. Duis lectus tellus, pellentesque quis consequat a, facilisis vel eros. Aenean vel purus enim. Pellentesque non velit sit amet orci condimentum dapibus. Quisque nulla est, vulputate a faucibus ut, accumsan id nisl. Nullam luctus lectus enim. Pellentesque libero erat, scelerisque in congue vel, dapibus nec dolor. Nulla tortor nisl, imperdiet id eleifend nec, mattis quis metus. Mauris gravida libero et ante molestie et accumsan felis dictum. Phasellus ut magna eget ante venenatis varius vel eget ipsum. Mauris mollis vestibulum sapien tristique convallis. Pellentesque hendrerit fermentum venenatis.\n\n\
                         Aliquam porta volutpat sagittis. Pellentesque eu nisl lectus. Pellentesque eleifend imperdiet urna at accumsan. Donec nibh enim, pharetra et bibendum a, auctor nec ipsum. Praesent mollis turpis nec lectus iaculis interdum. Etiam vestibulum mi et quam sagittis commodo. Nulla facilisi. Fusce tempor egestas nibh sit amet commodo. Aenean nec accumsan diam. Nulla facilisi."] mutableCopy];
    
    return self;
}

#pragma mark - SYGalleryDataSource

- (NSUInteger)numberOfItemsInGallery:(id<SYGalleryView>)gallery
{
    uint numberOfItems = 0;
    switch (self.sourceType) {
        case SYGallerySourceTypeImageLocal:
            numberOfItems = [self->_localPathsFulls count];
            break;
        case SYGallerySourceTypeImageDistant:
            numberOfItems = [self->_distantPathsFulls count];
            break;
        case SYGallerySourceTypeText:
            numberOfItems = [self->_textsFulls count];
            break;
    }
    
    return numberOfItems;
}

- (SYGallerySourceType)gallery:(id<SYGalleryView>)gallery sourceTypeAtIndex:(NSUInteger)index
{
    return self.sourceType;
}

- (NSString*)gallery:(id<SYGalleryView>)gallery absolutePathAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    NSString *resourceName = nil;
    if(size == SYGalleryPhotoSizeThumb)
        resourceName = [self->_localPathsThumbs objectAtIndex:index];
    else
        resourceName = [self->_localPathsFulls objectAtIndex:index];
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"jpg"];
    return resourcePath;
}

- (NSString*)gallery:(id<SYGalleryView>)gallery urlAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return [self->_distantPathsThumbs objectAtIndex:index];
    else
        return [self->_distantPathsFulls objectAtIndex:index];
}

-(NSString *)gallery:(id<SYGalleryView>)gallery textAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return [self->_textsThumbs objectAtIndex:index];
    else
        return [self->_textsFulls objectAtIndex:index];
}

-(UIColor *)gallery:(id<SYGalleryView>)gallery textColorAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return [UIColor blackColor];
    else
        return [UIColor whiteColor];
}

-(UIFont *)gallery:(id<SYGalleryView>)gallery textFontAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    if(size == SYGalleryPhotoSizeThumb)
        return nil; // will select proper font size to fit in view
    else
        return (index == 0 ? [UIFont systemFontOfSize:50.f] : [UIFont systemFontOfSize:10.f]);
}

- (BOOL)gallery:(id<SYGalleryView>)gallery canDeleteAtIndex:(NSUInteger)index
{
    // even indexes only
    return index % 2 == 0;
}

- (void)gallery:(id<SYGalleryView>)gallery deleteItemInAtIndex:(NSUInteger)index {
    
    switch ([self gallery:nil sourceTypeAtIndex:index]) {
        case SYGallerySourceTypeImageLocal:
            [self->_localPathsFulls removeObjectAtIndex:index];
            [self->_localPathsThumbs removeObjectAtIndex:index];
            break;
        case SYGallerySourceTypeImageDistant:
            [self->_distantPathsFulls removeObjectAtIndex:index];
            [self->_distantPathsThumbs removeObjectAtIndex:index];
            break;
        case SYGallerySourceTypeText:
            [self->_textsFulls removeObjectAtIndex:index];
            [self->_textsThumbs removeObjectAtIndex:index];
            break;
            
        default:
            break;
    }
}

-(BOOL)gallery:(id<SYGalleryView>)gallery shouldDisplayBadgeAtIndex:(NSUInteger)index {
    return (index % 11) != 0;
}

-(NSUInteger)gallery:(id<SYGalleryView>)gallery badgeValueAtIndex:(NSUInteger)index {
    int nb = index % 11 - 1;
    return (nb == -1 ? 0 : (uint)nb);
}

@end
