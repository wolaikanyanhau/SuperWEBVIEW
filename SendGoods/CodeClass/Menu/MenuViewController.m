//
//  MenuViewController.m
//  SendGoods
//
//  Created by 郑州聚义 on 16/6/23.
//  Copyright © 2016年 郑州聚义. All rights reserved.
//

#import "MenuViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"

@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTabelView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTabelView.delegate = self;
    self.listTabelView.dataSource = self;
    self.listArray = [NSMutableArray arrayWithObjects:@"订单管理", @"我的地址", @"我的跑男", @"商户注册", nil];

    //注册cell
    [self.listTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Menucell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menucell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.listArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    
    switch (indexPath.row) {
        case 0: {
           
        }
            break;
        case 1: {
            //跳转
            
        }
            break;
        case 2: {
            //跳转
        }
            break;
        case 3: {
            
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
