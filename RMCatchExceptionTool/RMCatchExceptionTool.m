//
//  RMCatchExceptionTool.m
//  RMCatchException
//
//  Created by 张斌斌 on 2018/7/5.
//  Copyright © 2018 张斌. All rights reserved.
//

#import "RMCatchExceptionTool.h"
#import "RMExceptionBox.h"

@implementation RMCatchExceptionTool{
    NSString *_filePath;
}


+ (instancetype)shareInstance{
    static RMCatchExceptionTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RMCatchExceptionTool alloc]init];
    });
    return instance;
}


-(void)installUncaughtExceptionHandler{
    _filePath = getFilePath();
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}


- (NSArray*)readExceptionInfoFromLocal{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
}


- (void)clearAllLog{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *filePath = _filePath;
    BOOL isExist = [manger fileExistsAtPath:filePath];
    if (isExist) {
        NSError __autoreleasing * error;
        [manger removeItemAtPath:filePath error:&error];
    }
}


- (void)removeExceptionItemIndex:(NSUInteger)index{
    NSMutableArray *dataArry = [self readExceptionInfoFromLocal].mutableCopy;
    [dataArry removeObjectAtIndex:index];
    [NSKeyedArchiver archiveRootObject:dataArry toFile:_filePath];
}


//MARK:PRIVATE METHOD
NSDate * worldDateToLocalDate(NSDate *date){
    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset          = [localTimeZone secondsFromGMTForDate:date];
    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate         = [date dateByAddingTimeInterval:offset];
    return localDate;
}


#pragma mark - 获取crash文件名
NSString* getCurrentTime(){
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat       = @"yyyy-MM-dd:HH:mm:ss";
    fmt.timeZone         = [NSTimeZone timeZoneForSecondsFromGMT:8];
    NSDate *date         = [NSDate date];
    date                 = worldDateToLocalDate(date);
    NSString *dateString = [fmt stringFromDate:date];
    return dateString;
}


NSString* getFilePath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"exception.plist"];
    return filePath;
}


void writeInfoToLocal(NSString *name,NSString *reason,NSString *time){
    RMExceptionBox *exceptionBox = [RMExceptionBox new];
    exceptionBox.name            = name;
    exceptionBox.reason          = reason;
    exceptionBox.time            = time;
    NSString *filePath           = getFilePath();
    NSFileManager *fileM         = [NSFileManager defaultManager];
    
    if (![fileM fileExistsAtPath:filePath]) {
        [fileM createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSMutableArray * chatLogArray =  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if ((chatLogArray.count == 0)) {
        chatLogArray = [NSMutableArray arrayWithCapacity:1];
    }
    [chatLogArray insertObject:exceptionBox atIndex:0];
    [NSKeyedArchiver archiveRootObject:chatLogArray toFile:filePath];
}


void UncaughtExceptionHandler(NSException *exception){
    NSString *reason     = [exception reason];
    NSString *name       = [exception name];
    NSString *timeString = getCurrentTime();
    writeInfoToLocal(name,reason,timeString);
}

@end
