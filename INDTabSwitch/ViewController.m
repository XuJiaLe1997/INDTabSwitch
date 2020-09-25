//
//  ViewController.m
//  INDTabSwitch
//
//  Created by guangzhuiyuandev on 2020/9/24.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#import "ViewController.h"
#import "INDTabSwitchHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onBtnClicked:(id)sender {
    [self.navigationController pushViewController:[[INDTabSwitchDemoVC alloc] init] animated:YES];
}

@end
