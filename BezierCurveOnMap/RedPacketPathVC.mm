//
//  RedPacketPathVC.m
//  
//
//  Created by A.Jester on 2018/6/1.
//  Copyright © 2018. All rights reserved.
//
#define Screen_Width ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height (iPhoneX ? [UIScreen mainScreen].bounds.size.height - 34 -24 : [UIScreen mainScreen].bounds.size.height)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#import "YYModel.h"
#import "RedPacketPathVC.h"
#import "MyRouteAnnotation.h"
#import "math.h"

@interface RedPacketPathVC ()<BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    MyRouteAnnotation *_redView;
}
@end

@implementation RedPacketPathVC

-(void)dealloc{
    _mapView.delegate = nil;
    [_mapView removeFromSuperview];
    _mapView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"红包线路";
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];

    self.lat = 30.940484999999999;
    self.lng = 118.2605300;
    [self setupTempData];
}
- (void)setupTempData{
    NSDictionary *dict = @{@"data" : @{@"redLines" : @[
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"芜湖市政务中心（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.43933868",
                                               @"lat" : @"31.36098862"
                                               },
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"芜湖市国税局（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.38597870",
                                               @"lat" : @"31.34233093"
                                               },
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"芜湖市质监局（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.40959167",
                                               @"lat" : @"31.38404846"
                                               },
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"芜湖火车站地下停车场（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.39870453",
                                               @"lat" : @"31.35589600"
                                               },
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"碧桂园（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.31208038",
                                               @"lat" : @"31.26398468"
                                               },
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"保定新城（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.23438263",
                                               @"lat" : @"31.24201775"
                                               },
                                           @{
                                               @"minCars" : @"1",
                                               @"couponFee" : @"30.00",
                                               @"returnSiteName" : @"弋江嘉园广场（自助）",
                                               @"getSiteName" : @"万安新村（自助）",
                                               @"lng" : @"118.39750671",
                                               @"lat" : @"31.29854774"
                                               }
                                           ],
                                   
                                   }
                           };
    [self setPolylineData:dict];
    
}

- (void)setPolylineData:(NSDictionary *)json
{
    if ([json[@"data"] isKindOfClass:[NSNull class]]) {
        
        return;
    }else{
        
        NSArray *array = json[@"data"][@"redLines"];
        
        MyRouteAnnotation* item = [[MyRouteAnnotation alloc]init];
        CLLocationCoordinate2D annotationCoord;
        annotationCoord.latitude = self.lat;
        annotationCoord.longitude = self.lng;
        item.coordinate = annotationCoord;
        item.title = @"取车点";
        item.type = 7;
        [_mapView addAnnotation:item]; // 添加起点标注
        [_mapView setCenterCoordinate:annotationCoord];
        
        for (NSDictionary *dic in array) {
            TrajectoryModel_trajectory *model = [TrajectoryModel_trajectory yy_modelWithJSON:dic];
            CLLocationCoordinate2D annotationCoord;
            annotationCoord.latitude = [model.lat floatValue];
            annotationCoord.longitude = [model.lng floatValue];
            
            MyRouteAnnotation* item = [[MyRouteAnnotation alloc]init];
            item.coordinate = annotationCoord;
            item.title = @"";
            item.type = 8;
            item.model = model;
            [_mapView addAnnotation:item];// 添加终点标注
        }
        
        //]==============默认取离起点最近的坐标点
        CLLocationDistance distance = MAXFLOAT;
        int index = 0;
        for (int i = 0;i<array.count;i++) {
            NSDictionary *dic  = array[i];
            TrajectoryModel_trajectory *model = [TrajectoryModel_trajectory yy_modelWithJSON:dic];
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(model.lat.doubleValue,model.lng.doubleValue));
            BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.lat,self.lng));
            CLLocationDistance newDistance = BMKMetersBetweenMapPoints(point1,point2);
            if (newDistance<distance) {
                distance = newDistance;
                index = i;
            }
        }
        
        
        CLLocationCoordinate2D coorss[3] = {0};
        
        coorss[0].longitude = self.lng;
        coorss[0].latitude = self.lat;
        
        
        double x1 = self.lng;
        double y1 = self.lat;
        TrajectoryModel_trajectory *model = [TrajectoryModel_trajectory yy_modelWithJSON:array[index]];

        
        double x2 = model.lng.doubleValue;
        double y2 = model.lat.doubleValue;
        
        CGPoint p = [self getLngLat:x1 y1:y1 x2:x2 y2:y2 arc:20];
        CLLocationCoordinate2D annotationCoords;
        annotationCoords.longitude = p.x;
        annotationCoords.latitude = p.y;
        MyRouteAnnotation* items = [[MyRouteAnnotation alloc]init];
        items.type = 9;
        items.model = model;
        items.coordinate = annotationCoords;
        _redView = items;
        [_mapView addAnnotation:items];
        
        coorss[1].longitude = p.x;
        coorss[1].latitude = p.y;
        
        coorss[2].longitude = x2;
        coorss[2].latitude = y2;
        
        BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coorss];
        [_mapView addOverlay:arcline];
        [self mapViewFitArcLine:arcline];
    }
    
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyRouteAnnotation class]]) {
        MyRouteAnnotation *anno = (MyRouteAnnotation *)annotation;
        if (anno.type == 9) {
            return [(MyRouteAnnotation*)annotation getRedAnnotationView:view];
        }else{
            return [(MyRouteAnnotation*)annotation getRouteAnnotationView:view];
        }
    }
    return nil;
}
#pragma mark -- 路线线条绘制代理
- (BMKOverlayView *)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc]initWithOverlay:overlay];
        arclineView.strokeColor = [UIColor greenColor];
        arclineView.lineWidth = 2.0;
        return arclineView;
    }
    return nil;
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    if ([view.annotation isKindOfClass:[MyRouteAnnotation class]])
    {
        MyRouteAnnotation *annotationView = (MyRouteAnnotation *)view.annotation;
        TrajectoryModel_trajectory *model = annotationView.model;
        
        if (annotationView.type == 8) {
            view.image = [UIImage imageNamed:@"icon_huan_click_bg"];
            [_mapView removeOverlays:_mapView.overlays];
            [_mapView removeAnnotation:_redView];
            //=====================三点画弧线
            CLLocationCoordinate2D coorss[3] = {0};
            
            coorss[0].longitude = self.lng;
            coorss[0].latitude = self.lat;
            
            
            double x1 = self.lng;
            double y1 = self.lat;
            
            double x2 = annotationView.coordinate.longitude;
            double y2 = annotationView.coordinate.latitude;
            
            CGPoint p = [self getLngLat:x1 y1:y1 x2:x2 y2:y2 arc:20];
            
            CLLocationCoordinate2D annotationCoord;
            annotationCoord.longitude = p.x;
            annotationCoord.latitude = p.y;
            MyRouteAnnotation* items = [[MyRouteAnnotation alloc]init];
            items.type = 9;
            items.model = model;
            items.coordinate = annotationCoord;
            _redView = items;
            [_mapView addAnnotation:items]; //红包
            
            
            coorss[1].longitude = p.x;
            coorss[1].latitude = p.y;
            
            coorss[2].longitude = x2;
            coorss[2].latitude = y2;
            
            BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coorss];
            [_mapView addOverlay:arcline];
            [self mapViewFitArcLine:arcline];
        }
        
    }
}
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MyRouteAnnotation class]])
    {
        MyRouteAnnotation *annotationView = (MyRouteAnnotation *)view.annotation;

        if (annotationView.type != 7) {
            view.image = [UIImage imageNamed:@"icon_huan_default"];
        }

    }
}
#pragma mark  根据ArcLine设置地图范围
- (void)mapViewFitArcLine:(BMKArcline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    static_cast<void>(ltX = pt.x), ltY = pt.y;
    static_cast<void>(rbX = pt.x), rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 1;
}
#pragma mark  根据起点 终点两坐标点 获取两点连线中垂线上的点 （含角度）

