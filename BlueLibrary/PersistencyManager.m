//
//  PersistencyManager.m
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "PersistencyManager.h"

@interface PersistencyManager ()
{
    NSMutableArray *albums;
}

@end


@implementation PersistencyManager

-(id)init {
    if (self = [super init]) {
        /*
        albums = [NSMutableArray arrayWithArray:@[[[Album alloc] initWithTitle:@"Best of Bowie" artist:@"David Bowie" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png" year:@"1992"],
                                                  [[Album alloc] initWithTitle:@"It's My Life" artist:@"No Doubt" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png" year:@"2003"],
                                                  [[Album alloc] initWithTitle:@"Nothing Like The Sun" artist:@"Sting" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png" year:@"1999"],
                                                  [[Album alloc] initWithTitle:@"Staring at the Sun" artist:@"U2" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png" year:@"2000"],
                                                  [[Album alloc] initWithTitle:@"American Pie" artist:@"Madonna" coverUrl:@"http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png" year:@"2000"]]];
         */
        /*
        albums = [NSMutableArray arrayWithArray:@[[[Album alloc] initWithTitle:@"Best of Bowie" artist:@"David Bowie" coverUrl:@"http://s9.knowsky.com/bizhi/l/1-5000/200952813914808809875.jpg" year:@"1992"],
                                                  [[Album alloc] initWithTitle:@"It's My Life" artist:@"No Doubt" coverUrl:@"http://pic69.nipic.com/file/20150614/20677594_124458962000_2.jpg" year:@"2003"],
                                                  [[Album alloc] initWithTitle:@"Nothing Like The Sun" artist:@"Sting" coverUrl:@"http://pic35.nipic.com/20131121/2531170_145358633000_2.jpg" year:@"1999"],
                                                  [[Album alloc] initWithTitle:@"Staring at the Sun" artist:@"U2" coverUrl:@"http://4493bz.1985t.com/uploads/allimg/150127/4-15012G52133.jpg" year:@"2000"],
                                                  [[Album alloc] initWithTitle:@"American Pie" artist:@"Madonna" coverUrl:@"http://hiphotos.baidu.com/%C4%E3%D1%BD%CC%F0%C3%DB%C3%DB/pic/item/94441cd74219943c3af3cf8f.jpg" year:@"2000"]]];*/
        
        NSData * data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"]];
        albums = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (albums == nil) {
            albums = [NSMutableArray arrayWithArray:@[[[Album alloc] initWithTitle:@"Best of Bowie" artist:@"David Bowie" coverUrl:@"http://s9.knowsky.com/bizhi/l/1-5000/200952813914808809875.jpg" year:@"1992"],
                                                      [[Album alloc] initWithTitle:@"It's My Life" artist:@"No Doubt" coverUrl:@"http://pic69.nipic.com/file/20150614/20677594_124458962000_2.jpg" year:@"2003"],
                                                      [[Album alloc] initWithTitle:@"Nothing Like The Sun" artist:@"Sting" coverUrl:@"http://pic35.nipic.com/20131121/2531170_145358633000_2.jpg" year:@"1999"],
                                                      [[Album alloc] initWithTitle:@"Staring at the Sun" artist:@"U2" coverUrl:@"http://4493bz.1985t.com/uploads/allimg/150127/4-15012G52133.jpg" year:@"2000"],
                                                      [[Album alloc] initWithTitle:@"American Pie" artist:@"Madonna" coverUrl:@"http://hiphotos.baidu.com/%C4%E3%D1%BD%CC%F0%C3%DB%C3%DB/pic/item/94441cd74219943c3af3cf8f.jpg" year:@"2000"]]];
            [self saveAlbums];
        }
        
    
    }
    
    return self;
    

    
}

- (NSArray *)getAlbums {
    return albums;
}

- (void)addAlbums:(Album *)album atIndex:(int)index {
    if (albums.count >= index) {
        [albums insertObject:album atIndex:index];
    }else {
        [albums addObject:album];
    }
}
- (void)deleteAlbumAtIndex:(int)index {
    [albums removeObjectAtIndex:index];
}

- (void)saveImage:(UIImage *)image filename:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}
- (UIImage *)getImage:(NSString *)filename {
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
    
}


- (void)saveAlbums {
    NSString *filename = [NSHomeDirectory() stringByAppendingString:@"/Documents/albums.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:albums];
    [data writeToFile:filename atomically:YES];
    
    NSLog(@"%@", filename);
}



@end
