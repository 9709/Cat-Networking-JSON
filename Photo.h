//
//  Photo.h
//  Cats-Networking-JSON
//
//  Created by Matthew Chan on 2019-01-24.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithPhotoDict: (NSDictionary *)photoDict;

// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
@end

NS_ASSUME_NONNULL_END
