//
//  YEBannerViewController.h
//  BannerTry
//
//  Created by yangyunen on 16/5/19.
//  Copyright © 2016年 yangyunen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YEBannerViewController : UIViewController

@property (strong, nonatomic) UIScrollView *bannerSV;

- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images;

@end
