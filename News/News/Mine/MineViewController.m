//
//  MineViewController.m
//  News
//
//  Created by lanou3g on 15/6/30.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MineViewController.h"
#import "CollectTableViewController.h"
#import "AppDelegate.h"

#import "CacheModel.h"
#import "SDImageCache.h"
#import "ActivityView.h"

#define VWIDTH [UIScreen mainScreen].bounds.size.width
#define VHEIGHT [UIScreen mainScreen].bounds.size.height

#define scaleSize [UIScreen mainScreen].bounds.size.width / 320

@interface MineViewController ()<UITableViewDataSource , UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic , retain) UIImageView *imageView; //头视图
@property (nonatomic , retain) UILabel *cache; //缓存大小

@property (nonatomic , retain) CacheModel *model; //KVO
@property (nonatomic , retain) UILabel *version; //版本号
@end

@implementation MineViewController

- (CacheModel *)model
{
    if (!_model) {
        _model = [[CacheModel alloc] init];
    }
    return _model;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    [self.model addObserver:self forKeyPath:@"cache"
                    options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                    context:nil];
    self.model.cache = [NSString stringWithFormat:@"%.2fM",[SDImageCache folderSizeAtPath:library]];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[self addNotificationCenter];
    
    [self setupView];
    
}
#pragma mark -- 布局视图
- (void)setupView
{
    UIImage *image = [UIImage imageNamed:@"fly.jpeg"];
    CGFloat scale = image.size.width / image.size.height;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VWIDTH, VWIDTH / scale)];
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VWIDTH / scale, VWIDTH, VHEIGHT - 113 - VWIDTH / scale)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = (VHEIGHT - 113 - VWIDTH / scale) / 5;
    //self.tableView.tableHeaderView = self.imageView;
    
    [_tableView release];
    [_imageView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
#pragma mark -- cell重用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *NameArray = @[@"收藏",@"清除缓存",@"护眼模式",@"免责声明",@"版本号"];
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        if (indexPath.row == 4) {
            _version = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 65, self.tableView.rowHeight / 2 - 13 , 55, 25)];
            _version.text = @"V1.0.1";
            _version.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:_version];
            [_version release];
        } else if (indexPath.row == 1) {
            _cache = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 70, self.tableView.rowHeight / 2 - 13 , 60, 25)];
            _cache.text = _model.cache;
            _cache.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:_cache];
            [_cache release];
        } else if (indexPath.row == 2) {
            UISwitch *swith = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 70, self.tableView.rowHeight / 2 - 13 , 60, 25)];
            [swith addTarget:self action:@selector(nightStyle:) forControlEvents:(UIControlEventValueChanged)];
            [cell addSubview:swith];
            [swith release];
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    //cell.backgroundColor = [UIColor colorWithWhite:0.124 alpha:1.000];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = NameArray[indexPath.row];
    return cell;
}

#pragma mark -- 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row ) {
        CollectTableViewController *coll = [[CollectTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
        coll.navigationItem.title = @"收藏列表";
        
        [coll setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:coll animated:YES];
        [coll release];
    } else if (1 == indexPath.row) {
        
        [self setupAlertView];
        
    } else if (3 == indexPath.row){
        [self setupDisclaimerView];
    
    }
    
}
#pragma mark -- 声明提示框
- (void)setupDisclaimerView
{
    UIAlertView *disclaimer = [[UIAlertView alloc] initWithTitle:@"声明"
                                                         message:@"     本app所有内容,包括文字、图⽚、⾳频、视频、软件、程序、以及版式设计等均在⺴上搜集。访问者可将本app提供的内容或服务用于个⼈人学习、研究或欣赏,以及其他⾮非商业性或 ⾮非盈利性⽤用途,但同时应遵守著作权法及其他相关法律的规定,不得侵犯本app及相关权利⼈人的合法权利。除此以外,将本app任何内容或服务⽤用于其他⽤用途时,须征得本app及相关权利人的书面许可,并支付报酬。本app内容原作者如不愿意在本app刊登内容,请及时通知本app,予以删除。"
                                                        delegate:nil
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    [disclaimer show];
}

#pragma mark -- 提示框
- (void)setupAlertView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                             message:@"是否确定清除缓存 ?"
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:(UIAlertActionStyleCancel)
                                                   handler:^(UIAlertAction *action) {
                                                   }];
    
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定"
                                                     style:(UIAlertActionStyleDefault)
                                                   handler:^(UIAlertAction *action){
                                                   [self clearCache];
                                                   }];
    [alertController addAction:cancel];
    [alertController addAction:ensure];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark --  清除缓存
