//
//  SecondViewController.m
//  RMCatchException
//
//  Created by 张斌斌 on 2018/7/5.
//  Copyright © 2018 张斌. All rights reserved.
//

#import "SecondViewController.h"
#import "RMExceptionBox.h"
#import "RMCatchExceptionTool.h"
#import <MJRefresh.h>

static NSString * identify = @"identify";

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSMutableArray<RMExceptionBox*> *dataSource;
@property(strong,nonatomic)UITableView                     *tableview;
@property(strong,nonatomic)UILabel                         *reasonLab;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.tabBarController.delegate = self;
    [self.view addSubview:self.tableview];
    __block typeof(self)weakSelf=self;
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden = YES;
    self.tableview.mj_header=header;

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}


- (void)setNavItem{
    self.title = @"recode";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"clear" style:UIBarButtonItemStyleDone target:self action:@selector(clickRight)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)clickRight{
    _dataSource = [NSMutableArray array];
    [self.tableview reloadData];
    [[RMCatchExceptionTool shareInstance]clearAllLog];
}


- (void)loadData{
    RMCatchExceptionTool *tool = [RMCatchExceptionTool shareInstance];
    NSArray *data = [tool readExceptionInfoFromLocal];
    self.dataSource = data.mutableCopy;
    [self.tableview reloadData];
    [self.tableview.mj_header endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataSource[indexPath.row].name;
    cell.detailTextLabel.text = _dataSource[indexPath.row].time;
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.reasonLab;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从数据源中删除
    [_dataSource removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [[RMCatchExceptionTool shareInstance] removeExceptionItemIndex:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.reasonLab.text = _dataSource[indexPath.row].reason;
}


- (NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}


- (UILabel*)reasonLab{
    if (!_reasonLab) {
        _reasonLab = [UILabel new];
        _reasonLab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        _reasonLab.textColor = [UIColor whiteColor];
        _reasonLab.backgroundColor = [UIColor colorWithRed:84/255.0f green:149/255.0f blue:252/255.0f alpha:1.0];
        _reasonLab.text = @"reason board";
        _reasonLab.textAlignment = NSTextAlignmentCenter;
        _reasonLab.numberOfLines = 0;
    }
    return _reasonLab;
}

@end
