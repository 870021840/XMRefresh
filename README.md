# XMRefresh
Custom refreshView . It is very easy use
  自定义刷新控件－带动画
========================

### 3行代码添加动画刷新控件
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        //在这里做网络请求
    }];
    [self.headView endRefreshig];
