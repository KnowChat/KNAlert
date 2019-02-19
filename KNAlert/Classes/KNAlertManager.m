//
//  KNAlertManager.m
//  Knower
//
//  Created by Francis on 2017/6/26.
//  Copyright © 2017年 kc. All rights reserved.
//

#import "KNAlertManager.h"
#import "inner.h"
@interface KNAlertManager(){
    BOOL cancel;
    dispatch_semaphore_t m;
    dispatch_semaphore_t h;
}
@property(nullable,nonatomic,weak)UIView* view;
@property(nonatomic,nonnull)NSOperationQueue * queue;
@property(nonnull,nonatomic)NSOperationQueue * hiddenQueue;
@property(nullable,nonatomic,weak)UITapGestureRecognizer* tap;
@property(nonnull,nonatomic)UIWindow* alertWindow;
@property(nullable,nonatomic)void(^call)(void);
@property(nonnull,nonatomic)NSMutableArray<UIWindow*>*  lastWindow;
@end


@implementation KNAlertManager

- (void)loadView:(UIView *)view {
    [self.lastWindow addObject:UIApplication.sharedApplication.keyWindow];
    [self.alertWindow addSubview:view];
    [self.alertWindow makeKeyAndVisible];
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    
}
- (void)removeView:(UIView *)view {
    [view removeFromSuperview];
    self.alertWindow.windowLevel = UIWindowLevelNormal;
    [self.alertWindow resignKeyWindow];
    [self.lastWindow.lastObject makeKeyAndVisible];
    [self.lastWindow.lastObject becomeKeyWindow];
    [self.lastWindow removeObjectAtIndex: self.lastWindow.count - 1];
    //    [self.arySubViews removeObject:view];
//    if (self.arySubViews.count == 0)
//    {
//        [self resignKeyWindow];
//        if (APP.chatWindow)
//        {
//            [APP.chatWindow makeKeyAndVisible];
//        }
//        else
//        {
//            [APP.window makeKeyAndVisible];
//        }
//    }
}
-(void)showAlert:(UIView *)view{
    [self showAlert:view Callback:nil];
}
-(void)showAlert:(UIView *)view Callback:(void(^)(void))callback{
    [self.queue addOperationWithBlock:^{
        dispatch_semaphore_wait(m, DISPATCH_TIME_FOREVER);
        if (self->cancel){
            cancel = false;
            dispatch_semaphore_signal(m);
            return;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            bool model = callback == nil ? true :false;
            [self showView:view Model:model Callback:callback];
        }];
    }];
}
+(KNAlertManager *)sharedInstance{
    static KNAlertManager* inst;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[KNAlertManager alloc]init];
    });
    return inst;
}
-(void)showView:(UIView *)view Model:(BOOL) model Callback:(void(^)(void))callback{
    
    self.alertWindow.alpha = 0;
    self.alertWindow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    
    self.view = view;
    [self loadView:view];
    self.call = callback;
    if (!model){
        UITapGestureRecognizer* temptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
        [self.alertWindow addGestureRecognizer:temptap];
        self.tap = temptap;
    }
    if ([view respondsToSelector:@selector(showAnimation)]){
        [view performSelectorOnMainThread:@selector(showAnimation) withObject:nil waitUntilDone:true];
    }else{
        view.alpha = 0;
        view.center = self.alertWindow.center;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertWindow.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hiden{
    [self hiden:nil];
}
-(void)hiden:(void(^)(void))Call{
    if (self.view == nil){
        return;
    }
    [self.hiddenQueue addOperationWithBlock:^{
        dispatch_semaphore_wait(h, DISPATCH_TIME_NOW + 10 * NSEC_PER_SEC);
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (self.view == nil){
                dispatch_semaphore_signal(h);
                return;
            }
            UIView *v = self.view;
            self.view = nil;
            [self removeView:v Callback:^{
                dispatch_semaphore_signal(h);
                dispatch_semaphore_signal(m);
                if (Call){
                    Call();
                }
            }];
        }];
    }];
}
-(void)removeView:(UIView*)view Callback:(void(^)(void))callback{
    [self.alertWindow removeGestureRecognizer:self.tap];
    if ([view respondsToSelector:@selector(hideAnimation:)]){
        id<Animation> p = (id<Animation>)view;
        [p hideAnimation:^{
            [self removeView:view];
            self.alertWindow.alpha = 1;
            self.alertWindow.backgroundColor = [UIColor clearColor];
            callback();
        }];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alertWindow.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.alpha = 0;
            self.alertWindow.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeView:view];
            self.alertWindow.alpha = 1;
            self.alertWindow.backgroundColor = [UIColor clearColor];
            callback();
        }];
    }
}
-(void)back:(UITapGestureRecognizer*)tap{
    if (!CGRectContainsPoint(self.view.bounds, [tap locationInView:self.view])){
        [[KNAlertManager sharedInstance] hiden];
        if (self.call != nil){
            self.call();
        }
    }
    
}
-(void)cancelAll{
    [self.queue cancelAllOperations];
    if(self.queue.operationCount > 0){
        cancel = true;
    }
    [self hiden];
}
-(UIView *)root{
    return self.view;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alertWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.queue = [[NSOperationQueue alloc]init];
        self.queue.maxConcurrentOperationCount = 1;
        self.hiddenQueue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
        self->h = dispatch_semaphore_create(1);
        self->m = dispatch_semaphore_create(1);
        self->cancel = false;
        self.lastWindow = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
