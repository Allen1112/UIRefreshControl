//
//  ViewController.m
//  UIRefreshControl
//
//  Created by xiaomeng on 2014/7/12.
//  Copyright © 2014年 xiaomeng. All rights reserved.
//

#import "ViewController.h"

#define RandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据源
    _dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<3; i++) {
        [self.dataArray addObject:RandomData];
    }
    
    //初始化refreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", indexPath.row % 2?@"push":@"modal", self.dataArray[indexPath.row]];
    return cell;
}

- (void)refreshData{
    // 1.添加数据
    for (int i = 0; i<5; i++) {
        [self.dataArray addObject:RandomData];
    }
    // 2.模拟2秒后刷新表格UI
    __weak __typeof(self)wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong __typeof (wself) sself = wself;
        
        //结束刷新(重要,只有先处理完了数据源,再执行方法 endRefreshing 让tableView回去)
        [sself.refreshControl endRefreshing];
        
        //重新加载
        [sself.tableView reloadData];
    });
}

@end
