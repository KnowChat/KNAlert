//
//  KNAlertSheet.h
//  Knower
//
//  Created by Francis on 2017/7/26.
//  Copyright © 2017年 kc. All rights reserved.
//

#import "KNAlertView.h"
#import "KNAlertButtonInfo.h"
@interface KNAlertSheet : UIView<Animation>
-(instancetype)initWithText:(NSString *)text Cancel:(KNAlertButtonInfo*)cancel Actions:(NSArray<KNAlertButtonInfo *> *)infos;
@end
