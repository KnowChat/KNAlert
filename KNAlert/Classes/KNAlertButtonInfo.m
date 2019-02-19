//
//  KNAlertButtonInfo.m
//  FBSnapshotTestCase
//
//  Created by KnowChat02 on 2019/2/19.
//

#import "KNAlertButtonInfo.h"
#import <objc/runtime.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import "inner.h"
CGContextRef KNCreateContext(CGSize size,CGFloat scale){
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(nil, (int) scale* size.width, (int)scale * size.height, 8, 0, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    CGContextScaleCTM(ctx, scale, scale);
    CGColorSpaceRelease(space);
    return ctx;
}
CGContextRef KNCreateContextScreenScale(CGSize size){
    return KNCreateContext(size, pixelScale);
}
CGContextRef KNCreateContextNoAlpha(CGSize size,CGFloat scale,CGColorRef fillColor){
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             nil,
                                             (int)size.width * scale,
                                             (int)size.height * scale,
                                             8,
                                             0,
                                             space,
                                             kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextScaleCTM(ctx, scale, scale);
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, fillColor);
    CGContextFillRect(ctx, (CGRect){0,0,size.width,size.height});
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(space);
    return ctx;
    
}
CGImageRef KNCGBitContextExportPNG(CGContextRef ctx,CGFloat quality){
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorSystemDefault, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(data, kUTTypePNG, 1, NULL);
    CFNumberRef number = CFNumberCreate(kCFAllocatorSystemDefault, kCFNumberFloatType, &quality);
    CFTypeRef v[1];
    CFTypeRef  n[1];
    v[0] = kCGImageDestinationLossyCompressionQuality;
    n[0] = number;
    
    CFDictionaryRef property = CFDictionaryCreate(kCFAllocatorSystemDefault, (const void**)&v, (const void**)&n, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CGImageDestinationAddImage(destination, img, property);
    CGImageDestinationFinalize(destination);
    
    CGImageSourceRef source = CGImageSourceCreateWithData(data, nil);
    CGImageRef result = CGImageSourceCreateImageAtIndex(source, 0, nil);
    
    CGImageRelease(img);
    CFRelease(data);
    CFRelease(destination);
    CFRelease(number);
    CFAutorelease(property);
    CFRelease(source);
    return result;
}
CGImageRef KNCGBitContextExportJPG(CGContextRef ctx,CGFloat quality){
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorSystemDefault, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(data, kUTTypeJPEG, 1, NULL);
    CFNumberRef number = CFNumberCreate(kCFAllocatorSystemDefault, kCFNumberFloatType, &quality);
    CFTypeRef v[1];
    CFTypeRef  n[1];
    v[0] = kCGImageDestinationLossyCompressionQuality;
    n[0] = number;
    
    CFDictionaryRef property = CFDictionaryCreate(kCFAllocatorSystemDefault, (const void**)&v, (const void**)&n, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CGImageDestinationAddImage(destination, img, property);
    CGImageDestinationFinalize(destination);
    
    CGImageSourceRef source = CGImageSourceCreateWithData(data, nil);
    CGImageRef result = CGImageSourceCreateImageAtIndex(source, 0, nil);
    
    CGImageRelease(img);
    CFRelease(data);
    CFRelease(destination);
    CFRelease(number);
    CFAutorelease(property);
    CFRelease(source);
    return result;
}
@implementation KNAlertButtonInfo
-(instancetype _Nonnull )initWithTitle:(NSString*_Nonnull)title Color:(UIColor*_Nonnull)color Font:(UIFont*_Nonnull)font CallBack:(void(^_Nonnull)(NSObject* _Nonnull object))call {
    self = [super init];
    if(self){
        self.title = title;
        self.color = color;
        
        self.callback = call;
        self.font = font;
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage pressImageCallBack:(void (^)(NSObject * _Nonnull))call{
    self = [super init];
    if(self){
        self.image = image;
        self.title = nil;
        self.pressImage = highlightedImage;
        self.callback = call;
    }
    return self;
}
-(instancetype)initWithTitle:(NSAttributedString *)title CallBack:(void (^)(NSObject * _Nonnull))call{
    self = [super init];
    if(self){
        self.attributedTitle = title;
        self.callback = call;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
    
}
-(UIButton*)createButton{
    UIButton* btn = [[UIButton alloc] init];
    [self setProperty:btn];
    return btn;
}
-(void)call{
   KNAlertButtonInfo* info = objc_getAssociatedObject(self, @"KNButtonInfo_callback");
    if (info.callback != nil){
        info.callback(self);
    }
}
-(void)setProperty:(UIButton*)btn{
    btn.adjustsImageWhenHighlighted = NO;
    if (self.attributedTitle){
        [btn setAttributedTitle:self.attributedTitle forState:UIControlStateNormal];
    }else{
        [btn setTitle:self.title forState:UIControlStateNormal];
        [btn setTitleColor:self.color forState:UIControlStateNormal];
        [btn setTitleColor:[self.color colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [btn setImage:self.image forState:UIControlStateNormal];
        [btn setImage:self.pressImage forState:UIControlStateHighlighted];
    }
    
    
    btn.tag = self.index;
    btn.titleLabel.font = self.font;
    if (self.radius > 0){
        [KNAlertButtonInfo setFillBackgroundColor:self.backgroundColor == nil ? UIColor.whiteColor : self.backgroundColor CornerRadius:self.radius forState:UIControlStateNormal WithBtn:btn];
        [KNAlertButtonInfo setFillBackgroundColor:self.pressBackgroundColor == nil ? UIColor.whiteColor : self.pressBackgroundColor CornerRadius:self.radius forState:UIControlStateHighlighted WithBtn:btn];
    }else{
        [KNAlertButtonInfo setBackgroundColor:self.backgroundColor == nil ? UIColor.whiteColor : self.backgroundColor forState:UIControlStateNormal WithBtn:btn];
        [KNAlertButtonInfo setBackgroundColor:self.pressBackgroundColor == nil ? UIColor.whiteColor : self.pressBackgroundColor forState:UIControlStateHighlighted WithBtn:btn];
    }
    
    [btn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, @"KNButtonInfo_callback", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state WithBtn:(UIButton*)btn{
    CGContextRef context = KNCreateContext(CGSizeMake(10, 10), pixelScale);

    CGContextAddRect(context, CGRectMake(0, 0, 10, 10));

    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);

    CGContextFillPath(context);
    CGImageRef temp = CGBitmapContextCreateImage(context);
    [btn setBackgroundImage:[[UIImage alloc]initWithCGImage:temp] forState:state];
    CGImageRelease(temp);
    CGContextRelease(context);
}
+(void)setFillBackgroundColor:(UIColor *)backgroundColor CornerRadius:(CGFloat)radius forState:(UIControlState)state WithBtn:(UIButton*)btn{
    CGContextRef context = KNCreateContext(CGSizeMake(radius * 3, radius * 3), pixelScale);

    CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, radius * 3, radius * 3), radius, radius, nil);
    CGContextAddPath(context, path);

    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillPath(context);
    CGImageRef temp = CGBitmapContextCreateImage(context);
    UIImage * base = [[UIImage alloc] initWithCGImage:temp scale:pixelScale orientation:UIImageOrientationUp];
    CGImageRelease(temp);
    UIImage* img = [base resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius , radius, radius)];
    [btn setBackgroundImage:img forState:state];
    CGPathRelease(path);
    CGContextRelease(context);
}
+(void)setStrokeBackgroundColor:(UIColor *)backgroundColor CornerRadius:(CGFloat)radius forState:(UIControlState)state WithBtn:(UIButton*)btn{
    CGContextRef context = KNCreateContext(CGSizeMake(radius * 3, radius * 3), pixelScale);

    CGPathRef path = CGPathCreateWithRoundedRect(CGRectMake(2, 2, radius * 3 - 4, radius * 3 - 4), radius, radius, nil);
    CGContextAddPath(context, path);

    CGContextSetStrokeColorWithColor(context, backgroundColor.CGColor);
    CGContextStrokePath(context);
    CGImageRef temp = CGBitmapContextCreateImage(context);
    UIImage * base = [[UIImage alloc] initWithCGImage:temp scale:pixelScale orientation:UIImageOrientationUp];
    CGImageRelease(temp);
    UIImage* img = [base resizableImageWithCapInsets:UIEdgeInsetsMake(radius + 2 , radius + 2, radius + 2 ,radius + 2)];
    [btn setBackgroundImage:img forState:state];
    CGPathRelease(path);
    CGContextRelease(context);
}
@end
