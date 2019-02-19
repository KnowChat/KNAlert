//
//  KNAlertSheet.m
//  Knower
//
//  Created by Francis on 2017/7/26.
//  Copyright © 2017年 kc. All rights reserved.
//

#import "KNAlertSheet.h"
#import "inner.h"
@interface KNAlertSheet()
@property(nonnull,nonatomic)UIButton* cancel;
@property(nonatomic) CGFloat marginleft;
@property(nonatomic) CGFloat marginTop;
@property(nonatomic) CGFloat radius;
@property(nonatomic) CGRect backRect;
@property(nonatomic) CGRect cancelRect;
@end
@implementation KNAlertSheet
-(instancetype)initWithText:(NSString *)text Cancel:(KNAlertButtonInfo *)cancel Actions:(NSArray<KNAlertButtonInfo *> *)infos{
    self = [super init];
    if (self) {
        self.marginTop = 12;
        self.marginleft = 15;
        self.radius = 12;
        [self createUIText:text Actions:infos];
        
        self.cancel = [cancel createButton];
//        self.cancel.backgroundColor = [UIColor whiteColor];
//        self.cancel.layer.cornerRadius = self.radius;
//        self.cancel.clipsToBounds = YES;
        
        CGImageRef img = [self image:self.frame.size Count:infos.count];
        self.layer.contents = (__bridge id _Nullable)(img);
        CGImageRelease(img);
    }
    return self;
}
-(void)createUIText:(NSString *)text Actions:(NSArray<KNAlertButtonInfo *> *)infos{
    CGRect lblSize = [[UIScreen mainScreen] bounds];
    lblSize.size.width = lblSize.size.width - self.marginleft * 2 - self.marginTop * 2;
    lblSize = [text boundingRectWithSize:lblSize.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGRect lblRect = CGRectMake(self.radius + 20, self.radius, UIScreen.mainScreen.bounds.size.width  - self.marginleft * 2 - self.radius * 2 - 40, lblSize.size.height + 40 < 69 ? 69 : lblSize.size.height + 40);
    UILabel* lblView = [[UILabel alloc]init];
    lblView.textAlignment = NSTextAlignmentCenter;
    lblView.text = text;
    lblView.font = [UIFont systemFontOfSize:15];
    lblView.textColor = TitleDisableColor;
    lblView.frame = lblRect;
    [self addSubview:lblView];
    lblView.numberOfLines = 10;
    NSInteger index = 0;
    CGFloat y = CGRectGetMaxY(lblView.frame);
    for (KNAlertButtonInfo* i in infos) {
        UIButton* btn = [i createButton];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = index;
        index++;
        btn.frame = CGRectMake(self.radius, y, UIScreen.mainScreen.bounds.size.width  - self.marginleft * 2 - self.radius * 2, 53);
        [self addSubview:btn];
        y = CGRectGetMaxY(btn.frame);
    }
    CGFloat frameY =[[UIScreen mainScreen] bounds].size.height - 8 - 53 * (infos.count + 1) - 12 - lblRect.size.height - self.radius;
    self.frame = CGRectMake(self.marginleft, frameY, UIScreen.mainScreen.bounds.size.width - self.marginleft * 2, lblRect.size.height + infos.count * 53 + self.radius);
}
-(void)didMoveToSuperview{
    self.cancel.frame = CGRectMake(self.marginleft, [[UIScreen mainScreen] bounds].size.height - 8 - 53, [[UIScreen mainScreen] bounds].size.width - self.marginleft * 2, 53);
    [self.superview addSubview:self.cancel];
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    [self.cancel removeFromSuperview];
}
-(void)hideAnimation:(void(^)(void))call{
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(self.frame.origin.x, UIScreen.mainScreen.bounds.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.cancel.frame = CGRectMake(self.cancel.frame.origin.x, UIScreen.mainScreen.bounds.size.height, self.cancel.frame.size.width, self.cancel.frame.size.height);
    } completion:^(BOOL finished) {
        call();
    }];
}

-(void)showAnimation{
    // 适配iphonex
    if (@available(iOS 11.0, *)) {
        CGRect f = self.frame;
        UIEdgeInsets inst = UIApplication.sharedApplication.keyWindow.safeAreaInsets;
        f.origin.y  -= inst.bottom;
        self.frame = f;
        CGRect cancel = self.cancel.frame;
        cancel.origin.y  -= inst.bottom;

        self.cancel.frame = cancel;
    } else {
        // Fallback on earlier versions
    }
    self.backRect = self.frame;
    self.cancelRect = self.cancel.frame;
    self.frame = CGRectMake(self.frame.origin.x, UIScreen.mainScreen.bounds.size.height, self.frame.size.width, self.frame.size.height);
    self.cancel.frame = CGRectMake(self.cancel.frame.origin.x, UIScreen.mainScreen.bounds.size.height, self.cancel.frame.size.width, self.cancel.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = self.backRect;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.cancel.frame = self.cancelRect;
    } completion:^(BOOL finished) {
        
    }];
}
-(CGImageRef)image:(CGSize)size Count:(NSUInteger)count{
    CGContextRef context = KNCreateContext(size, pixelScale);
    CGContextSaveGState(context);
    CGPathRef rectpath = CGPathCreateWithRoundedRect(CGRectMake(0, 0, size.width, size.height), 12, 12, nil);
    CGContextAddPath(context, rectpath);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    CGPathRelease(rectpath);
    CGContextRestoreGState(context);
    CGContextSetLineWidth(context, 1 / UIScreen.mainScreen.scale);
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 1; i < count + 1; i++){
        CGPathMoveToPoint(path, nil, 0, 53 * i);
        CGPathAddLineToPoint(path, nil, size.width, 53 * i);
    }
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    CGImageRef img = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    return img;
}
@end
