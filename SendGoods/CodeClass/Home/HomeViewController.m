//
//  HomeViewController.m
//  SendGoods
//
//  Created by 郑州聚义 on 16/6/23.
//  Copyright © 2016年 郑州聚义. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CustomAnnotationView.h"
#import <MAMapKit/MAMapKit.h>
//#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "TongMAAnnotation.h"
@interface HomeViewController () <MAMapViewDelegate, AMapSearchDelegate>

//标记地图已经定位一次
@property (nonatomic, assign) BOOL isOneUpdata;
//记录现在位置的坐标
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

//地图显示
@property (nonatomic, strong) MAMapView *mapView;
//搜索
@property (nonatomic, strong) AMapSearchAPI  *search;

//中心点的坐标视图
@property (nonatomic, strong) UIImageView *redWaterView;
//当前的位置信息
@property (nonatomic, copy) NSString *currentAddressStr;


@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发货";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    
    //地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES; //YES 为打开定位，NO为关闭定位
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    [self.view addSubview:self.mapView];
    //搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    //回到当前位置的按钮
    UIButton *toCurrentID = [UIButton buttonWithType:UIButtonTypeSystem];
    toCurrentID.frame = CGRectMake(20, CGRectGetHeight(self.mapView.bounds)-130, 40, 40);
    toCurrentID.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    toCurrentID.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:0.9];
    toCurrentID.layer.cornerRadius = 3;
    [toCurrentID addTarget:self action:@selector(toCurrentAction) forControlEvents:UIControlEventTouchUpInside];
    [toCurrentID setImage:[UIImage imageNamed:@"gpsnormal.png"] forState:UIControlStateNormal];
    [self.view addSubview:toCurrentID];
    
    //中心点的坐标视图
    UIImage *image = [UIImage imageNamed:@"wateRedBlank"];
    self.redWaterView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, image.size.width,image.size.height)];
    self.redWaterView.center = self.view.center;
    self.redWaterView.image = image;
    [self.view addSubview:self.redWaterView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.mapView.bounds)-80, CGRectGetWidth(self.mapView.bounds), 80)];
    bottomView.backgroundColor = [UIColor colorWithRed:100.0/255 green:150.0/255 blue:220.0/255 alpha:0.9];
    [self.view addSubview:bottomView];
}


//左按钮.菜单
- (void)leftAction {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
}

//回到当前的位置
- (void)toCurrentAction {
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

// 添加标注视图的方法
- (void)addMyPointAnnotationWith:( CLLocationCoordinate2D )coordinate {
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:pointAnnotation];
    
}

//自定义定位标注和精度圈
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor clearColor];
        pre.strokeColor = [UIColor clearColor];
        pre.image = [UIImage imageNamed:@"touming.png"];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

//------地图显示的代理
#pragma mark - 设置大头针标注样式。根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[TongMAAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"pao.png"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        annotationView.selected = YES;
        annotationView.name = self.currentAddressStr;

        return annotationView;
    }
    

    return nil;
}

#pragma mark - 位置更新
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    if(updatingLocation) {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = userLocation.coordinate.latitude;
        coordinate.longitude = userLocation.coordinate.longitude;
        self.currentCoordinate = coordinate;
    }
    if(!self.isOneUpdata) {
        self.isOneUpdata = YES;
        //请求中心位置逆编码
        [self searchReGeocodeWithCoordinate:self.mapView.centerCoordinate];
    }
}

#pragma mark - MapViewDelegate
//地图区域即将改变时会调用此接口
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self.mapView removeAnnotations:self.mapView.annotations];
}
// 地图区域改变完成后会调用此接口
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {

        //请求周边数据,将周边位置添加标注
        [self addAroundAnnotationView];
        //请求中心位置逆编码
        [self searchReGeocodeWithCoordinate:self.mapView.centerCoordinate];
        //让定位图标动画一下
        [self redWaterAnimimate];

    }
}
//请求中心位置逆编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - 逆地理编码查询回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil)
    {
        NSLog(@"逆地理编码查询：%@", response.regeocode.formattedAddress) ;
        self.currentAddressStr = response.regeocode.formattedAddress;
        //并给这个坐标显示标注信息
        [self addMyPointAnnotationWith:self.mapView.centerCoordinate];
    }
}

/* 移动窗口弹一下的动画 */
- (void)redWaterAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.redWaterView.center;
                         center.y -= 20;
                         [self.redWaterView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.redWaterView.center;
                         center.y += 20;
                         [self.redWaterView setCenter:center];}
                     completion:nil];
}


- (void)addAroundAnnotationView {
    TongMAAnnotation *pointAnnotation1 = [[TongMAAnnotation alloc] init];
    CLLocationCoordinate2D coordinate1 ;
    coordinate1.latitude = 34.766842;
    coordinate1.longitude =  113.753775;
    pointAnnotation1.coordinate = coordinate1;
    [self.mapView addAnnotation:pointAnnotation1];
    
    TongMAAnnotation *pointAnnotation = [[TongMAAnnotation alloc] init];
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude = 34.771002;
    coordinate.longitude =  113.772615;
    pointAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:pointAnnotation];
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
