//
//  FashionTableViewController.m
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "FashionTableViewController.h"
#import "DetailViewController.h"

#import "FOneTableViewCell.h"
#import "FTwoTableViewCell.h"
#import "FThreeTableViewCell.h"

#import "ModelForList.h"
#import "Network.h"
#import "ImageModelForList.h"

#import "FMDatabase.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"

#define URLSTR @"http://c.m.163.com/nc/article/list/T1348649079062/0-20.html"
#define TEXTDETAILURL @"http://c.m.163.com/nc/article/AT6L60HV00264MOS/full.html"
#define IMAGEDETAILURL @"http://c.m.163.com/photo/api/set/0026/83663.json"
#define SPECIALURL @"http://c.m.163.com/nc/special/S1418111685718.html"

@interface FashionTableViewController ()
@property (nonatomic , retain) NSMutableArray *dataArray;// 数据源
@property (nonatomic , retain) NSMutableArray *flaseArray; //伪数据源

@property (nonatomic , retain) NSString *string; // URL接口

@property (nonatomic , retain) UIActivityIndicatorView *activityView; //加载中

@property (nonatomic , retain) FMDatabase *dataBase; //数据库
@end

static NSInteger num = 0;
@implementation FashionTableViewController

- (void)dealloc
{
    [_dataBase release];
    [_activityView release];
    [_dataArray release];
    [_flaseArray release];
    [_str release];
    [_string release];
    [super dealloc];
}

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

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self registCell];
    
    [self openSQLite];
    
    [self checkNetworkStatue];
    
}
#pragma mark -- 注册cell
- (void)registCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}
#pragma mark -- 打开数据库 创建表
- (void)openSQLite
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.str]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager isExecutableFileAtPath:dbPath]) {
        [manager removeItemAtPath:dbPath error:nil];
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    
    if ([_dataBase open]) {
        //NSLog(@"数据库打开");
    }
    if ([_dataBase executeUpdate:@"CREATE TABLE news (title text , digest text, imgsrc text, skipID text, docid text primary key, skipType text, imgsrc1 text, imgsrc2 text)"]) {
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
    
    [self.tableView addHeaderWithTarget:self action:@selector(stupDownRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(setupUpRefresh)];
    
    if ([wifi currentReachabilityStatus] != NotReachable) {
        
        [self.tableView headerBeginRefreshing];
        [self loadCacheView];
        
    }else if ([conn currentReachabilityStatus] != NotReachable){
        
        [self.tableView headerBeginRefreshing];
        [self loadCacheView];
        
    } else {
        
        [self loadCacheView];
    }
    
}

#pragma mark -- 设置活动指示器
- (void)setupActivityView
{
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    _activityView.frame = CGRectMake(self.view.bounds.size.width / 2 - 30, self.view.bounds.size.height / 2 - 50, 60, 60);
    _activityView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
    _activityView.layer.cornerRadius = 5.0;
    [self.tableView addSubview:_activityView];
    [_activityView startAnimating];
    [_activityView release];
}
#pragma mark -- 下拉刷新
- (void)stupDownRefresh
{
    //Wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否可以上网 （2G 3G WIFI）
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //网络状态
    if (wifi.currentReachabilityStatus != NotReachable) {
        
        num = 0;
        
        if ([_dataBase executeUpdate:@"DELETE FROM news"]) {
            //NSLog(@"清空原数据");
        }
        
        [self requestData];
        
    } else if (conn.currentReachabilityStatus != NotReachable) {
        
        num = 0;
        
        if ([_dataBase executeUpdate:@"DELETE FROM news"]) {
            //NSLog(@"清空原数据");
        }
        
        [self requestData];
        
    } else {
        [self.tableView headerEndRefreshing];
        return;
    }
}
#pragma mark -- 上拉加载
- (void)setupUpRefresh
{
    //Wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否可以上网 （2G 3G WIFI）
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //网络状态
    if (wifi.currentReachabilityStatus != NotReachable ) {
        
        num += 20;
        
        [self requestData];
        
    } else if ( conn.currentReachabilityStatus != NotReachable ){
        
        num += 20;
        
        [self requestData];
    
    } else {
        [self.tableView footerEndRefreshing];
        return;
    }
}

#pragma mark -- 请求数据
- (void)requestData
{
    [self setupActivityView];
    _string = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/%@/%ld-20.html",self.str,num];
    __block typeof(self) wSelf = self;
    [Network receivedDataWithURLString:_string method:@"GET" body:nil block:^(id tempObj) {
        
        if (num == 0) {
            [wSelf.dataArray removeAllObjects];
            [wSelf.flaseArray removeAllObjects];
        }else{
            [wSelf.flaseArray removeAllObjects];
        }
        
        NSMutableDictionary *dic = tempObj;
        
        NSArray *array = [dic valueForKey:wSelf.str];
  
        for (NSDictionary *dic2 in array) {
            
            // KVC
            ModelForList *modal2 = [[ModelForList alloc] init];
            [modal2 setValuesForKeysWithDictionary:dic2];
            
            if (num != 0) {
                [wSelf.flaseArray addObject:modal2];
                for (ModelForList *searchModal in wSelf.dataArray) {
                    if ([modal2.title isEqualToString:searchModal.title]) {
                        [wSelf.flaseArray removeObject:modal2];
                    } else {
                        //[self insertDataForDB:modal2];
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
        [_activityView stopAnimating];
        [wSelf.tableView headerEndRefreshing];
        [wSelf.tableView footerEndRefreshing];
    }];
    
}
#pragma mark -- 添加数据
- (void)insertDataForDB:(ModelForList *)model
{
    
    ImageModelForList *imgModel1 = model.imagextra[0];
    ImageModelForList *imgModel2 = model.imagextra[1];
    if ([_dataBase executeUpdate:@"INSERT INTO news (title, digest, imgsrc, skipID, docid, skipType, imgsrc1, imgsrc2) values (?, ?, ?, ?, ?, ?, ?, ?)", model.title, model.digest, model.imgsrc, model.skipID, model.docid, model.skipType, [imgModel1 imgsrc], [imgModel2 imgsrc]]) {
        //NSLog(@"插入成功");
    }
    
}

#pragma mark -- 加载缓存数据
- (void)loadCacheView
{
    
    FMResultSet *result = [_dataBase executeQuery:@"SELECT * FROM news"];
    while ([result next]) {
        NSString *title  = [result stringForColumn:@"title"];
        NSString *digest = [result stringForColumn:@"digest"];
        NSString *imgsrc = [result stringForColumn:@"imgsrc"];
        NSString *skipID = [result stringForColumn:@"skipID"];
        NSString *docid  = [result stringForColumn:@"docid"];
        NSString *skipType = [result stringForColumn:@"skipType"];
        NSString *imgsrc1 = [result stringForColumn:@"imgsrc1"];
        NSString *imgsrc2 = [result stringForColumn:@"imgsrc2"];
        NSDictionary *dic = [NSDictionary dictionary];
        if (imgsrc1) {
            NSMutableArray *imgetra = [NSMutableArray arrayWithObjects:@{@"imgsrc":imgsrc1},@{@"imgsrc":imgsrc2}, nil];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",digest,@"digest",imgsrc,@"imgsrc",skipID,@"skipID",docid,@"docid",skipType,@"skipType",imgetra,@"imgextra", nil];
        }else{
            dic = [NSDictionary dictionaryWithObjectsAndKeys:docid,@"docid",title,@"title",digest,@"digest",imgsrc,@"imgsrc",skipID,@"skipID",skipType,@"skipType", nil];
        }
        
        ModelForList *model1 = [[ModelForList alloc] init];
        [model1 setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model1];
        
        [model1 release];
    }
    
    //[self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 197;
        
    } else if ([self.dataArray[indexPath.row] imagextra]){
        
        return 116;
        
    } else
        
        return 87;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        FTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        cell.Label1.text = [self.dataArray[0] title];
        
        NSURL *url = [NSURL URLWithString:[self.dataArray[0] imgsrc]];
        
        [cell.imageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Big.jpg"]];
        
        return cell;
        
    }else if ([self.dataArray[indexPath.row] imagextra]){
        
        FOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        cell.titleLab.text = [self.dataArray[indexPath.row] title];
        
        NSURL *url1 = [NSURL URLWithString:[self.dataArray[indexPath.row] imgsrc]];
        NSURL *url2 = [NSURL URLWithString:[[self.dataArray[indexPath.row] imagextra][0] imgsrc]];
        NSURL *url3 = [NSURL URLWithString:[[self.dataArray[indexPath.row] imagextra][1] imgsrc]];
        
        [cell.imageView1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"small2.jpg"]];
        [cell.imageView2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"small2.jpg"]];
        [cell.imageView3 sd_setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"small2.jpg"]];
        
        return cell;
        
    }else{
        
        FThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.label1.text = [self.dataArray[indexPath.row] title];

        
        [self labelForSting:cell.label2 str:[self.dataArray[indexPath.row] digest]];
        
        NSURL *url = [NSURL URLWithString:[self.dataArray[indexPath.row] imgsrc]];
        
        [cell.imageView1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"small.jpg"]];
        
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
    
    if ([[self.dataArray[indexPath.row] skipType] isEqualToString:@"photoset"]) {     //--->相册 样式
        
        NSArray *arr = [[self.dataArray[indexPath.row] skipID] componentsSeparatedByString:@"|"];
        
        NSString *str = arr[1];
        NSString *str1 = [arr[0] substringFromIndex:4];
        
        detail.URLStr = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json",str1,str];
        detail.titleString = [self.dataArray[indexPath.row] title];
        detail.view.backgroundColor = [UIColor blackColor];
        detail.navigationItem.title = @"图文天下";
        
    }else if ([[self.dataArray[indexPath.row] skipType] isEqualToString:@"special"]){  //--->专题 样式
            
        NSString *str = [self.dataArray[indexPath.row] skipID];
        
        detail.SpecialURLStr = str;
        detail.view.backgroundColor = [UIColor grayColor];
        detail.navigationItem.title = @"天下焦点";
        
    }
    else{                                                  //----->文本 样式
        
        NSString *str = [self.dataArray[indexPath.row] docid];
        detail.titleString = [self.dataArray[indexPath.row] title];
        detail.URLStr = str;
        detail.shareURL = [self.dataArray[indexPath.row] url_share];
        detail.view.backgroundColor = [UIColor whiteColor];
        detail.navigationItem.title = @"新闻热点";
        
    }
    
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
    
    [detail release];
    
}


@end
