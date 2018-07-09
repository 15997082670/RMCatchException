//
//  FirstViewController.m
//  RMCatchException
//
//  Created by 张斌斌 on 2018/7/5.
//  Copyright © 2018 张斌. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)print:(id)sender {

    
}

- (IBAction)addArryException:(id)sender {
    NSMutableArray * array = @[].mutableCopy;
    array[1] = @1;
}


- (IBAction)adddicException:(id)sender {
    NSDictionary *dic = [NSDictionary dictionary];
    [dic setValue:nil forKey:@"prama"];
}

- (IBAction)InternalInconsistencyException{
    NSDictionary *sampleDic = [NSDictionary dictionary];
    [sampleDic setValue:@"lala" forKey:@"prama"];
}

- (IBAction)mallocException{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1];
    NSInteger len = 2032935142;
    [data increaseLengthBy:len];
}


@end
