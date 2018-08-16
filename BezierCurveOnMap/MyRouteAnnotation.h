//
//  MyRouteAnnotation.h
//
//
//  Created by DuanLihang on 2017/8/18.
//  Copyright © 2017年 . All rights reserved.
//
#import "TrajectoryModel_trajectory.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface MyRouteAnnotation : BMKPointAnnotation

///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  6:楼梯、电梯
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger degree;
@property (nonatomic,strong) TrajectoryModel_trajectory *model;

//获取该RouteAnnotation对应的BMKAnnotationView
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview;


- (BMKAnnotationView*)getRedAnnotationView:(BMKMapView *)mapview;

@end
