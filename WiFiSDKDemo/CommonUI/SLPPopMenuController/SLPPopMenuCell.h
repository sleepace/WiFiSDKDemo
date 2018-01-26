//
//  SLPPopMenuCell.h
//  Sleepace
//
//  Created by jie yang on 16/12/27.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPPopMenuItem.h"

@interface SLPPopMenuCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SLPPopMenuItem *item;

@end
