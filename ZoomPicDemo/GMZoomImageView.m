//
//  GMZoomImageView.m
//  ZoomPicDemo
//
//  Created by Rain on 2018/9/11.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import "GMZoomImageView.h"
#import "CustomSheet.h"
@interface GMZoomImageView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapZoomGesture;//点击放大手势

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;//长按手势

@end
static CGRect oldFrame;//图片原始frame

@implementation GMZoomImageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapZoomGesture];
//        [self addGestureRecognizer:self.longGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapZoomGesture];
//        [self addGestureRecognizer:self.longGesture];
    }
    return self;
}

#pragma mark -- 放大图片
- (void)tapZoomImageView:(UIGestureRecognizer *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIImage *image = self.image;
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backView.backgroundColor = [UIColor blackColor];
    backView.tag = 101;
    backView.alpha = 0;
    
    oldFrame = [self convertRect:self.bounds toView:window];
    
    //用于展示的imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldFrame];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    imageView.tag = 100;
    [backView addSubview:imageView];
    
    [window addSubview:backView];
    
    //隐藏展示的imageView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImageView:)];
    [backView addGestureRecognizer:tap];
    //保存图片
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [imageView addGestureRecognizer:longGesture];
    //动画
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y, width, height;
        width = [UIScreen mainScreen].bounds.size.width;
        //根据图片宽高比 设置高度
        height = image.size.height * width / image.size.width;
        y = ([UIScreen mainScreen].bounds.size.height - height) / 2;
        imageView.frame = CGRectMake(0, y, width, height);
        
        backView.alpha = 1;
    }];
    
}

#pragma mark -- 隐藏imageView
- (void)hiddenImageView:(UIGestureRecognizer *)sender {
    UIView *backView = sender.view;
    
//    UIImageView *imageView = [backView viewWithTag:100];
    
    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame = oldFrame;
        backView.alpha -= 1.0;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

#pragma mark -- 保存图片
- (void)saveImage:(UIGestureRecognizer *)sender {
    UIImageView *imageView = (UIImageView *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan) {
        CustomSheet *sheet = [[CustomSheet alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) titleArr:@[@"保存图片"] titleFlag:@"2"];
        __weak typeof(sheet) weakSheet = sheet;
        sheet.Click = ^(NSInteger clickIndex) {
            switch (clickIndex) {
                    case 0:
                    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSaveWithError:contextInfo:), nil);
                    break;
                default:
                    break;
            }
            [weakSheet hiddenSheet:^(BOOL isHidden) {
                
            }];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    }
}

#pragma mark -- 控制手势
- (void)addTapGesture {
    [self addGestureRecognizer:self.tapZoomGesture];
}

- (void)addLongGesture {
    [self addGestureRecognizer:self.longGesture];
}

- (void)removeTapGesture {
    [self removeGestureRecognizer:self.tapZoomGesture];
}

- (void)removeLongGestrue {
    [self removeGestureRecognizer:self.longGesture];
}

#pragma mark -- 保存图片结果回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSaveWithError:(NSError *)error contextInfo:(id)contextInfo {
    NSString *message = nil;
    UIAlertAction *action;
    if (error) {
        message = @"保存图片失败";
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:101];
            if (backView) {
                UIWindow *window = (UIWindow *)[backView viewWithTag:102];
                [window removeFromSuperview];
            }
        }];

    } else {
        message = @"成功保存到相册";
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:101];
            if (backView) {
                UIWindow *window = (UIWindow *)[backView viewWithTag:102];
                [window removeFromSuperview];
            }
        }];
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:action];
    UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:101];
    if (backView) {
        //处理放大图片后，无法模态弹出UIAlertController的解决方式
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.tag = 102;
        window.userInteractionEnabled = NO;
        window.backgroundColor = [UIColor clearColor];
        
        UIViewController *rootVC = [[UIViewController alloc] init];
        rootVC.view.backgroundColor = [UIColor clearColor];
        window.windowLevel = UIWindowLevelAlert + 1;
        [window makeKeyAndVisible];
        window.rootViewController = rootVC;
        [backView addSubview:window];
        [rootVC presentViewController:alertVC animated:YES completion:nil];
    } else {
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:alertVC animated:YES completion:nil];
    }
    

}
#pragma mark -- lazy
- (UITapGestureRecognizer *)tapZoomGesture {
    if (!_tapZoomGesture) {
        _tapZoomGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapZoomImageView:)];
    }
    return _tapZoomGesture;
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        _longGesture.minimumPressDuration = 0.3;
    }
    return _longGesture;
}

@end
