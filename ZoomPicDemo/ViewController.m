//
//  ViewController.m
//  ZoomPicDemo
//
//  Created by Rain on 2018/9/11.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import "ViewController.h"
#import "GMZoomImageView.h"

@interface ViewController ()

@property (nonatomic, strong) GMZoomImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.imageView];
}


#pragma mark -- lazy
- (GMZoomImageView *)imageView {
    if (!_imageView) {
        _imageView = [[GMZoomImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, 100, 100, 100)];
        _imageView.image = [UIImage imageNamed:@"WechatIMG2.jpeg"];
    }
    return _imageView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
