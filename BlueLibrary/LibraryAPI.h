//
//  LibraryAPI.h
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Album;

@interface LibraryAPI: NSObject

+ (LibraryAPI*)sharedInstance;


- (NSArray *)getAlbums;
- (void)addAlbum:(Album *)album atIndex:(int)index;
- (void)deleteAlbumAtIndex:(int)index;

- (void)saveAlbums;

@end
