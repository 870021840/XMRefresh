//
//  XMRefreshView.h
//  XMRefreshView
//
//  Created by 谢满 on 15/5/7.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XMRefreshView : UIView

@property(nonatomic,copy) void(^refreshingBlock)();


-(void)beginRefreshing;

-(void)endRefreshig;
@end
