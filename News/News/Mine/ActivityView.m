//
//  ActivityView.m
//  News
//
//  Created by lanou3g on 15/7/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ActivityView.h"

@interface ActivityView()

@property (nonatomic , retain) UIActivityIndicatorView *activityView;
@property (nonatomic , retain) UILabel *titleLabel;

@end

@implementation ActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.105 green:0.074 blue:0.040 alpha:0.6];
        self.layer.cornerRadius = 10.0;
        
    }
    return self;
}
#pragma mark --  清除缓存 提示框
- (void)layoutView
{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(30, 15, 60, 60)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [self addSubview:_activityView];
    [_activityView startAnimating];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 120, 21)];
    _titleLabel.text = @"正在为您清理";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
    [_titleLabel release];
    [_activityView release];

    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(hideView) userInfo:nil repeats:NO];
}

- (void)hideView
{
    [self setHidden:YES];
}
#pragma mark -- 完成清除
- (void)endClearView
{
    [self setHidden:NO];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 56, 56)];
    _imageView.image = [UIImage imageNamed:@"success@2x"];
    
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 120, 21)];
    _titleLabel.text = @"清理完毕!";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
    
    [_titleLabel release];
    [_imageView release];
    
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideView) userInfo:nil repeats:NO];
}

#pragma mark -- 网络慢
- (void)networkSlow
{
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paodeman.png"]];
    [self addSubview:_imageView];
    _imageView.backgroundColor = [UIColor colorWithWhite:0.130 alpha:1.000];
}
    
-(void)dealloc
{
    [_imageView release];
    [_titleLabel release];
    [_activityView release];
    [super dealloc];
}

@end
