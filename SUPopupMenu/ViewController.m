//
//  ViewController.m
//  SUPopupMenu
//
//  Created by SU on 16/9/21.
//  Copyright © 2016年 SU. All rights reserved.
//

#import "ViewController.h"
#import "UIHelper.h"
#import "SUPopupMenu.h"

@implementation ViewController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView: self.view];
    
    UIView *pin = [[UIView alloc] init];
    pin.backgroundColor = [UIColor blackColor];
    pin.size = CGSizeMake(10, 10);
    pin.center = p;
    pin.layer.cornerRadius = 5;
    pin.clipsToBounds = YES;
    
    [self.view addSubview: pin];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration: 0.5 animations:^{
            pin.alpha = 0;
        } completion:^(BOOL finished) {
            [pin removeFromSuperview];
        }];
    });
    
    
    SUPopupMenu *popupView;
    int n = 5;
    if (n % 2) {
        NSArray *icons = @[[UIImage imageNamed: @"ic_bianji_nor"], [UIImage imageNamed: @"ic_shanchu_nor"], [UIImage imageNamed: @"ic_lishi_nor"]];
        NSArray *titles = @[@"修改", @"删除", @"认证历史"];
        
        popupView = [[SUPopupMenu alloc] initWithTitles: titles icons: nil menuItemSize:CGSizeMake(110, 44)];
        
    }else {
        popupView = [[SUPopupMenu alloc] initWithContents: @"明月几时有 把酒问青天 不知天上宫阙 今夕是何年 明月几时有 把酒问青天 不知天上宫阙 今夕是何年 明月几时有 把酒问青天 不知天上宫阙 今夕是何年 明月几时有 把酒问青天 不知天上宫阙 今夕是何年明月几时有 把酒问青天 不知天上宫阙 今夕是何年" maxWidth: 300];
    }

    [popupView presentWithAnchorPoint: p];
}

@end
