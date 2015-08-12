
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface WeatherViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)NSMutableArray *shuZuArr;
@property (nonatomic, retain)NSMutableArray *cityNameAIDArr;
@property (nonatomic, retain)NSMutableArray *proNameArr;
@property (nonatomic, retain)NSMutableArray *searchArr;

@property(nonatomic,strong)NSMutableArray *idDataArray;

@property (nonatomic, copy)void(^block)(NSDictionary *dic);

//接收传来的城市名称
@property(nonatomic,copy)NSString *cityString;

//存放数据
@property(nonatomic,strong)NSMutableArray *dataArray;

@end
