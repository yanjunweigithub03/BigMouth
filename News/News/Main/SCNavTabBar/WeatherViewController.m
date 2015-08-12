

#import "WeatherViewController.h"

#import "cityIDModel.h"
#import "ProName.h"

#import "AFNetworking.h"
#import "INSSearchBar.h"

//解析数据
#import "Network.h"

@interface WeatherViewController ()<INSSearchBarDelegate>

@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;

@property (nonatomic, retain)UITableView *tableView;

@end

@implementation WeatherViewController

CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    //先得到appdelegate
    //AppDelegate *app= [UIApplication sharedApplication].delegate;
    
    //比例适配  以6为基准
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat TwoDOU_X = size.width / 375;
    CGFloat TwoDOU_Y = size.height / 667;
    CGRect rect;
    //如果使用此结构体，那么对传递过来的参数，在内部做了比例系数的改变
    rect.origin.x = x * TwoDOU_X;//原点的X坐标的改变
    rect.origin.y = y * TwoDOU_Y;//原点的Y坐标的改变
    rect.size.width = width * TwoDOU_X;//宽的改变
    rect.size.height = height * TwoDOU_Y;//高的改变
    return rect;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.searchArr = [NSMutableArray array];
        self.shuZuArr = [[NSMutableArray alloc] init];
        self.cityNameAIDArr = [[NSMutableArray alloc] init];
        self.proNameArr = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackBarButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择城市";
    
    //self.view.backgroundColor = [UIColor cyanColor];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city ID" ofType:@"txt"]];
    
    NSError *error = nil;
    NSMutableArray *rootArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    self.idDataArray = [NSMutableArray array];
    self.idDataArray = rootArr;
    
    for (int i = 0; i < rootArr.count; i++) {
        
        NSDictionary *dic = [rootArr objectAtIndex:i];
        ProName *pro = [[ProName alloc] initWithDictionary:dic];
        [self.proNameArr addObject: pro];
        self.cityNameAIDArr = [NSMutableArray array];
        NSArray *arr = [dic objectForKey:@"市"];
        for (int j = 0; j < arr.count; j++) {
            
            NSDictionary *dic1 = [arr objectAtIndex:j];
            CityIDModel *IDModel = [[CityIDModel alloc] initWithDictionary:dic1];
            [self.cityNameAIDArr addObject:IDModel];
        }
        [self.shuZuArr addObject:self.cityNameAIDArr];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake1(0, 0, 375, [UIScreen mainScreen].bounds.size.height + 90) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.view addSubview:_tableView];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 45)];
    [self.view addSubview:view];


   
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake1(0, 0, 44.0, 45)];
	self.searchBarWithDelegate.delegate = self;
	
	[view addSubview:self.searchBarWithDelegate];
    
}
- (void)cancleBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
	return CGRectMake1(0, 5, CGRectGetWidth(self.view.bounds) , 35);
}

- (void)setupBackBarButton
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"iconfont-fanhui.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButton:)];
    leftBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)leftButton:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.idDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.searchArr.count == 0) {
        NSArray *arr = [self.shuZuArr objectAtIndex:section];
        return arr.count;
    } else
    {
      return self.searchArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"reuseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    
    NSArray *arr = [self.shuZuArr objectAtIndex:indexPath.section];
    
    CityIDModel *IDModel = [arr objectAtIndex:indexPath.row];
    
    if (self.searchArr.count == 0) {

       cell.textLabel.text = [NSString stringWithFormat:@"   %@",IDModel.cityName];
    
    } else
    {
      cell.textLabel.text = [NSString stringWithFormat:@"  %@",[[self.searchArr firstObject] cityName]];
    }
    
    return cell;
 
}

// 自定义section的标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    ProName *pro = [self.proNameArr objectAtIndex:section];
    label.text = pro.proName;
    label.font = [UIFont boldSystemFontOfSize:18.0f];
   
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


// 点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.searchArr.count == 0) {
        self.cityNameAIDArr = [self.shuZuArr objectAtIndex:indexPath.section];
    } else
    {
        self.cityNameAIDArr = self.searchArr;
    }

    
    CityIDModel *IDModel = [self.cityNameAIDArr objectAtIndex:indexPath.row];
    
   NSString *path = [NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/%@.html", IDModel.cityID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.block([responseObject objectForKey:@"weatherinfo"]);
        [self.navigationController popViewControllerAnimated:YES];
        
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end
