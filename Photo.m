//
//  Photo.m
//  Cats-Networking-JSON
//
//  Created by Matthew Chan on 2019-01-24.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

#import "Photo.h"

@implementation Photo
- (instancetype)initWithPhotoDict: (NSDictionary *)photoDict
{
    self = [super init];
    if (self) {
        NSNumber *farmId = photoDict[@"farm"];
        NSNumber *serverId = photoDict[@"server"];
        NSNumber *photoId = photoDict[@"id"];
        NSString *secret = photoDict[@"secret"];
        _title = photoDict [@"title"];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmId, serverId, photoId, secret];
        _url = [NSURL URLWithString:urlStr];
    }
    return self;
}



@end
