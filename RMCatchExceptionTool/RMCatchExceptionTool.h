//
//  RMCatchExceptionTool.h
//  RMCatchException
//
//  Created by 张斌斌 on 2018/7/5.
//  Copyright © 2018 张斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCatchExceptionTool : NSObject

+ (instancetype)shareInstance;
//读取plist数据
- (NSArray*)readExceptionInfoFromLocal;
//初始化工具
- (void)installUncaughtExceptionHandler;
//清楚所有
- (void)clearAllLog;
//移除指定数据
- (void)removeExceptionItemIndex:(NSUInteger)index;
@end
