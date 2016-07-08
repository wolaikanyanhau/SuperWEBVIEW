//
//  Header.h
//  SendGoods
//
//  Created by 郑州聚义 on 16/6/23.
//  Copyright © 2016年 郑州聚义. All rights reserved.
//

#ifndef Header_h
#define Header_h

//head.h文件一般用于添加宏定义, 以及一些比较常用的api, 比如NSLog, 公司后台的接口地址,等

//常用宏
//屏幕宽
#define KDeviceWith [UIScreen mainScreen].bounds.size.width
//屏幕高
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

//打印API
#define MyLog(...) NSLog(__VA_ARGS__)


//高德
#define KGaodeKey @"995331e0b19f690ec9bffe0f63e0f3f9"


#endif /* Header_h */
