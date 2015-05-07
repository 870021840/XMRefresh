//
//  ViewController.m
//  XMRefreshView
//
//  Created by 谢满 on 15/5/7.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "ViewController.h"
#import "XMRefresh.h"




@interface ViewController ()

@property(nonatomic,strong) XMRefreshView *headView;


@property(nonatomic,strong) NSMutableArray *datas;
@end

@implementation ViewController

-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (int i = 0; i<20; i++) {
            [_datas addObject:[NSString stringWithFormat:@"第%d条数据",i]];
            
        }
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.headView =[self.tableView addRefreshHeaderWithRefreshingBlock:^{
       NSLog(@"刷新中");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf loadAPIData];
        });
    }];
    
}

-(void)loadAPIData{
    
    [self.datas insertObject:@"add" atIndex:0];
    [self.headView endRefreshig];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

@end
