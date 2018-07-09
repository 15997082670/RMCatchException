//
//  RMExceptionBox.h
//  RMCatchException
//
//  Created by 张斌斌 on 2018/7/5.
//  Copyright © 2018 张斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMExceptionBox : NSObject<NSCopying>
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *reason;
@property(copy,nonatomic)NSString *time;

@end
