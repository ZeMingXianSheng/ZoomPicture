//
//  CustomSheet.h
//  ZoomPicDemo
//
//  Created by Rain on 2018/9/11.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Hidden)(BOOL isHidden);
@interface CustomSheet : UIView
@property (nonatomic, copy) Hidden hidden;
@property (nonatomic, copy) void (^Click)(NSInteger clickIndex);
//titleFlag: == 1 标示有标题 2:标示没有红字  titleFlag:传 @"":显示红字(比如"删除"显示红色)
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr titleFlag:(NSString *)titleFlag;
- (void)hiddenSheet:(Hidden)hidden;

@end
