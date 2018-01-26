//
//  SLPPopMenuViewController.h
//  Sleepace
//
//  Created by jie yang on 16/12/27.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPPopMenuCell.h"


@interface SLPPopMenuViewController : UIViewController

/**
 *  数据源数组
 */
@property (nonatomic,strong,nonnull,readonly)NSArray *dataSource;

/**
 *  控件将要展示在哪个控件的下边
 */
@property (nonatomic,strong,nonnull,readonly)UIView *fromView;

@property (nonatomic,assign) CGFloat topHeight;///top to fromview

/**
 *  文本字体颜色
 */
@property (nonatomic,nullable,strong)UIColor *titleColor;

/**
 *  文本字体
 */
@property (nonatomic,nullable,strong)UIFont *font;

/**
 *  文本位置
 */
@property (nonatomic,assign)NSTextAlignment alignment;


/**
 *  点击了取消的回调
 */
@property (nonatomic,copy,nullable)void(^dissBlock)(SLPPopMenuItem *_Nullable item );
/**
 *  选中了某一项的回调
 */
@property (nonatomic,copy,nullable)void(^didSelectedItemBlock)(SLPPopMenuItem *_Nullable item );
/**
 *  初始化方法,初始化必须使用此方法
 *
 *  @param dataSource 数据源，是一个数组
 *  @param fromView   展示在哪个控件的下方
 */
- (instancetype _Nonnull)initWithDataSource:(NSArray * _Nonnull)dataSource fromView:(UIView * _Nonnull)fromView;

- (void)reloadTableView;

@end
