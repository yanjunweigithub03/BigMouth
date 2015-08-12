//
//  shareView.m
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "shareView.h"
static shareView *LineView = nil;
@implementation shareView


+ (instancetype)ShareLineView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LineView = [[shareView alloc] init];
    });
    
    return LineView;
}

- (void)setupLineViewY:(CGFloat)Y
{
    CGFloat x = 8;
    CGFloat y = Y;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 2;
    LineView.frame = CGRectMake(x, y, w, h);
    LineView.backgroundColor = [UIColor cyanColor];
}


@end
