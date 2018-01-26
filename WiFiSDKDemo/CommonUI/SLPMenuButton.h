//
//  SLPMenuButton.h
//  Sleepace
//
//  Created by jie yang on 16/12/27.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPMenuButton : UIView

/**
 *  显示的文本数据
 */
@property (nonatomic,assign)BOOL selected;

/**
 *  显示的文本数据
 */
@property (nonatomic,nullable,copy,readonly)NSString *title;

/**
 *  文本字体颜色
 */
@property (nonatomic,nullable,strong)UIColor *titleColor;

/**
 *  文本字体
 */
@property (nonatomic,strong)UIFont * _Nullable font;

/**
 *  文本位置
 */
@property (nonatomic,assign)NSTextAlignment alignment;

/**
 *  image
 */
@property (nonatomic,strong)UIImage *image;

/**
 *  点击的回调
 */
@property (nonatomic,nullable,copy)void(^clickedBlock)();

/**
 *  扩展数据，是该控件拥有携带数据的能力
 */
@property (nonatomic,nullable,strong)id extend;
/**
 *  初始化，制作最基础的初始化，可以用下边的属性进行更多设置
 *
 *  @param title 文本标题
 *
 *  @return 实例
 */
- (instancetype _Nonnull)initWithTitle:(NSString * _Nullable)title;

/**
 *  根据标题刷新数据
 *
 *  @param title 新的标题文本
 */
- (void)refreshWithTitle:(NSString * _Nullable)title;

/**
 *  扩展方法，控制箭头的方向
 */
- (void)setArrowDirectionUp;
- (void)setArrowDirectionDown;

@end
