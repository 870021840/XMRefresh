//
//  UIScrollView+XMRefresh.h
//  XMRefreshView
//
//  Created by 谢满 on 15/5/7.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMRefreshView.h"


@interface UIScrollView (XMRefresh)

/** 下拉刷新控件 */
@property (nonatomic, readonly) XMRefreshView *refrehHeader;


#pragma mark - 添加下拉刷新控件
/**
 * 添加一个下拉刷新控件
 *
 * @param block 进入刷新状态就会自动调用
 */
- (XMRefreshView *)addRefreshHeaderWithRefreshingBlock:(void (^)())block;

@end
