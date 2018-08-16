//
//  AppDelegate.m
//  BezierCurveOnMap
//
//  Created by A.Jester on 2018/8/13.
//  Copyright © 2018 AJ. All rights reserved.
//
#import "AppDelegate.h"

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate

NSString *AK_KEY= @"zQ6Gp58CpW7gReaCnLTaP7RrKXZRHsgF";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 启动百度地图授权
    [self startBMKMapManager];
    //初始化导航SDK
//    [BNCoreServices_Instance initServices:AK_KEY];
//    [BNCoreServices_Instance setTTSAppId:@"9616151"];
//    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:AK_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    return YES;
}
#pragma mark - 百度地图授权
- (BOOL)startBMKMapManager
{
    _mapManager = nil;
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:AK_KEY  generalDelegate:self];
    return ret;
}
#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else {
        NSLog(@"onGetNetworkState %d",iError);
    }
    return;
}
- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
    return;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
