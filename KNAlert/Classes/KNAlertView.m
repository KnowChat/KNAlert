//
//  KNAlertView.m
//  Knower
//
//  Created by Francis on 2017/6/26.
//  Copyright © 2017年 kc. All rights reserved.
//

#import "KNAlertView.h"
#import "KNAlertButtonInfo.h"
#import "inner.h"
@interface KNAlertView()
@property(nonatomic,nonnull) NSArray<KNAlertButtonInfo *> * btns;
@end

@implementation KNAlertView
-(instancetype)initWithText:(NSString *)text actions:(NSArray<KNAlertButtonInfo *> *)infos{
    if (text == nil){
        text = @"";
    }
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString* attr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:RGB(0x8f, 0x8f, 0x8f),NSParagraphStyleAttributeName:style}];
    return [self initWithAttrText:attr actions:infos];
}
- (instancetype)initWithAttrText:(NSAttributedString *)attrText actions:(NSArray<KNAlertButtonInfo *> *)infos{
    if (attrText == nil){
        attrText = [[NSAttributedString alloc] init];
    }
    KNAlertAttributeViewStyle* st = [[KNAlertAttributeViewStyle alloc] initWithAttributeString:attrText];
    
    return [self initWithCustom:st actions:infos];
}
-(instancetype)initWithTitle:(NSString*)title ContentText:(NSString*)text actions:(NSArray<KNAlertButtonInfo *> *)infos{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 20;
    style.alignment = NSTextAlignmentCenter;
    if (text == nil){
        text = @"";
    }
    if (title == nil){
        title = @"";
    }
    NSMutableAttributedString* content = [[NSMutableAttributedString alloc]initWithString:title attributes:@{
                                                                                                          NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                                                                                          NSParagraphStyleAttributeName:style,
                                                                                                          NSForegroundColorAttributeName:RGB(0x21,0x21,0x21)}];
    [content appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];
    [content appendAttributedString: [[NSAttributedString alloc] initWithString:text attributes:@{
                                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                  NSParagraphStyleAttributeName:style,
                                                                                                  NSForegroundColorAttributeName:RGB(0x8f, 0x8f, 0x8f)}]];

    KNAlertAttributeViewStyle* st = [[KNAlertAttributeViewStyle alloc] initWithAttributeString:content];
    
    return [self initWithCustom:st actions:infos];
}
-(instancetype)initWithCustom:(id<KNAlertViewCustom>)delegate actions:(NSArray<KNAlertButtonInfo *> *)infos{
    CGSize size = [delegate alertViewContentSize];
    self = [self initWithContentSize:size actions:infos alertDelegate:delegate];
    if (self){
        [self createContent:delegate Size:size];
    }
    return self;
}
-(void)createContent:(id<KNAlertViewCustom>)deleagate Size:(CGSize)size{
    UIView* v =  [deleagate alertViewContentView:size];
    v.frame = [deleagate alertViewContentFrameWithSize:size];
    [self addSubview:v];
}
- (instancetype)initWithContentSize:(CGSize)size actions:(NSArray<KNAlertButtonInfo *> * _Nullable)infos alertDelegate:(id<KNAlertViewCustom>)delegate{
    self.btns = infos;
    CGFloat btnHeight = delegate.alertViewButtonHeight;
    if (infos){
        CGRect r = CGRectMake(0, 0, size.width, size.height + (infos.count < 3 ? btnHeight : btnHeight * infos.count));
        self = [super initWithFrame:r];

    }else{
        self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
    }
    if (infos.count == 2){
        
        UIButton* leftb = [delegate alertViewButton:infos[0]];
        [self addSubview:leftb];
        
        UIButton* rightb = [delegate alertViewButton:infos[1]];
        [self addSubview:rightb];
        
        leftb.frame = CGRectMake(0, self.bounds.size.height - btnHeight, self.bounds.size.width / 2, btnHeight);
        rightb.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height - btnHeight,self.bounds.size.width / 2, btnHeight);
        
    }else{
        for(long i = infos.count - 1; i >= 0; i--){
            UIButton * btn = [delegate alertViewButton:infos[i]];
            long j = infos.count - i;
            btn.frame = CGRectMake(0, self.bounds.size.height - j * btnHeight, self.bounds.size.width, btnHeight);
            [self addSubview:btn];
            
            if (infos.count >= 3) {
                btn.backgroundColor = [UIColor whiteColor];
                [self addLineToBtn:btn];
            }
        }
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 16.f;
    self.clipsToBounds = YES;

    return self;
}

- (void)addLineToBtn:(UIButton *)btn {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 1 / pixelScale;
    [linePath moveToPoint:CGPointZero];
    [linePath addLineToPoint:CGPointMake(0, CGRectGetWidth(btn.frame))];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = RGB(0xe3,0xe3,0xe3).CGColor;
    layer.frame = CGRectMake(0, 0, CGRectGetWidth(btn.frame), 1 / pixelScale);
    [btn.layer addSublayer:layer];
}

-(void)showAnimation{
    self.alpha = 0;
    self.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen.bounds), CGRectGetMidY(UIScreen.mainScreen.bounds));
    self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideAnimation:(void(^)(void))call{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        call();
    }];
}

@end
@implementation KNAlertAttributeViewStyle
-(instancetype)initWithAttributeString:(NSAttributedString*)str{
    self = [super init];
    if (self){
        _attributeString = str;
        self.contentXMargin = 23 * ScaleW;
        self.contentYMargin = 20 * ScaleW;

        self.minHeight = 139 * ScaleW;
        self.alertXMargin = 38 * ScaleW;
    }
    return self;
}

- (UIView *)alertViewContentView:(CGSize)contentSize{
    UILabel * lbl = [[UILabel alloc]init];
    lbl.numberOfLines = 0;
    lbl.attributedText = self.attributeString;
    return lbl;
}
-(CGSize)alertViewContentSize{
    CGRect temp = [self.attributeString boundingRectWithSize:(CGSize){UIScreen.mainScreen.bounds.size.width - 2 * (self.contentXMargin + self.alertXMargin),ViewH} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = CGSizeMake(UIScreen.mainScreen.bounds.size.width - self.alertXMargin * 2,
                             temp.size.height + self.contentXMargin * 2 < self.minHeight ? self.minHeight : temp.size.height + self.contentYMargin * 2);
    return size;
}

- (CGRect)alertViewContentFrameWithSize:(CGSize)size {
    return CGRectMake(self.contentXMargin, 0, size.width - self.contentXMargin * 2, size.height);
}

- (nonnull UIButton *)alertViewButton:(nonnull KNAlertButtonInfo *)info {
    return [info createButton];
}
- (CGFloat)alertViewButtonHeight{
    return 50;
}





@end
