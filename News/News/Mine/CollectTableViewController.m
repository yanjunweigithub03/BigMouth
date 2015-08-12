//
//  CollectTableViewController.m
//  News
//
//  Created by lanou3g on 15/7/8.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "CollectTableViewController.h"
#import "DetailViewController.h"

@interface CollectTableViewController ()<UIAlertViewDelegate>
@property (nonatomic , retain) NSMutableArray *dataArray;
@end

@implementation CollectTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSString *documents = [self documentsForFilePath];
        self.dataArray = [NSMutableArray arrayWithContentsOfFile:documents];
    }
    return _dataArray;
}

- (NSString *)documentsForFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [filePath.firstObject stringByAppendingPathComponent:@"collectNews.plist"];
    
    return documents;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你还没有收藏资讯，赶快去收藏您喜欢的资讯吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    [self setupBackBarButton];
    
    [self.editButtonItem setTitle:@"编辑"];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [view release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.editButtonItem setTitle:@"完成"];
    } else {
        [self.editButtonItem setTitle:@"编辑"];
    }
    [self.tableView setEditing:editing animated:animated];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self leftButton:nil];
    }
}

- (void)setupBackBarButton
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButton:)];
    leftBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)leftButton:(UIBarButtonItem *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.dataArray[indexPath.row] valueForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.URLStr = [self.dataArray[indexPath.row] valueForKey:@"url"];
    detail.titleString = [self.dataArray[indexPath.row] valueForKey:@"title"];
    detail.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.dataArray writeToFile:[self documentsForFilePath] atomically:YES];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}



@end
