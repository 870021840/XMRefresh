# XMRefresh
Custom refreshView . It is very easy to use
  自定义刷新控件－带动画
========================
  截图：
 ![image](https://github.com/870021840/XMRefresh/blob/master/refresh.gif)

### 3行代码添加动画刷新控件
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        //在这里做网络请求
    }];
    [self.headView endRefreshig];

感谢MJ老师提供思路，raywenderlich动画教程
