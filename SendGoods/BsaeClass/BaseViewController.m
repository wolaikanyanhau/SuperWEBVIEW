//
//  BaseViewController.m
//  OurProjectA
//
//  Created by lanouhn on 16/3/25.
//  Copyright © 2016年 tongShaoRui. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (MBProgressHUD *)HUD {
    if (_HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
    }
    return _HUD;
}

//显示loading
- (void)showProgerssHUD {
    [self showProgerssHUDWithStr:nil];
}

//隐藏loading
- (void)hideProgressHUD {
    if (self.HUD != nil) {
        [self.HUD removeFromSuperViewOnHide];
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}

//显示带有文字提示的loading
- (void)showProgerssHUDWithStr:(NSString *)title {
    if (title.length == 0) {
        self.HUD.labelText = nil;
    } else {
        self.HUD.labelText = title;
    }
    //显示loading
    [self.HUD show:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = NO;
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
