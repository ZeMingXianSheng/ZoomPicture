//
//  CustomSheet.m
//  ZoomPicDemo
//
//  Created by Rain on 2018/9/11.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import "CustomSheet.h"

@interface CustomSheet ()
{
    CGSize size;
}
@property (nonatomic, strong) UIView *bgkView;
@end

@implementation CustomSheet
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr sheetType:(CustomSheetType)sheetType {
    self = [super initWithFrame:frame];
    if (self) {
        self.sheetType = sheetType;
        //淡入动画
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromLeft;
        transition.duration = 0.3;
        [self.layer addAnimation:transition forKey:nil];
        
        size = frame.size;
        [self setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSheet:)];
        [self addGestureRecognizer:tap];
        [self makeBaseUIWithTitleArr:titleArr];
    }
   
    return self;
}

- (void)makeBaseUIWithTitleArr:(NSArray *)titleArr {
    self.bgkView = [[UIView alloc] init];
    if (self.sheetType == CustomSheetTypePrompt) {
        _bgkView.frame = CGRectMake(0, size.height, size.width, (titleArr.count - 1) * 50 + 55 + 70);
        NSLog(@"bgView:%@", NSStringFromCGRect(_bgkView.frame));
        CGFloat y = [self createRemindBtnWithTitle:@"取消" origin_y:_bgkView.frame.size.height - 50 tag:- 1 action:@selector(hiddenSheet:) number:0] - 55;
        NSLog(@"y1：%f", y);
        for (int i = 0; i < titleArr.count; i++) {
            y = [self createRemindBtnWithTitle:titleArr[i] origin_y:y tag:i action:@selector(click:) number:titleArr.count];
            NSLog(@"y2: %f", y);
        }
    } else {
        _bgkView.frame = CGRectMake(0, size.height, size.width, titleArr.count * 50 + 55);
        CGFloat y = [self createBtnWithTitle:@"取消" origin_y:_bgkView.frame.size.height - 50 tag:- 1 action:@selector(hiddenSheet:)] - 55;
        for (int i = 0; i < titleArr.count; i++) {
            y = [self createBtnWithTitle:titleArr[i] origin_y:y tag:i action:@selector(click:)];
        }
    }
    [self addSubview:_bgkView];
    _bgkView.backgroundColor = [UIColor colorWithRed:0xe9/255.0 green:0xe9/255.0 blue:0xe9/255.0 alpha:1.0];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bgkView.frame;
        frame.origin.y -= frame.size.height;
        _bgkView.frame = frame;
    }];
}
//常规
- (CGFloat)createBtnWithTitle:(NSString *)title origin_y:(CGFloat)y tag:(NSInteger)tag action:(SEL)method  {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, y, size.width, 49.5);
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.tag = tag;
    if (self.sheetType == CustomSheetTypeDefault) {//标题没有红色提醒
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        if (tag == 0) {//标题第一个为红色提醒 255.0, 59.0, 48.0
            [btn setTitleColor:[UIColor colorWithRed:255.0 / 255.0 green:59.0 / 255.0 blue:48.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [btn addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self.bgkView addSubview:btn];
    return y -= (tag == - 1 ? 0 : 50);
}
//顶部详细描述btn
- (CGFloat)createRemindBtnWithTitle:(NSString *)title origin_y:(CGFloat)y tag:(NSInteger)tag action:(SEL)method number:(NSInteger)number{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.tag = tag;
    if (tag == 0) {
        [btn setTitleColor:[UIColor colorWithRed:255.0 / 255.0 green:59.0 / 255.0 blue:48.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [btn addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self.bgkView addSubview:btn];
    if (tag == -1) {
        btn.frame = CGRectMake(0, y, size.width, 49.5);
        y = y;
    } else {
        if (tag == (number - 1)) {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor colorWithRed:100.0 / 255.0 green:100.0 / 255.0 blue:100.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, y, size.width, 69.5);
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            btn.frame = CGRectMake(0, y, size.width, 49.5);
            if (tag == number - 2) {
                y = y - 70;
            } else {
                y = y - 50;
            }
        }
    }
    return y;
}
//隐藏弹窗
- (void)hiddenSheet:(Hidden)hidden {
    if (self.hidden) {
        self.hidden(YES);
    }
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _bgkView.frame;
        frame.origin.y += frame.size.height;
        _bgkView.frame = frame;
        self.alpha -= 1.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)click:(UIButton *)sender {
    if (self.Click) {
        NSLog(@"tag: %ld", (long)sender.tag);
        _Click(sender.tag);
    }
}

@end
