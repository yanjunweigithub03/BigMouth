//
//  DetailViewController.h
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic, copy) NSString *URLStr;   // URL
@property (nonatomic, copy) NSString *SpecialURLStr; //专题URL
@property (nonatomic, copy) NSString *titleString; // 新闻标题
@property (nonatomic, copy) NSString *shareURL; //分享URL
@property (nonatomic, assign) BOOL isCollect;
@end
