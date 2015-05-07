//
//  UIScrollView+XMRefresh.m
//  XMRefreshView
//
//  Created by 谢满 on 15/5/7.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "UIScrollView+XMRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (XMRefresh)


static char XMRefreshHeaderKey;
- (XMRefreshView *)header
{
    return objc_getAssociatedObject(self, &XMRefreshHeaderKey);
}

- (void)setHeader:(XMRefreshView *)header
{
    if (header != self.header) {
        [self.header removeFromSuperview];
        
        [self willChangeValueForKey:@"header"];
        objc_setAssociatedObject(self, &XMRefreshHeaderKey,
                                 header,
                                 OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"];
        
        [self addSubview:header];
    }
}


-(XMRefreshView *)addRefreshHeaderWithRefreshingBlock:(void (^)())block{
    XMRefreshView *header = [[XMRefreshView alloc ] init];
    header.refreshingBlock = block;
    self.header = header;
    return header;
}

#pragma mark header
- (XMRefreshView *)refrehHeader
{
    if ([self.header isKindOfClass:[XMRefreshView class]]) {
        return (XMRefreshView *)self.header;
    }
    
    return nil;
}
@end
