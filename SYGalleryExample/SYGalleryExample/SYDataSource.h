//
//  SYDataSource.h
//  SYGalleryExample
//
//  Created by rominet on 26/10/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYGalleryDelegates.h"

@interface SYDataSource : NSObject <SYGalleryDataSource> {
@private
    NSMutableArray *_localPathsThumbs;
    NSMutableArray *_localPathsFulls;
    
    NSMutableArray *_distantPathsThumbs;
    NSMutableArray *_distantPathsFulls;
    
    NSMutableArray *_textsFulls;
    NSMutableArray *_textsThumbs;
}

+(SYDataSource*)sharedDataSource;

@property (atomic) SYGallerySourceType sourceType;

@end
