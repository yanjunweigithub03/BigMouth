//
//  DetailViewController.m
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "DetailViewController.h"
#import "FashionTableViewController.h"

#import "Network.h"
#import "CollectButton.h"
#import "AutoView.h"

#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "UIWebView+HTML.h"
#import "NSString+height.h"

#import "FOneTableViewCell.h"
#import "FThreeTableViewCell.h"

#import "ModelForDetail.h"
#import "ModelForList.h"

#define WIDTH  self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height

@interface DetailViewController ()<UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource,UIWebViewDelegate , CollectButtonDelegate>

@property (nonatomic ,retain) NSMutableArray *imageArr; // 图片数组
@property (nonatomic ,retain) NSMutableArray *titleArr; // 标题数组

@property (nonatomic ,retain) UILabel *imageLabel; // 图片页数
@property (nonatomic ,retain) UILabel *titleLabel; //标题

@property (nonatomic ,retain) NSMutableArray *dataArray; //专题数据源
@property (nonatomic ,retain) UITableView *tableView; //专题表视图

@property (nonatomic ,retain) UIWebView *webView; //HTML
@property (nonatomic ,retain) UIAlertView *alertView;


@property (nonatomic ,retain) AutoView *autoView;
@end

@implementation DetailViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackBarButton];
    
    if ([self.URLStr hasSuffix:@"json"]){
        
        [self setupCollectButton];
        [self loadImageViewData];
        
    } else if (self.SpecialURLStr){
        
        [self layoutSpecialView];
        [self registCell];
        [self loadSpecialView];
        
    } else {
        
        [self setupCollectButton];
        [self loadTextViewData];
        
    }
}
#pragma mark -- 返回按钮
- (void)setupBackBarButton
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"iconfont-fanhui.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButton:)];
    leftBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
}

- (void)leftButton:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --  注册CELL
- (void)registCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark -- 沙盒
- (NSString *)documentsForFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [filePath.firstObject stringByAppendingPathComponent:@"collectNews.plist"];
    NSLog(@"%@",documents);
    return documents;
}
#pragma mark --  判断是否已收藏
- (BOOL)isCollect
{
    NSString *documents = [self documentsForFilePath];
    NSMutableArray *dataArr = [NSMutableArray arrayWithContentsOfFile:documents];
    for (NSDictionary *dic in dataArr) {
        NSString *str = [dic valueForKey:@"title"];
        if ([self.titleString isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -- 收藏按钮
- (void)setupCollectButton
{
    CollectButton *collectBtn = [[CollectButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [collectBtn setupButton:CGRectMake(0, 0, 32, 32) isCollect:self.isCollect];
    collectBtn.delegate  = self;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    UIBarButtonItem *shareSDK = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAction) target:self action:@selector(shareNews:)];
    shareSDK.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[shareSDK,rightBarButton];
    [shareSDK release];
    [rightBarButton release];
    [collectBtn release];
}

#pragma mark --  加载（布局）文本样式 新闻视图
- (void)loadTextViewData
{
    //设置webView
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [_webView release];
    
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.URLStr];
    __block typeof(self) wSelf = self;
    [Network receivedDataWithURLString:url method:@"GET" body:nil block:^(id tempObj) {
        
        NSDictionary *dataDic = tempObj;
        NSDictionary *dic = [dataDic valueForKey:self.URLStr];
        
        ModelForDetail *model = [[ModelForDetail alloc]init];
        [model setValuesForKeysWithDictionary:dic];  // KVC
        [wSelf.webView loadHTMLString:[wSelf.webView setUpData:model] baseURL:nil];
        
        [model release];
    }];
}
#pragma mark --  收藏按钮 代理方法
- (void)collectButtonAction:(UIButton *)btn
{
    NSLog(@"收藏了新闻");
    if ([self isCollect]) {
        self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该资讯已收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        _alertView.tag = 700;
        [_alertView show];
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAlertViewCancel) userInfo:nil repeats:NO];
        [_alertView release];
        
    } else {
        
    [btn setImage:[UIImage imageNamed:@"iconfont-shoucang1.png"] forState:(UIControlStateNormal)];
        
    NSString *documents = [self documentsForFilePath];
    NSMutableArray *dataArr = [NSMutableArray arrayWithContentsOfFile:documents];
        
    if (!dataArr) {
        dataArr = [[[NSMutableArray alloc] init] autorelease];
    }
        
    NSDictionary *dic = @{@"url":self.URLStr,@"title":self.titleString};
        
    [dataArr addObject:dic];
    [dataArr writeToFile:documents atomically:YES];
    }
}

#pragma mark --  UIAlertView 自动消失
- (void)dismissAlertViewCancel
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark --  加载（布局）相册样式 新闻视图
- (void)loadImageViewData
{
    self.imageArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    __block typeof(self) wSelf = self;
    [Network receivedDataWithURLString:self.URLStr method:@"GET" body:nil block:^(id tempObj) {
        
        NSDictionary *dic = tempObj;
        
        NSArray *array = [dic valueForKey:@"photos"];
        
        for (NSDictionary *Pdic in array) {
            
            [wSelf.imageArr addObject:[Pdic valueForKey:@"imgurl"]];
            
            [wSelf.titleArr addObject:[Pdic valueForKey:@"imgtitle"]];
            
            //[wSelf.noteArr addObject:[Pdic valueForKey:@"note"]];
            
        }
        [wSelf layoutImageView];
    }];
    
}

#pragma mark -- 布局相册视图
- (void)layoutImageView
{
    _autoView = [AutoView imageScrollViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) imageLinkURL:self.imageArr titleArr:self.titleArr placeHolderImageName:@"Big.png" pageControlShowStyle:(UIPageControlShowStyleNone)];
    _autoView.isNeedCycleRoll = NO;
    [self.view addSubview:_autoView];
    self.view.backgroundColor = [UIColor blackColor];
}


