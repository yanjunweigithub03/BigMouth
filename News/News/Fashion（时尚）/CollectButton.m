//
//  CollectButton.m
//  News
//
//  Created by lanou3g on 15/7/7.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "CollectButton.h"

@implementation CollectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupButton:(CGRect)frame isCollect:(BOOL)isCollect
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    if (isCollect) {
        [btn setImage:[UIImage imageNamed:@"iconfont-shoucang1.png"] forState:(UIControlStateNormal)];
    } else {
    [btn setImage:[UIImage imageNamed:@"iconfont-shoucang.png"] forState:(UIControlStateNormal)];
    }
    [btn addTarget:self action:@selector(collectButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
}

- (void)collectButton:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectButtonAction:)]) {
        [self.delegate collectButtonAction:btn];
    }
}

@end
