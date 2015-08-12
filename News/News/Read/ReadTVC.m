//
//  ReadTVC.m
//  News
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//  http://c.3g.163.com/recommend/getSubDocPic?passport=&devId=866571025631543&size=20&from=yuedu
//  http://c.3g.163.com/recommend/getSubDocNews?passport=&devId=863654024602484&size=20&from=yuedu

#import "ReadTVC.h"

#import "DetailViewController.h"

#import "TextNewsCell.h"
#import "ImageNewsCell.h"

#import "ModelForReadList.h"
#import "Network.h"
#import "ModelForListImage.h"

#import "FMDatabase.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"

#define URLSTR @"http://c.3g.163.com/recommend/getSubDocPic?passport=&devId=863654024602484&size=20&from=yuedu"

@interface ReadTVC ()

@property (nonatomic , retain) NSMutableArray *dataArray;

@property (nonatomic , retain) FMDatabase *dataBase; //数据库

@end

@implementation ReadTVC

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registCell];
    [self openSQLite];
    [self checkNetworkStatue];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark -- 注册cell
- (void)registCell
{
    [self.tableView registerClass:[TextNewsCell class] forCellReuseIdentifier:@"textCell"];    
    [self.tableView registerClass:[ImageNewsCell class] forCellReuseIdentifier:@"ImageCell"];
}

#pragma mark -- 打开数据库 创建表
- (void)openSQLite
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"read.sqlite"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager isExecutableFileAtPath:dbPath]) {
        [manager removeItemAtPath:dbPath error:nil];
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    
    if ([_dataBase open]) {
        //NSLog(@"数据库打开");
    }
    if ([_dataBase executeUpdate:@"CREATE TABLE read (title text, digest text, imgsrc text, docid text primary key, imgsrc1 text, imgsrc2 text)"]) {
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
    
    [self.tableView addHeaderWithTarget:self action:@selector(setupDownRefresh)];
    //[self.tableView addFooterWithTarget:self action:@selector(setupUpRefresh)];
    
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
- (void)setupDownRefresh
{
    
    //Wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否可以上网 （2G 3G WIFI）
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //网络状态
    if (wifi.currentReachabilityStatus != NotReachable ) {
        
        if ([_dataBase executeUpdate:@"DELETE FROM read"]) {
            //NSLog(@"清空原数据");
        }
        
        [self loadData];
        
    } else if (conn.currentReachabilityStatus != NotReachable) {
        
        if ([_dataBase executeUpdate:@"DELETE FROM read"]) {
            //NSLog(@"清空原数据");
        }
        
        [self loadData];
    
    } else {
        [self.tableView headerEndRefreshing];
        return;
    }
}

- (void)setupUpRefresh
{
    
}

- (void)loadData
{
    __block typeof(self) wSelf = self;
    [Network receivedDataWithURLString:URLSTR method:@"GET" body:nil block:^(id tempObj) {
        [wSelf.dataArray removeAllObjects];
        NSDictionary *dic = tempObj;
        NSArray *array = [dic valueForKey:@"推荐"];
        for (NSDictionary *rDic in array) {
            ModelForReadList *readModel = [[ModelForReadList alloc] init];
            [readModel setValuesForKeysWithDictionary:rDic];
            
            [self insertDataForDB:readModel];
            [wSelf.dataArray addObject:readModel];
        }
        [wSelf.tableView reloadData];
        [wSelf.tableView headerEndRefreshing];
    }];
    
    
    
}

#pragma mark -- 添加数据
- (void)insertDataForDB:(ModelForReadList *)model
{
    if (model.imagextra.count == 2) {
        ModelForListImage *imgModel1 = model.imagextra[0];
        ModelForListImage *imgModel2 = model.imagextra[1];
        if ([_dataBase executeUpdate:@"INSERT INTO read (title, digest, imgsrc, docid, imgsrc1, imgsrc2) values (?, ?, ?, ?, ?, ?)", model.title, model.digest, model.imgsrc, model.docid, [imgModel1 imgsrc], [imgModel2 imgsrc]]) {
            //NSLog(@"插入成功");
        }
    }else{
        if ([_dataBase executeUpdate:@"INSERT INTO read (title, digest, imgsrc, docid, imgsrc1, imgsrc2) values (?, ?, ?, ?, ?, ?)", model.title, model.digest, model.imgsrc, model.docid, nil, nil]) {
            //NSLog(@"插入成功");
        }
    }
   
    
}

#pragma mark -- 加载缓存数据
- (void)loadCacheView
{
    
    FMResultSet *result = [_dataBase executeQuery:@"SELECT * FROM read"];
    while ([result next]) {
        NSString *title  = [result stringForColumn:@"title"];
        NSString *digest = [result stringForColumn:@"digest"];
        NSString *imgsrc = [result stringForColumn:@"imgsrc"];
        NSString *docid  = [result stringForColumn:@"docid"];
        NSString *imgsrc1 = [result stringForColumn:@"imgsrc1"];
        NSString *imgsrc2 = [result stringForColumn:@"imgsrc2"];
        NSDictionary *dic = [NSDictionary dictionary];
        if (imgsrc1) {
            NSMutableArray *imgetra = [NSMutableArray arrayWithObjects:@{@"imgsrc":imgsrc1},@{@"imgsrc":imgsrc2}, nil];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",digest,@"digest",imgsrc,@"imgsrc",docid,@"docid",imgetra,@"imgextra", nil];
        }else{
            dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",digest,@"digest",imgsrc,@"imgsrc",docid,@"docid",nil,@"imgextra", nil];
        }
        
        ModelForReadList *model1 = [[ModelForReadList alloc] init];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.row] imagextra].count == 2){
        
        return 201;
        
    } else
        
        return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataArray[indexPath.row] imagextra].count == 2){
        
        ImageNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = [self.dataArray[indexPath.row] title];
        
        NSURL *url1 = [NSURL URLWithString:[self.dataArray[indexPath.row] imgsrc]];
        NSURL *url2 = [NSURL URLWithString:[[self.dataArray[indexPath.row] imagextra][0] imgsrc]];
        NSURL *url3 = [NSURL URLWithString:[[self.dataArray[indexPath.row] imagextra][1] imgsrc]];
        
        [cell.mainImage sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"small2.jpg"]];
        [cell.upImage sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"small2.jpg"]];
        [cell.downImage sd_setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"small2.jpg"]];
        
        return cell;
        
    }else{
        TextNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = [self.dataArray[indexPath.row] title];
        if ([self.dataArray[indexPath.row] digest]) {
            [self labelForSting:cell.digestLabel str:[self.dataArray[indexPath.row] digest]];
        }
        NSURL *url = [NSURL URLWithString:[self.dataArray[indexPath.row] imgsrc]];
        
        [cell.textImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"small.jpg"]];
        
        return cell;
    }

    
    
}

#pragma mark -- 设置 label 行间距
- (void)labelForSting:(UILabel *)label2 str:(NSString *)string
{
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    
    [label2 setAttributedText:attributedString1];
    [label2 sizeToFit];
    
    [attributedString1 release];
    [paragraphStyle1 release];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    
    detail.titleString = [self.dataArray[indexPath.row] title];
    detail.URLStr = [self.dataArray[indexPath.row] docid];
    
    detail.view.backgroundColor = [UIColor whiteColor];
    [detail setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
    
    
}

- (void)dealloc
{
    [_dataBase release];
    [_dataArray release];
    [super dealloc];
}


@end