#pragma mark -- 加载 专题
- (void)loadSpecialView
{
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/special/%@.html",self.SpecialURLStr];
    
    __block typeof(self) wSelf = self;
    [Network receivedDataWithURLString:url method:@"GET" body:nil block:^(id tempObj) {
        
        NSDictionary *dic = tempObj;
        
        NSDictionary *dataDic = [dic valueForKey:self.SpecialURLStr];
        
        NSArray *topicArray = [dataDic valueForKey:@"topics"];
        
        for (NSDictionary *docsDic in topicArray) {
            
            NSArray *docsArray = [docsDic valueForKey:@"docs"];
            
            for (NSDictionary *dic2 in docsArray) {
                
                ModelForList *modal2 = [[ModelForList alloc] init];
                [modal2 setValuesForKeysWithDictionary:dic2];
                
                [wSelf.dataArray addObject:modal2];
                
                [modal2 release];

            }
        }
        
        [wSelf.tableView reloadData];
    }];

}

- (void)layoutSpecialView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:(UITableViewStylePlain)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    [_tableView release];

}

#pragma mark -- tableView 代理方法实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.dataArray[indexPath.row] imagextra]){
        
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
    
    if ([self.dataArray[indexPath.row] imagextra]){
        
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
#pragma mark --  点击cell 事件
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
        
    } else {                                                  //----->文本 样式
        
        NSString *str = [self.dataArray[indexPath.row] docid];
        
        detail.URLStr = str;
        detail.titleString = [self.dataArray[indexPath.row] title];
        detail.view.backgroundColor = [UIColor whiteColor];
        detail.navigationItem.title = @"天下热点";
        
    }
    
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
    
    [detail release];
    
}
#pragma mark -- shareSDK 分享
- (void)shareNews:(UIBarButtonItem *)barBtn
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55af41e367e58e609b000a9b"
                                      shareText:[NSString stringWithFormat:@"-> %@ <- =~= -> %@  --> 来自 AppStore《大嘴话天下》-- World IS Changing!!" , self.titleString , self.shareURL]
                                     shareImage:[UIImage imageNamed:@"BigMouth-40@2x.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToDouban,UMShareToRenren,nil]
                                       delegate:nil];
}

- (void)dealloc
{
    [_alertView release];
    [_tableView release];
    [_dataArray release];
    [_URLStr release];
    [_SpecialURLStr release];
    [_titleString release];
    [_imageArr release];
    [_titleArr release];
    [_webView release];
    [_imageLabel release];
    [_titleLabel release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
