//
//  ViewController.m
//  BezierCurveOnMap
//
//  Created by A.Jester on 2018/8/13.
//  Copyright © 2018 AJ. All rights reserved.
//

#import "ViewController.h"
#import "RedPacketPathVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showDemo:(id)sender {
    RedPacketPathVC *vc = [[RedPacketPathVC alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
}


@end
