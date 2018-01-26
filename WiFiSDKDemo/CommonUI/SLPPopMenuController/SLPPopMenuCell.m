//
//  SLPPopMenuCell.m
//  Sleepace
//
//  Created by jie yang on 16/12/27.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import "SLPPopMenuCell.h"

@interface SLPPopMenuCell ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *lineView;
@end
@implementation SLPPopMenuCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SLPPopMenuCell";
    SLPPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SLPPopMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        //添加label
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.textColor = SLPThemeColor.C3;
        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.font=SLPThemeFont.T3;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //下边的线
        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = SLPThemeColor.C9;
        [self.contentView addSubview:line];
        self.lineView = line;
        // 3.cell的设置。。。
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setItem:(SLPPopMenuItem *)item
{
    _item = item;
    
    self.titleLabel.text = item.itemtitle;
}

-(void)layoutSubviews
{
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.lineView.frame = CGRectMake(0, self.titleLabel.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
//    if(highlighted)
//        self.contentView.backgroundColor = SLPThemeColor.C8;
//    else
//        self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