- (void)clearCache
{
    ActivityView *view = [[ActivityView alloc] initWithFrame:CGRectMake(VWIDTH / 2 - 60, VHEIGHT / 2 - 120, 120, 120)];
    [view layoutView];
    [self.view addSubview:view];
    [view release];
   
    [self clear];

}

#pragma mark -- 彻底清除缓存 （SDWebImage --  UIWebView）
- (void)clear
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       //NSLog(@"%@", cachPath);
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       //NSLog(@"files :%lu",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];}
                   );

}

#pragma mark -- 清除成功 提示框
-(void)clearCacheSuccess
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ActivityView *aView = [[ActivityView alloc] initWithFrame:CGRectMake(VWIDTH / 2 - 60, VHEIGHT / 2 - 120, 120, 120)];
        [aView endClearView];
        [self.view addSubview:aView];
        [aView release];
        
        _model.cache = @"0.00M";
    });
}

#pragma mark -- KVO 观察者方法 --缓存大小
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cache"]) {
        _cache.text = _model.cache;
    }
}

#pragma mark -- 下拉放大
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
//        _imageView.frame = CGRectMake(0, 0, VWIDTH, VWIDTH / scaleSize);
        scrollView.contentOffset = CGPointMake(0, 0);
    } else {
        _imageView.frame =  CGRectMake((-(-(scrollView.contentOffset.y) * VWIDTH / 180) / 2 ) * scaleSize, 0, (VWIDTH - (scrollView.contentOffset.y) * VWIDTH / 180) * scaleSize, (180 - (scrollView.contentOffset.y)) * scaleSize);
    }

}

#pragma mark -- 护眼模式
- (void)nightStyle:(UISwitch *)sender
{
    //NSLog(@"%@",sender.on?@"YES":@"NO");
    NSDictionary *dic = [NSDictionary dictionary];
    if (sender.on) {
        [AppDelegate shareAppDelegate].redView.alpha = 0.3;
        dic = @{@"NightColor":[UIColor colorWithWhite:0.124 alpha:1.000],@"DayColor":[UIColor whiteColor]};
    }else{
        [AppDelegate shareAppDelegate].redView.alpha = 0.0;
        dic = @{@"DayColor":[UIColor colorWithWhite:0.124 alpha:1.000],@"NightColor":[UIColor whiteColor]};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DayOrNight" object:self userInfo:dic];
}

#pragma mark -- 通知中心
- (void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNightStyle:) name:@"DayOrNight" object:nil];
}

- (void)changeNightStyle:(NSNotification *)notification
{
    NSArray *cellArr = self.tableView.visibleCells;
    for (UITableViewCell *cell in cellArr) {
        self.tableView.backgroundColor = [notification.userInfo valueForKey:@"NightColor"];
        cell.backgroundColor = [notification.userInfo valueForKey:@"NightColor"];
        cell.textLabel.textColor = [notification.userInfo valueForKey:@"DayColor"];
        _version.textColor = [notification.userInfo valueForKey:@"DayColor"];
        _cache.textColor = [notification.userInfo valueForKey:@"DayColor"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [_model removeObserver:self forKeyPath:@"cache"];
    [_cache release];
    [_model release];
    [_imageView release];
    [_tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
