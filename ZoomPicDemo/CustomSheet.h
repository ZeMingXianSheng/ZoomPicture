//
//  CustomSheet.h
//  ZoomPicDemo
//
//  Created by Rain on 2018/9/11.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomSheetType) {//提示框类型
    CustomSheetTypeDefault,     //默认 标示没有红字
    CustomSheetTypePrompt,      //title 标示有标题
    CustomSheetTypeWarn,        //title 警告标识(红色字体) 显示红字(比如"删除"显示红色)
};

typedef void(^Hidden)(BOOL isHidden);
@interface CustomSheet : UIView

@property (nonatomic, copy) Hidden hidden;

@property (nonatomic, copy) void (^Click)(NSInteger clickIndex);

@property (nonatomic, assign) CustomSheetType sheetType;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr sheetType:(CustomSheetType )sheetType;

- (void)hiddenSheet:(Hidden)hidden;

@end
