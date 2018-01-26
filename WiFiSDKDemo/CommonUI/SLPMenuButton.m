//
//  SLPMenuButton.m
//  Sleepace
//
//  Created by jie yang on 16/12/27.
//  Copyright © 2016年 com.medica. All rights reserved.
//

#import "SLPMenuButton.h"
#define magrin 5

@interface SLPMenuButton ()
@property (nonatomic,strong)UILabel *contenetLabel;
@property (nonatomic,strong)UIImageView *arrowView;
@end
@implementation SLPMenuButton

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        _titleColor =  [UIColor colorWithRed:38/255.0 green:52/255.0f blue:68/255.0f alpha:1.0];
        _font = [UIFont systemFontOfSize:17];
        _alignment = NSTextAlignmentCenter;
        _image = [UIImage imageNamed:@"sdk_icon_nav_downarrow.png"];
        [self setupContentLabel];
        [self setupArrowView];
    }
    
    return self;
}

- (void)setupContentLabel
{
    self.contenetLabel = [[UILabel alloc] init];
    self.contenetLabel.textColor = _titleColor;
    self.contenetLabel.font = _font;
    self.contenetLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.contenetLabel];
}

- (void)setupArrowView
{
    self.arrowView = [[UIImageView alloc] initWithImage:_image];
    [self addSubview:self.arrowView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustLayout];
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected) {
        [self setArrowDirectionUp];
    }else{
        [self setArrowDirectionDown];
    }
}

#pragma mark ------------ setter ----------
- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor != titleColor) {
        
        _titleColor = titleColor;
        
        self.contenetLabel.textColor = titleColor;
    }
}

- (void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
        self.contenetLabel.font = font;
       [self adjustLayout];
    }
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    if (_alignment != alignment) {
        _alignment = alignment;
        [self adjustLayout];
    }
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        self.arrowView.image= image;
        [self adjustLayout];
    }
}
#pragma mark ------------ 私有方法 ----------

/**
 *  根据内容调整位置
 */
- (void)adjustLayout
{
    //计算文本的长度
    CGFloat arrowW = self.arrowView.frame.size.width;
    CGFloat arrowH = self.arrowView.frame.size.height;
    
    CGFloat contentMaxW = self.frame.size.width - magrin * 3 - arrowW; ///文本的最大宽度
    
    NSMutableDictionary *contentdic = [NSMutableDictionary dictionary];
    contentdic[NSFontAttributeName] = _font;
    
    CGRect rect = [_title boundingRectWithSize:CGSizeMake(contentMaxW, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentdic context:nil];
    CGFloat totalW = rect.size.width + magrin + arrowW; /// 文本和箭头总的宽度
    CGFloat leftMagrin = (self.bounds.size.width - totalW) * 0.5;
    switch (_alignment) {
        case NSTextAlignmentLeft:
            leftMagrin = 0;
            break;
            case NSTextAlignmentCenter:
            leftMagrin = (self.bounds.size.width - totalW) * 0.5;
            break;
            case NSTextAlignmentRight:
            leftMagrin = self.bounds.size.width - totalW;
            break;
        default:
            break;
    }
    self.contenetLabel.frame = CGRectMake(leftMagrin, 0, rect.size.width, self.bounds.size.height);
    self.arrowView.frame = CGRectMake(CGRectGetMaxX(self.contenetLabel.frame)+ magrin, (self.bounds.size.height - arrowH) / 2, arrowW, arrowH);
    self.contenetLabel.text = _title;
}

- (void)refreshWithTitle:(NSString *)title
{
    _title = title;
    [self adjustLayout];
}

- (void)setArrowDirectionUp
{
    self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)setArrowDirectionDown
{
    self.arrowView.transform = CGAffineTransformIdentity;
}
#pragma mark --------------- 点击方法 ----------------
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.selected = !self.selected;
    
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

@end
