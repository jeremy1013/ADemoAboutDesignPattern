//
//  Album+TableRepresentation.h
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)


- (NSDictionary *)tr_tableRepresentation;

@end
