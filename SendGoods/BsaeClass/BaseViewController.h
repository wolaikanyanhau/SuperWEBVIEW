//
//  BaseViewController.h
//  OurProjectA
//
//  Created by lanouhn on 16/3/25.
//  Copyright © 2016年 tongShaoRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController
///loading对象
@property (nonatomic, strong) MBProgressHUD *HUD;

///显示loading
- (void)showProgerssHUD;

///隐藏loading
- (void)hideProgressHUD;

///显示带有文字提示的loading
- (void)showProgerssHUDWithStr:(NSString *)title;


@end
