//
//  RootViewController.m
//  News
//
//  Created by lanou3g on 15/6/30.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "RootViewController.h"
#import "FashionTableViewController.h"

#import "ButtonView.h"
#import "WeatherViewController.h"

#define VWIDTH [UIScreen mainScreen].bounds.size.width
#define VHEIGHT [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()<UIScrollViewDelegate>
@property (nonatomic, retain) NSArray *viewArray;
@property (nonatomic, retain) NSArray *Array;

@property (nonatomic, retain) UIButton *weatherButton;
@property (nonatomic, retain) ButtonView *buttonV;
@property (nonatomic, retain) UIImageView *imageViewW;
@property (nonatomic, retain) UILabel *labelT;
@property (nonatomic, retain) UILabel *labelC;
@property (nonatomic, copy) NSString *str3;
@end

@implementation RootViewController
#pragma mark -- 懒加载
- (NSArray *)viewArray
{
    if (!_viewArray) {
        _viewArray = [[NSMutableArray alloc] init];
        self.viewArray = @[@"娱乐",@"时尚",@"体育",@"财经",@"科技",@"军事"];
    }
    return _viewArray;
}

- (NSArray *)Array
{
    if (!_Array) {
        _Array = [[NSArray alloc] init];
        self.Array = @[@"T1348648517839",@"T1348650593803",@"T1348649079062",@"T1348648756099",@"T1348649580692",@"T1348648141035"];
    }
    return _Array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadHeaderView];
    
    [self setupView];
    
    [self setSubviews];
}

//布局获取天气
-(void)setSubviews
{
    _buttonV = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.buttonV.target = self;
    self.buttonV.action = @selector(weatherButtonClickedAction:);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonV];
    
    _imageViewW = [[UIImageView alloc] initWithFrame:CGRectMake(48, 18, 20, 20)];
    [self.buttonV addSubview:self.imageViewW];
    
    _labelT = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 60, 20)];
    self.labelT.font = [UIFont boldSystemFontOfSize:12.0f];
    self.labelT.text = @"获取天气";
    self.labelT.textColor = [UIColor colorWithRed:1.000 green:0.650 blue:0.030 alpha:1.000];
    self.labelT.textAlignment = NSTextAlignmentLeft;
    [self.buttonV addSubview:self.labelT];
    
    _labelC = [[UILabel alloc] initWithFrame:CGRectMake(3, 20, 40, 15)];
    self.labelC.font = [UIFont boldSystemFontOfSize:13.0f];
    self.labelC.textAlignment = NSTextAlignmentCenter;
    self.labelC.textColor = [UIColor colorWithRed:1.000 green:0.650 blue:0.030 alpha:1.000];
    [self.buttonV addSubview:self.labelC];
    
    [_labelC release];
    [_labelT release];
    [_imageViewW release];
    [_buttonV release];
    
}

-(void)weatherButtonClickedAction:(UIBarButtonItem *)sender
{
    WeatherViewController *weatherVC = [[WeatherViewController alloc] init];
    
    weatherVC.block = ^(NSDictionary *dic){
        NSString *str = [dic objectForKey:@"city"];
        NSString *str1 = [dic objectForKey:@"temp1"];
        NSString *str2 = [dic objectForKey:@"temp2"];
        
        int q1 = [str1 intValue];
        int q2 = q1 + 11;
        int q3 = [str2 intValue];
        int q4 = q3 + 7;
        NSString *str6 = [NSString stringWithFormat:@"%d",q2];
        NSString *str8 = [str6 stringByAppendingString:@"℃"];
        
        NSString *str7 = [NSString stringWithFormat:@"%d",q4];
        NSString *str9 = [str7 stringByAppendingString:@"℃"];
        
        NSString *strTaL = [NSString stringWithFormat:@"%@/%@",str9, str8];
        self.str3 = [dic objectForKey:@"weather"];
        self.labelT.text = strTaL;
        self.labelC.text = str;
        
        if ([self.str3 isEqualToString:@"晴"]) {
            self.imageViewW.image = [UIImage imageNamed:@"qing2.png"];
        } else {
            self.imageViewW.image = [UIImage imageNamed:@"yin2.png"];
        }
        
    };
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weatherVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [weatherVC release];
    
}

// 滚动视图
- (void)setupView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)- 94)];
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.Array.count, CGRectGetHeight(self.view.bounds)- 143);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.directionalLockEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < self.Array.count; i ++) {
        
        FashionTableViewController *fashion = [[FashionTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
        
        fashion.str = self.Array[i];
        fashion.tableView.frame = CGRectMake(0 + VWIDTH * i, 0, VWIDTH, VHEIGHT - 143);
        fashion.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self addChildViewController:fashion];
        [_scrollView addSubview:fashion.tableView];
        
        [fashion release];
    }
    [_scrollView release];

}

// 加载标签控制视图
- (void)loadHeaderView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , VWIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.contentSize = CGSizeMake(VWIDTH + 180, 30);
    view.tag = 400;
    view.scrollEnabled = YES;
    view.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:view];
    
    for (int i = 0; i < self.Array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15 + i * ((VWIDTH + 180) / self.Array.count), 2, VWIDTH / self.Array.count, 26);
        btn.tag = 800 + i;
        [btn setTitle:self.viewArray[i] forState:(UIControlStateNormal)];
        
        if (i == 0) {
            btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
            [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        } else {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        }
        
        [btn addTarget:self action:@selector(selectTableView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 28, (VWIDTH - 4) / self.Array.count, 2)];
    lineView.backgroundColor = [UIColor redColor];
    lineView.tag = 300;
    [view addSubview:lineView];
    
    [lineView release];
    [view release];
}
//选择标签
- (void)selectTableView:(UIButton *)btn
{
    UIView *view = [self.view viewWithTag:300];
    _scrollView.contentOffset = CGPointMake(VWIDTH * (btn.tag - 800), 0) ;
    view.frame = CGRectMake(15 + ((VWIDTH + 180) - 0) / self.Array.count * (_scrollView.contentOffset.x / VWIDTH), 28, (VWIDTH - 4) / self.Array.count, 2);
    for (int i = 0; i < self.Array.count; i ++) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:800+i];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
   
    
}
#pragma mark -- UIScrollViewDelegate实现方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *view = [self.view viewWithTag:300];
    view.frame = CGRectMake(15 + (VWIDTH + 180) / self.Array.count * (_scrollView.contentOffset.x / VWIDTH), 28, VWIDTH / self.Array.count, 2);
    
    UIScrollView *labelView = (UIScrollView *)[self.view viewWithTag:400];
    if (view.frame.origin.x <= 15 + ((VWIDTH + 180) - 0) / self.Array.count * 2) {
        labelView.contentOffset = CGPointMake(view.frame.origin.x - 14, 0);
    } else {
        labelView.contentOffset = CGPointMake(15 + ((VWIDTH + 180) - 0) / self.Array.count * 2, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:800 + (int)_scrollView.contentOffset.x / VWIDTH];
    [self selectTableView:btn];
}

- (void)dealloc
{
    [_weatherButton release];
    [_buttonV release];
    [_imageViewW release];
    [_labelC release];
    [_labelT release];
    [_str3 release];
    [_viewArray release];
    [_Array release];
    [_scrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
