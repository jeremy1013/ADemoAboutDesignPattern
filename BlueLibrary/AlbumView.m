//
//  AlbumView.m
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
{
    UIImageView *coverImage;
    UIActivityIndicatorView *indicator;
}

- (id)initWithFrame:(CGRect)frame albumCover:(NSString*)albumCover
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // the coverImage has a 5 pixels margin from its frame
        coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        coverImage.backgroundColor = [UIColor redColor];
        [self addSubview:coverImage];
        
        NSLog(@"%@", coverImage.image);
        NSLog(@"indicator");
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        [coverImage addObserver:self forKeyPath:@"image" options:0 context:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BLDownloadImageNotification" object:self userInfo:@{@"imageView":coverImage, @"coverUrl":albumCover}];
        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [coverImage removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath");
    if ([keyPath isEqualToString:@"image"]) {
        [indicator stopAnimating];
        NSLog(@"keyPath2");
    }
}




@end
