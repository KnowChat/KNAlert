//
//  KNAlertManager.h
//  Knower
//
//  Created by Francis on 2017/6/26.
//  Copyright © 2017年 kc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNAlertView.h"
#import "KNAlertSheet.h"
@interface KNAlertManager : NSObject
-(void)showAlert:(UIView *)view Callback:(void(^)(void))callback;
-(void)showAlert:(UIView *)view;
-(void)hiden;
-(void)hiden:(void(^)(void))Call;
+(KNAlertManager*)sharedInstance;
-(void)cancelAll;
-(UIView*)root;
@end
