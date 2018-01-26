//
//  SLPPopMenuViewController.m
//  Sleepace
//
//  Created by jie yang on 16/12/27.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import "SLPPopMenuViewController.h"


#define Kheight 55
#define KbottomMagin 55

@interface SLPPopMenuViewController () <UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,nonnull,strong)UITableView *tableView;
@property (nonatomic,nonnull,strong)UIView *coverView;
@end

@implementation SLPPopMenuViewController

- (instancetype)initWithDataSource:(NSArray *)dataSource fromView:(UIView *)fromView
{
    self = [super init];
    
    if (self) {
        
        _dataSource = dataSource;
        _fromView = fromView;
    }
    
    return self;
}

- (void )setTopHeight:(CGFloat)topHeight
{
    if (_topHeight != topHeight) {
        _topHeight = topHeight;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setupCoverView];
    [self setupTableView];
   
    
    [self adjustViewFrame];
    
    
}

#pragma mark ------------- 初始化控件 -------------
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self.tableView setBackgroundColor:SLPThemeColor.C8];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}

- (void)setupCoverView
{
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [self.view addSubview:self.coverView];
}


- (void)reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark ------------- 私有方法 ---------------

/**
 *  根据数据源调整tableview的高度
 */
- (void)adjustViewFrame
{
    //根据来源的控件计算位置
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    CGRect rect = [window convertRect:_fromView.frame fromView:_fromView.superview];
    
    CGFloat y = rect.origin.y + rect.size.height+_topHeight;
    CGFloat x = 0.0;
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = [self getTableViewHeightWithTop:y];
    
    self.tableView.frame = CGRectMake(x, y, w, h);
    self.coverView.frame = CGRectMake(0, y, self.tableView.frame.size.width, self.view.bounds.size.height - y);
    
}
- (CGFloat)getTableViewHeightWithTop:(CGFloat)top
{
    CGFloat retHeight = 0;
    CGFloat H = self.view.bounds.size.height;
    CGFloat maxH = H - top; //最大的高度
    CGFloat dataH = _dataSource.count * Kheight; // 数据的高度
    
    if (dataH >= maxH) {
        
        retHeight = maxH;
    }
    else {
        
        retHeight = dataH ;
    }
    
    return retHeight;
    
}


#pragma mark ------------- tableview delegate/ dataSource  ----------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Kheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"cellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
    }
    cell.textLabel.text = [(SLPPopMenuItem *)_dataSource[indexPath.row] itemtitle];
    cell.textLabel.textColor = [UIColor colorWithRed:38/255.0 green:52/255.0f blue:68/255.0f alpha:1.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SLPPopMenuItem *item = _dataSource[indexPath.row];
    if (item) {
        __weak typeof(self) weakSelf = self;

        if (weakSelf.didSelectedItemBlock) {
            weakSelf.didSelectedItemBlock(item);
        }
    }
}
#pragma mark ----------------- 重写点击事件 -------------

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    
    //计算点击的区域
    CGPoint touchPoint = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.tableView.frame, touchPoint)) {
        
        if (self.dissBlock) {
            self.dissBlock(nil);
        }
    }
}
@end
