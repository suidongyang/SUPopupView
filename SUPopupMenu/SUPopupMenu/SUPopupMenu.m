//
//  SUPopupMenu.m
//  SUPopupMenu
//
//  Created by SU on 16/9/21.
//  Copyright © 2016年 SU. All rights reserved.
//

#import "SUPopupMenu.h"
#import "UIHelper.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation SUPopupMenu {
    
    UIView *_mainView;
    UIView *_contentView;
    UIView *_bgView;
    
    CGPoint _anchorPoint;
    
    CGFloat kArrowHeight;
    CGFloat kArrowWidth;
    CGFloat kArrowPosition; // 箭头朝上时左侧底部的x值
    CGFloat kCornerRadius;
    CGFloat kButtonHeight;
}

- (instancetype)initWithTitles:(NSArray *)titles icons:(NSArray *)icons menuItemSize:(CGSize)itemSize {
    self = [super init];
    if (!self) return nil;
    
    self.width = itemSize.width;
    kButtonHeight = itemSize.height;
    
    kArrowHeight = 10;
    kArrowWidth = 15;
    kArrowPosition = 0.5*self.width - 0.5*kArrowWidth;
    kCornerRadius = 0;
    
    self.height = titles.count * kButtonHeight + 2*kArrowHeight;
    
    [self setupUI];
    
    [self contentViewSetupButtonsWithTitles:titles icons:icons];
    
    return self;
}

- (instancetype)initWithContents:(NSString *)contentString maxWidth:(CGFloat)maxWidth {
    self = [super init];
    if (!self) return nil;
    
    CGFloat edgeMargin = 5;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize: 17 weight: UIFontWeightLight];
    contentLabel.text = contentString;
    contentLabel.width = maxWidth - 2*edgeMargin;
    [contentLabel sizeToFit];
    contentLabel.origin = CGPointMake(edgeMargin, edgeMargin);
    
    self.width = contentLabel.width + 2*edgeMargin < maxWidth ? contentLabel.width + 2*edgeMargin : maxWidth;

    kArrowHeight = 10;
    kArrowWidth = 15;
    kArrowPosition = 0.5*self.width - 0.5*kArrowWidth;
    kCornerRadius = 0;
    
    self.height = contentLabel.height + 2*edgeMargin + 2*kArrowHeight;
    
    [self setupUI];
    
    [_contentView addSubview: contentLabel];
    
    return self;
}

- (void)presentWithAnchorPoint: (CGPoint)anchorPoint {
    
    [self setArrowPointingWhere: anchorPoint];
    _mainView.layer.mask = [self maskLayer];
    
    if (CGRectGetMaxY(self.frame) > kScreenHeight) {
        
        kArrowPosition = self.width - kArrowPosition - kArrowWidth;
        _mainView.layer.mask = [self maskLayer];
        _mainView.layer.mask.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y - self.height;
    }
    
    [self show];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview: _bgView];
    [[UIApplication sharedApplication].keyWindow addSubview: self];
    
    [UIView animateWithDuration: 0.25 animations:^{
        self.y += self.y >= _anchorPoint.y ? 10 : -10;
        self.alpha = 1;
        _bgView.alpha = 0.2;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration: 0.25 animations:^{
        self.y += self.y > _anchorPoint.y ? -5 : 5;
        self.alpha = 0;
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bgView removeFromSuperview];
    }];
}

- (void)setArrowPointingWhere: (CGPoint)anchorPoint {
    _anchorPoint = anchorPoint;
    
    self.x = anchorPoint.x - kArrowPosition - 0.5*kArrowWidth;
    self.y = anchorPoint.y;
    
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    
    if (maxX > kScreenWidth - 10) {
        self.x = kScreenWidth - 10 - self.width;
    }else if (minX < 10) {
        self.x = 10;
    }
    
    maxX = CGRectGetMaxX(self.frame);
    minX = CGRectGetMinX(self.frame);
    
    if ((anchorPoint.x <= maxX - kCornerRadius) && (anchorPoint.x >= minX + kCornerRadius)) {
        kArrowPosition = anchorPoint.x - minX - 0.5*kArrowWidth;
    }else if (anchorPoint.x < minX + kCornerRadius) {
        kArrowPosition = kCornerRadius;
    }else {
        kArrowPosition = self.width - kCornerRadius - kArrowWidth;
    }
}

- (void)contentViewSetupButtonsWithTitles:(NSArray *)titles icons:(NSArray *)icons {
    
    for (int i = 0; i < titles.count; ++i) {
        
        UIButton *itemButton = [[UIButton alloc] init];
        itemButton.size = CGSizeMake(self.width, kButtonHeight);
        itemButton.origin = CGPointMake(0, i*(kButtonHeight+0.5));
        [itemButton setBackgroundImage: [UIImage imageWithColor: [UIColor colorWithHexString: @"f1f1f1"]] forState: UIControlStateHighlighted];
        [itemButton.titleLabel setFont: [UIFont systemFontOfSize: 14]];
        [itemButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [itemButton setTitle: titles[i] forState: UIControlStateNormal];
        [itemButton setImage: icons[i] forState: UIControlStateNormal];
        
        if (icons.count != 0) {
            
            [itemButton setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
            [itemButton setContentEdgeInsets: UIEdgeInsetsMake(0, 10, 0, 0)];
            [itemButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 10, 0, 0)];
        }
        
        [_contentView addSubview: itemButton];
        
        if (i+1 < titles.count) {
            UIView *separator = [[UIView alloc] init];
            separator.frame = CGRectMake(10, (i+1)*kButtonHeight + i*0.5, self.width-20, 0.5);
            separator.backgroundColor = [UIColor colorWithHexString: @"d7d7d7"];
            [_contentView addSubview: separator];
        }
    }
}

- (void)setupUI {
    
    self.alpha = 0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2.0;
    
    _mainView = [[UIView alloc] initWithFrame: self.bounds];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = kCornerRadius;
    _mainView.layer.masksToBounds = YES;
    
    _contentView = [[UIView alloc] initWithFrame: _mainView.bounds];
    _contentView.height -= 2*kArrowHeight;
    _contentView.centerY = 0.5*_mainView.height;
    
    [_mainView addSubview: _contentView];
    [self addSubview: _mainView];
    
    _bgView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0;
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
    [_bgView addGestureRecognizer: tap];
}

- (CAShapeLayer *)maskLayer {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _mainView.bounds;
    
    CGPoint topRightArcCenter = CGPointMake(self.width-kCornerRadius, kArrowHeight+kCornerRadius);
    CGPoint topLeftArcCenter = CGPointMake(kCornerRadius, kArrowHeight+kCornerRadius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width-kCornerRadius, self.height - kArrowHeight - kCornerRadius);
    CGPoint bottomLeftArcCenter = CGPointMake(kCornerRadius, self.height - kArrowHeight - kCornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, kArrowHeight+kCornerRadius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: kCornerRadius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width-kCornerRadius, self.height - kArrowHeight)];
    [path addArcWithCenter: bottomRightArcCenter radius: kCornerRadius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, kArrowHeight+kCornerRadius)];
    [path addArcWithCenter: topRightArcCenter radius: kCornerRadius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    [path addLineToPoint: CGPointMake(kArrowPosition+kArrowWidth, kArrowHeight)];
    [path addLineToPoint: CGPointMake(kArrowPosition+0.5*kArrowWidth, 0)];
    [path addLineToPoint: CGPointMake(kArrowPosition, kArrowHeight)];
    [path addLineToPoint: CGPointMake(kCornerRadius, kArrowHeight)];
    [path addArcWithCenter: topLeftArcCenter radius: kCornerRadius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}

@end
