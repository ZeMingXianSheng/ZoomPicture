//
//  GMZoomImageView.h
//  ZoomPicDemo
//
//  Created by Rain on 2018/9/11.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 TODO 优化点：不放大图片直接长按图片可保存到本地时的，实现成功或失败的弹窗提醒。
 */
@interface GMZoomImageView : UIImageView

- (void)addTapGesture;//添加点击手势

- (void)removeTapGesture;//移除点击手势

//- (void)addLongGesture;//添加长按手势
//
//- (void)removeLongGestrue;//移除长按手势

@end
