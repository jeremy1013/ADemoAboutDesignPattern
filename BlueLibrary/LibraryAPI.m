//
//  LibraryAPI.m
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"
#import "HTTPClient.h"


@interface LibraryAPI ()
{
    PersistencyManager *persistencyManager;
    HTTPClient * httpClient;
    BOOL isOnline;
}

@end

@implementation LibraryAPI

+ (LibraryAPI*)sharedInstance
{
    // 1
    static LibraryAPI *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        persistencyManager = [[PersistencyManager alloc]init];
        httpClient = [[HTTPClient alloc]init];
        isOnline = NO;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)downImage:(NSNotification *)notification {
    UIImageView *imageView = notification.userInfo[@"imageView"];
    NSString *coverUrl = notification.userInfo[@"coverUrl"];
    
    NSLog(@"%@", imageView.image);
    
    imageView.image = [persistencyManager getImage:[coverUrl lastPathComponent]];
    
    NSLog(@"%@", imageView.image);
    
    if (imageView.image == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:coverUrl];
            dispatch_sync(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [persistencyManager saveImage:image filename:[coverUrl lastPathComponent]];
            });
        });
    }
}


- (NSArray *)getAlbums {
   return [persistencyManager getAlbums];
}
- (void)addAlbum:(Album *)album atIndex:(int)index {
    [persistencyManager addAlbums:album atIndex:index];
    
    if (isOnline) {
        [httpClient postRequest:@"/api/addAlbum" body:[album description]];
    }
    
    
}
- (void)deleteAlbumAtIndex:(int)index {
    [persistencyManager deleteAlbumAtIndex:index];
    if (isOnline) {
        [httpClient postRequest:@"/api/deleteAlbum" body:[@(index) description]];
    }
}

- (void)saveAlbums {
    [persistencyManager saveAlbums];
}


@end
