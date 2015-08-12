//
//  VideoTVC.m
//  News
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//  http://c.m.163.com/nc/video/list/V9LG4B3A0/n/0-10.html

#import "VideoTVC.h"

#import "Network.h"
#import "ModelForVideo.h"
#import "VideoTableViewCell.h"

#import "FMDatabase.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"

#import <MediaPlayer/MediaPlayer.h>

@interface VideoTVC ()

@property (nonatomic , retain) MPMoviePlayerViewController *moviePlayerViewController;

@property (nonatomic , retain) NSMutableArray *dataArray;

@property (nonatomic , retain) NSMutableArray *flaseArray; //伪数据源

@property (nonatomic , copy) NSString *string; // URL

@property (nonatomic , copy) NSString *mp4_URL;//视频播放 URL

@property (nonatomic , retain) FMDatabase *dataBase; //数据库

@end

static NSInteger num = 0;
@implementation VideoTVC

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)flaseArray
{
    if (!_flaseArray) {
        _flaseArray = [[NSMutableArray alloc] init];
    }
    return _flaseArray;
}

-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:self.mp4_URL]];
        [self addNotification];
    }
    return _moviePlayerViewController;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self.tableView reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registCell];
    [self openSQLite];
    [self checkNetworkStatue];
    
    self.tableView.rowHeight = 193;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
}
#pragma mark -- 注册cell
- (void)registCell
{
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:@"videoCell"];
}

#pragma mark -- 打开数据库 创建表
- (void)openSQLite
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"video.sqlite"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager isExecutableFileAtPath:dbPath]) {
        [manager removeItemAtPath:dbPath error:nil];
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    
    if ([_dataBase open]) {
        //  (@"数据库打开");
    }
    if ([_dataBase executeUpdate:@"CREATE TABLE video (title text, mp4_url text primary key, cover text)"]) {
        //NSLog(@"创表成功");
    }
    
}
#pragma mark -- 获取网络状态
- (void)checkNetworkStatue
{
    //Wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否可以上网 （2G 3G WIFI）
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //网络状态
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    if (wifi.currentReachabilityStatus != NotReachable) {
        
        [self.tableView headerBeginRefreshing];
        [self loadCacheView];
        
    } else if (conn.currentReachabilityStatus != NotReachable) {
        
        [self.tableView headerBeginRefreshing];
        [self loadCacheView];
    
    } else {
        
        [self loadCacheView];
    }
    
}
#pragma mark -- 下拉刷新
- (void)headerRefresh
{
    //Wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否可以上网 （2G 3G WIFI）
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //网络状态
    if (wifi.currentReachabilityStatus != NotReachable) {
        
        num = 0;
        
        if ([_dataBase executeUpdate:@"DELETE FROM video"]) {
            //NSLog(@"清空原数据");
        }
        
        [self loadData];
        
    } else if (conn.currentReachabilityStatus != NotReachable) {
        
        num = 0;
        
        if ([_dataBase executeUpdate:@"DELETE FROM video"]) {
            //NSLog(@"清空原数据");
        }
        
        [self loadData];
    
    }else {
        [self.tableView headerEndRefreshing];
        return;
    }
}
#pragma mark -- 上拉加载
- (void)footerRefresh
{
    //Wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否可以上网 （2G 3G WIFI）
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //网络状态
    if (wifi.currentReachabilityStatus != NotReachable) {
        
        num += 10;
        
        [self loadData];
        
    } else if (conn.currentReachabilityStatus != NotReachable) {
        
        num += 10;
        
        [self loadData];
    
    } else {
        [self.tableView footerEndRefreshing];
        return;
    }
}
#pragma mark -- 加载数据
- (void)loadData
{
    _string = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/list/V9LG4B3A0/n/%ld-10.html",num];
    __block typeof(self) wSelf = self;
    [Network receivedDataWithURLString:_string method:@"GET" body:nil block:^(id tempObj) {
        if (num == 0) {
            [wSelf.dataArray removeAllObjects];
            [wSelf.flaseArray removeAllObjects];
        }else{
            [wSelf.flaseArray removeAllObjects];
        }
        
        NSMutableDictionary *dic = tempObj;
        
        NSArray *array = [dic valueForKey:@"V9LG4B3A0"];
        
        for (NSDictionary *dic2 in array) {
            
            // KVC
            ModelForVideo *modal2 = [[ModelForVideo alloc] init];
            [modal2 setValuesForKeysWithDictionary:dic2];
            
            if (num != 0) {
                [wSelf.flaseArray addObject:modal2];
                for (ModelForVideo *searchModal in wSelf.dataArray) {
                    if ([modal2.title isEqualToString:searchModal.title]) {
                        [wSelf.flaseArray removeObject:modal2];
                    }else{
                        [self insertDataForDB:modal2];
                    }
                }
            } else {
                [self insertDataForDB:modal2];
                [wSelf.dataArray addObject:modal2];
            }
            
            [modal2 release];
            
        }
        
        [wSelf.dataArray addObjectsFromArray:wSelf.flaseArray];
        
        [wSelf.tableView reloadData];
        [wSelf.tableView headerEndRefreshing];
        [wSelf.tableView footerEndRefreshing];
    }];
}

#pragma mark -- 添加数据
- (void)insertDataForDB:(ModelForVideo *)model
{
    
    if ([_dataBase executeUpdate:@"INSERT INTO video (title, mp4_url, cover) values (?, ?, ?)", model.title, model.mp4_url, model.cover]) {
        //NSLog(@"插入成功");
    }
    
}

#pragma mark -- 加载缓存数据
- (void)loadCacheView
{
    
    FMResultSet *result = [_dataBase executeQuery:@"SELECT * FROM video"];
    while ([result next]) {
        NSString *title  = [result stringForColumn:@"title"];
        NSString *mp4_url = [result stringForColumn:@"mp4_url"];
        NSString *cover = [result stringForColumn:@"cover"];
        NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",mp4_url,@"mp4_url",cover,@"cover", nil];
       
        ModelForVideo *model1 = [[ModelForVideo alloc] init];
        [model1 setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model1];
        [model1 release];
    }
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    cell.titleLabel.text = [self.dataArray[indexPath.row] title];
    
    NSURL *url = [NSURL URLWithString:[self.dataArray[indexPath.row] cover]];
    [cell.BackImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Big.jpg"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.moviePlayerViewController = nil;
    
    self.mp4_URL = [self.dataArray[indexPath.row] mp4_url];
    
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            //NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            //NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            //NSLog(@"停止播放.");
            break;
        default:
            //NSLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    //NSLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
    [_moviePlayerViewController dismissMoviePlayerViewControllerAnimated];
}

- (void)dealloc
{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dataBase release];
    [_moviePlayerViewController release];
    [_mp4_URL release];
    [_string release];
    [_flaseArray release];
    [_dataArray release];
    [super dealloc];
}


@end
