//
//  UIScrollView+ADHeadImageViewScaleTtransform.h
//  ADHeaderScaleImageDemo
//
//  Created by AdwardWang on 2016/11/1.
//  Copyright © 2016年 AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ADHeadImageViewScaleTtransform)

/**
 *  头部缩放视图图片
 */
@property (nonatomic, strong) UIImage *AD_headerScaleImage;

/**
 *  头部缩放视图图片高度
 */
@property (nonatomic, assign) CGFloat AD_headerScaleImageHeight;

@end
