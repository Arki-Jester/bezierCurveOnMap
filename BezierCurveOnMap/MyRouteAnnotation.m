//
//  MyRouteAnnotation.m
//
//
//  Created by A.Jester on 2017/8/18.
//  Copyright © 2018年 . All rights reserved.
//

#import "MyRouteAnnotation.h"

@implementation MyRouteAnnotation
@synthesize type = _type;
@synthesize degree = _degree;

@synthesize model = _model;


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview
{
    ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点  6:楼梯、电梯
    
    BMKAnnotationView* view = nil;
    switch (_type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"icon_travel_begin_default"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"icon_travel_end_default copy"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_bus.png"];
            }
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_rail.png"];
            }
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"waypoint_node"];
            } else {
                [view setNeedsDisplay];
            }
            UIImage* image = [UIImage imageNamed:@"icon_direction.png"];
//            view.image = [image myImageRotatedByDegrees:_degree];
        }
            break;
        case 5:
        {
            
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"waypoint_node"];
            } else {
                [view setNeedsDisplay];
            }
            UIImage* image = [UIImage imageNamed:@"icon-midway"];
//            view.image = [image myImageRotatedByDegrees:_degree];
        }
            break;
            
        case 6:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"stairs_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"stairs_node"];
            }
            view.image = [UIImage imageNamed:@"icon_stairs.png"];
        }
            break;

        case 7:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"getCar_node"];

            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"getCar_node"];
                view.image = [UIImage imageNamed:@"icon_qu_click_bg"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 8:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"returnCar_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"returnCar_node"];
            }
            view.image = [UIImage imageNamed:@"icon_huan_default"];
        }
            break;
        default:
            break;
    }
    if (view) {
        view.annotation = self;
        view.canShowCallout = YES;
    }
    return view;
}
- (BMKAnnotationView*)getRedAnnotationView:(BMKMapView *)mapview
{
    BMKAnnotationView* view = nil;
    view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"red_node"];
    
    if (view == nil) {
        view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"red_node"];
    }
    
    UIImage *redImage = [self createOtherMerchantImage:[NSString
                                                         stringWithFormat:@"%zd元",_model.couponFee.integerValue] withBgImage:[UIImage imageNamed:@"hint_qipao"] withFont:12 withTextColor:[UIColor redColor]];
    view.image = redImage;
    if (view) {
        view.annotation = self;
        view.canShowCallout = YES;
    }
    return view;
}

- (UIImage *)createOtherMerchantImage:(NSString *)str withBgImage:(UIImage *)image withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor

{
    
    //    UIImage *image = [ UIImage imageNamed:@"otherMerchantHeaderBg" ];
    
    CGSize size= CGSizeMake (image. size . width , image. size . height ); // 画布大小
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    //画自己想画的内容。。。。。
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    //    [str drawAtPoint : CGPointMake ( image. size . width * 0.4 , image. size . height * 0.4 ) withAttributes : @{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : 50 ], NSForegroundColorAttributeName :[ UIColor blackColor ],NSParagraphStyleAttributeName:paragraphStyle} ];
    
    UIFont  *font = [UIFont boldSystemFontOfSize:fontSize];//定义默认字体
    //计算文字的宽度和高度：支持多行显示
    CGSize sizeText = [str boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{
                                                  NSFontAttributeName:font,//设置文字的字体
                                                  NSKernAttributeName:@10,//文字之间的字距
                                                  }
                                        context:nil].size;
    
    //为了能够垂直居中，需要计算显示起点坐标x,y
    CGRect rect = CGRectMake((size.width-sizeText.width)/2+15, 10, sizeText.width, sizeText.height);
    
    
    [str drawInRect:rect withAttributes:@{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : fontSize ], NSForegroundColorAttributeName :textColor,NSParagraphStyleAttributeName:paragraphStyle} ];
    
    //画自己想画的内容。。。。。
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}

@end