-  (CGPoint )getLngLat:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double) y2 arc:(double) arc {
    BOOL xEqual = x1 == x2;
    BOOL yEqual = y1 == y2;
    if (xEqual && yEqual) {
//        return 0;// (x1,y1) 与 (x2,y2)重合
        return CGPointMake(0, 0);

    }
    
    double xm = (x1 + x2) / 2;
    double ym = (y1 + y2) / 2;
    double angle = M_PI * arc / 180;
    double lenth = sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));
    double delt = lenth * 0.5 * tan(angle);
    double delt2 = delt * delt;
    
    if (xEqual) {
//会返回两个坐标点，p1(x11,y11),p2(x12,y12) 默认取第一个,以下同理
        double x11 = xm - delt;
        double y11 = ym;
//        double x12 = xm + delt;
//        double y12 = ym;
        return CGPointMake(x11, y11);
    }
    
    if (yEqual) {
        double x11 = xm;
        double y11 = ym - delt;
//        double x12 = xm;
//        double y12 = ym + delt;
        return CGPointMake(x11, y11);
    }
    
    // 其他非特殊情况的计算
    double x21 = x2 - x1;
    double y21 = y2 - y1;
    double xy21 = x21 / y21;
    double a1 = ym + xy21 * xm;
    double a11 = a1 - ym;
    double a = 1 + xy21 * xy21;
    double b = -(2 * xm + 2 * a11 * xy21);
    double c = xm * xm + a11 * a11 - delt2;
    double tmpParam = b * b - 4 * a * c;
    // y = a1 - xy21 * x
    // ax2 + bx + c = 0
    // b2 - 4ac >= 0
    // x = (-b (+-) sqart(b2 - 4ac))/2a
    if (tmpParam < 0) {
//        return 0;// 方程无解
    }
    
    double p1 = -b;
    double p2 = sqrt(tmpParam);// b2 - 4ac
    double p3 = 2 * a;
    
    double x11 = (p1 + p2) / p3;
    double y11 = a1 - xy21 * x11;
    
//    double x12 = (p1 - p2) / p3;
//    double y12 = a1 - xy21 * x12;
    
    CGPoint p = CGPointMake(x11, y11);
    return p;
}
@end
