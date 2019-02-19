//
//  KNAlertButtonInfo.h
//  FBSnapshotTestCase
//
//  Created by KnowChat02 on 2019/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNAlertButtonInfo : NSObject
@property(nullable,nonatomic,strong)NSAttributedString * attributedTitle;
@property(nullable,nonatomic,strong)NSString *title;
@property(nonatomic,nullable,strong)UIImage* image;
@property(nonatomic,nullable,strong)UIImage* pressImage;
@property(nullable,nonatomic,strong)UIFont *font;
@property(nonatomic,nullable,strong)UIColor *color;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic,strong,nonnull)UIColor* backgroundColor;
@property(nonatomic,strong,nonnull)UIColor* pressBackgroundColor;
@property(nonatomic,assign)CGFloat radius;
@property(nullable,nonatomic,copy)void(^callback)(NSObject* _Nonnull object);

-(instancetype _Nonnull )initWithTitle:(NSString* _Nonnull)title Color:(UIColor*_Nonnull)color Font:(UIFont*_Nonnull)font CallBack:(void(^_Nonnull)(NSObject* _Nonnull object))call;
-(instancetype _Nonnull )initWithImage:(nonnull UIImage*)image highlightedImage:(nullable UIImage *)highlightedImage pressImageCallBack:(void(^_Nonnull)(NSObject* _Nonnull object))call;
-(instancetype _Nonnull )initWithTitle:(NSAttributedString * _Nonnull)title CallBack:(void(^_Nonnull)(NSObject* _Nonnull object))call;
-(UIButton*)createButton;
+(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state WithBtn:(UIButton*)btn;
+(void)setFillBackgroundColor:(UIColor *)backgroundColor CornerRadius:(CGFloat)radius forState:(UIControlState)state WithBtn:(UIButton*)btn;
+(void)setStrokeBackgroundColor:(UIColor *)backgroundColor CornerRadius:(CGFloat)radius forState:(UIControlState)state WithBtn:(UIButton*)btn;
@end



NS_ASSUME_NONNULL_END
