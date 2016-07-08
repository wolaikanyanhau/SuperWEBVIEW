//
//  AFNetworkingHelper.h
//  OurProjectA
//
//  Created by lanouhn on 16/3/26.
//  Copyright © 2016年 tongShaoRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkingHelper : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManger;


+ (AFNetworkingHelper *)shareAFNetworking;

///GET网络请求
- (void)getInfoFromSeverWithStr:(NSString *)urlStr body:(NSDictionary *)bodyDic sucess:(void(^)(id))sucess failure:(void(^)(NSError *))failure ;

///post请求
- (void)postInfoFromSeverWithStr:(NSString *)urlStr body:(NSDictionary *)bodyDic sucess:(void(^)(id))sucess failure:(void(^)(NSError *))failure;






@end
