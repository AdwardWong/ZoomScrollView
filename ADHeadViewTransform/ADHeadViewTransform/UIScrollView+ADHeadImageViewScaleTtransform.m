 //
//  UIScrollView+ADHeadImageViewScaleTtransform.m
//  ADHeaderScaleImageDemo
//
//  Created by AdwardWang on 2016/11/1.
//  Copyright © 2016年 AD. All rights reserved.
//

#import "UIScrollView+ADHeadImageViewScaleTtransform.h"
#import <objc/runtime.h>

#define ADKeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))

/**
 *  分类的目的：实现两个方法实现的交换，调用原有方法，有现有方法(自己实现方法)的实现。
 */
@interface NSObject (MethodSwizzling)

/**
 *  交换对象方法
 *  @param origSelector    原有方法
 *  @param swizzleSelector 现有方法(自己实现方法)
 */
+ (void)AD_swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector;
@end

@implementation NSObject (MethodSwizzling)


+ (void)AD_swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector {
    
    // 获取原有方法
    Method origMethod = class_getInstanceMethod(self,
                                                origSelector);
    // 获取交换方法
    Method swizzleMethod = class_getInstanceMethod(self,
                                                   swizzleSelector);
    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (!isAdd) { // 添加方法失败，表示原有方法存在，直接替换
        method_exchangeImplementations(origMethod, swizzleMethod);
    }else {
        class_replaceMethod(self, swizzleSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
}


@end

// 默认图片高度
static CGFloat const oriImageH = 200;
@implementation UIScrollView (ADHeadImageViewScaleTtransform)

+ (void)load
{
    [self AD_swizzleInstanceSelector:@selector(setTableHeaderView:) swizzleSelector:@selector(setAD_TableHeaderView:)];
}

// 拦截通过代码设置tableView头部视图
- (void)setAD_TableHeaderView:(UIView *)tableHeaderView
{
    // 不是UITableView,就不需要做下面的事情
    if (![self isMemberOfClass:[UITableView class]]) return;
    // 设置tableView头部视图
    [self setAD_TableHeaderView:tableHeaderView];
    // 设置头部视图的位置
    UITableView *tableView = (UITableView *)self;
    self.AD_headerScaleImageHeight = tableView.tableHeaderView.frame.size.height;
    
}

// 懒加载头部imageView
- (UIImageView *)AD_headerImageView
{
    UIImageView *imageView = objc_getAssociatedObject(self, _cmd);
    if (imageView == nil) {
        
        imageView = [[UIImageView alloc] init];
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self insertSubview:imageView atIndex:0];
        
        // 保存imageView
        objc_setAssociatedObject(self, _cmd, imageView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return imageView;
}

// 属性：AD_isInitial
- (BOOL)AD_isInitial
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAD_isInitial:(BOOL)AD_isInitial
{
    objc_setAssociatedObject(self, _cmd, @(AD_isInitial),OBJC_ASSOCIATION_ASSIGN);
}


// 属性： AD_headerImageViewHeight
- (void)setAD_headerScaleImageHeight:(CGFloat)AD_headerScaleImageHeight
{
    objc_setAssociatedObject(self, _cmd, @(AD_headerScaleImageHeight),OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 设置头部视图的位置
    [self setupHeaderImageViewFrame];
}
- (CGFloat)AD_headerScaleImageHeight
{
    CGFloat headerImageHeight = [objc_getAssociatedObject(self, _cmd) floatValue];
    return headerImageHeight == 0?oriImageH:headerImageHeight;
}

// 属性：AD_headerImage
- (UIImage *)AD_headerScaleImage
{
    return self.AD_headerImageView.image;
}

// 1,设置头部imageView的图片
- (void)setAD_headerScaleImage:(UIImage *)AD_headerScaleImage
{
    self.AD_headerImageView.image = AD_headerScaleImage;
    
    // 初始化头部视图
    [self setupHeaderImageView];
    
}

// 2,初始化头部视图
- (void)setupHeaderImageView
{
    
    // 设置头部视图的位置
    [self setupHeaderImageViewFrame];
    
    // KVO监听偏移量，修改头部imageView的frame
    if (self.AD_isInitial == NO) {
        [self addObserver:self forKeyPath:ADKeyPath(self, contentOffset) options:NSKeyValueObservingOptionNew context:nil];
        
        self.AD_isInitial = YES;
        
    }
}



//3, 设置头部视图的位置
- (void)setupHeaderImageViewFrame
{
    self.AD_headerImageView.frame = CGRectMake(0 , 0, self.bounds.size.width , self.AD_headerScaleImageHeight);
   
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    // 获取当前偏移量
    CGFloat offsetY = self.contentOffset.y;
    
    if (offsetY < 0) {
        
        self.AD_headerImageView.frame = CGRectMake(offsetY, offsetY, self.bounds.size.width - offsetY * 2, self.AD_headerScaleImageHeight - offsetY);
        
    } else {
        
        self.AD_headerImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.AD_headerScaleImageHeight);
    }
    
}
- (void)dealloc
{
    if (self.AD_isInitial) { // 初始化过，就表示有监听contentOffset属性，才需要移除
        
        [self removeObserver:self forKeyPath:ADKeyPath(self, contentOffset)];
    }
}



@end
