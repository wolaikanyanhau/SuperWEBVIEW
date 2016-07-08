//
//  AFNetworkingHelper.m
//  OurProjectA
//
//  Created by lanouhn on 16/3/26.
//  Copyright © 2016年 tongShaoRui. All rights reserved.
//

#import "AFNetworkingHelper.h"
#import "AFURLSessionManager.h"
#import "AppDelegate.h"

@implementation AFNetworkingHelper

- (AFHTTPSessionManager *)sessionManger {
    if (_sessionManger == nil) {
        self.sessionManger = [AFHTTPSessionManager manager];
        self.sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    }
    return _sessionManger;
}



//单例
+ (AFNetworkingHelper *)shareAFNetworking {
    static AFNetworkingHelper *afnHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afnHelper = [[AFNetworkingHelper alloc] init];
    });
    return afnHelper;
}

///GET网络请求
- (void)getInfoFromSeverWithStr:(NSString *)urlStr body:(NSDictionary *)bodyDic sucess:(void(^)(id))sucess failure:(void(^)(NSError *))failure {
    [self.sessionManger GET:urlStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);

    }];
    
}

//post请求
- (void)postInfoFromSeverWithStr:(NSString *)urlStr body:(NSDictionary *)bodyDic sucess:(void(^)(id))sucess failure:(void(^)(NSError *))failure {
    
    [self.sessionManger POST:urlStr parameters:bodyDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}



//重复下载, 弹窗
- (void)repeatDownAlearWith {
    UIAlertController *alearController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经在下载列表喽" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alearController addAction:cancel];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:alearController animated:YES completion:nil];
}

//下载成功, 弹窗
- (void)doneDownAlearWith:(NSString *)mes{
    UIAlertController *alearController = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alearController addAction:cancel];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:alearController animated:YES completion:nil];
}

//加入下载.弹窗
- (void)addDownloadWith:(NSString *)mes {
    UIAlertController *alearController = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alearController addAction:cancel];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:alearController animated:YES completion:nil];
}

@end
