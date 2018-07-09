//
//  RMExceptionBox.m
//  RMCatchException
//
//  Created by 张斌斌 on 2018/7/5.
//  Copyright © 2018 张斌. All rights reserved.
//

#import "RMExceptionBox.h"

@implementation RMExceptionBox


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.reason forKey:@"reason"];
    [aCoder encodeObject:self.time forKey:@"time"];
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.reason = [aDecoder decodeObjectForKey:@"reason"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
    }
    return self;
}

@end
