//
//  KNAlertView.h
//  Knower
//
//  Created by Francis on 2017/6/26.
//  Copyright © 2017年 kc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNAlertButtonInfo.h"
@class KNAlertView;
NS_ASSUME_NONNULL_BEGIN
@protocol Animation <NSObject>
-(void)showAnimation;
-(void)hideAnimation:(void(^_Nullable)(void))call;
@end
@protocol KNAlertViewCustom <NSObject>

-(CGSize)alertViewContentSize;
- (UIView *)alertViewContentView:(CGSize)contentSize;
-(CGRect)alertViewContentFrameWithSize:(CGSize)size;
-(UIButton*)alertViewButton:(KNAlertButtonInfo*)info;
- (CGFloat)alertViewButtonHeight;
@end
@interface KNAlertAttributeViewStyle : NSObject<KNAlertViewCustom>
-(instancetype)initWithAttributeString:(NSAttributedString*)str;
@property(nonatomic,readonly)NSAttributedString* attributeString;
@property(nonatomic,assign)CGFloat contentXMargin;
@property(nonatomic,assign)CGFloat contentYMargin;
@property(nonatomic,assign)CGFloat minHeight;
@property(nonatomic,assign)CGFloat alertXMargin;

@end

@interface KNAlertView : UIView<Animation>
-(instancetype)initWithText:(NSString* )text actions:(NSArray<KNAlertButtonInfo *>*_Nullable)infos;
- (instancetype _Nullable )initWithAttrText:(NSAttributedString *_Nullable)attrText actions:(NSArray<KNAlertButtonInfo *> *)infos;
-(instancetype )initWithTitle:(NSString*)title ContentText:(NSString*)text actions:(NSArray<KNAlertButtonInfo *> *_Nullable)infos;
-(instancetype )initWithCustom:(id<KNAlertViewCustom>)delegate actions:(NSArray<KNAlertButtonInfo *> *_Nullable)infos;
-(void)createLabel:(NSString *)content Size:(CGSize)size;

@end
NS_ASSUME_NONNULL_END
