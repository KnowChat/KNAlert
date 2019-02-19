//
//  inner.h
//  Pods
//
//  Created by KnowChat02 on 2019/2/19.
//

#ifndef inner_h
#define inner_h
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(CGFloat)((r)/255.0) green:(CGFloat)((g)/255.0) blue:(CGFloat)((b)/255.0) alpha:(CGFloat)(a)]
#define RGB(r, g, b)        RGBA(r, g, b, 1.0)
#define ViewH CGRectGetHeight([UIScreen mainScreen].bounds)
#define ViewW CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScaleW ViewW/375
#define ScaleH ViewH/667

#define TitleColor RGB(0x21,0x21,0x21)
#define TitleDisableColor RGB(0x8e,0x8e,0x8e)
#define CancelColor RGB(0x8e,0x8e,0x8e)
#define OkColor RGB(0x39,0x54,0x9c)
#define lineColor RGB(0xd2, 0xd2, 0xd2)
#define subtitleColor RGB(0x65, 0x65, 0x65)
#define ButtonColor RGB(0x3d, 0x53, 0x9c)
#define ButtonNewColor RGB(0xfa, 0xe1, 0x00)
#define pixelScale UIScreen.mainScreen.scale
CGContextRef KNCreateContext(CGSize size,CGFloat scale);
CGContextRef KNCreateContextScreenScale(CGSize size);
CGContextRef KNCreateContextNoAlpha(CGSize size,CGFloat scale,CGColorRef fillColor);
CGImageRef KNCGBitContextExportPNG(CGContextRef ctx,CGFloat quality);
CGImageRef KNCGBitContextExportJPG(CGContextRef ctx,CGFloat quality);
#endif /* inner_h */
