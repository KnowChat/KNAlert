//
//  KNViewController.m
//  KNAlert
//
//  Created by yinhaofrancis on 02/19/2019.
//  Copyright (c) 2019 yinhaofrancis. All rights reserved.
//

#import "KNViewController.h"
#import <KNAlert/KNAlert.h>
@interface KNViewController ()

@end

@implementation KNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* bt = @[
                    [[KNAlertButtonInfo alloc] initWithTitle:@"1" Color:UIColor.redColor Font:[UIFont systemFontOfSize:11] CallBack:^(NSObject * _Nonnull object) {
                        NSLog(@"%@",@"1");
                    }],[[KNAlertButtonInfo alloc] initWithTitle:@"2" Color:UIColor.redColor Font:[UIFont systemFontOfSize:11] CallBack:^(NSObject * _Nonnull object) {
                        NSLog(@"%@",@"2");
                    }],[[KNAlertButtonInfo alloc] initWithTitle:@"3" Color:UIColor.redColor Font:[UIFont systemFontOfSize:11] CallBack:^(NSObject * _Nonnull object) {
                        NSLog(@"%@",@"3");
                        [KNAlertManager.sharedInstance hiden];
                    }]
                    ];
    KNAlertView* alert = [[KNAlertView alloc] initWithText:@"dddd" actions:bt];
    [KNAlertManager.sharedInstance showAlert:alert];
    
    KNAlertButtonInfo * cancel = [[KNAlertButtonInfo alloc] initWithTitle:@"3" Color:UIColor.redColor Font:[UIFont systemFontOfSize:11] CallBack:^(NSObject * _Nonnull object) {
        NSLog(@"%@",@"3");
        [KNAlertManager.sharedInstance hiden];
    }];
    cancel.radius = 0;
    cancel.backgroundColor = [UIColor.yellowColor colorWithAlphaComponent:0.1];
    cancel.pressBackgroundColor = UIColor.blueColor;
    
    KNAlertSheet* sheet = [[KNAlertSheet alloc] initWithText:@"dddddd" Cancel:cancel Actions:bt];
    
    [KNAlertManager.sharedInstance showAlert:sheet];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
