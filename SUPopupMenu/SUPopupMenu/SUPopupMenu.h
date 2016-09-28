//
//  SUPopupMenu.h
//  SUPopupMenu
//
//  Created by SU on 16/9/21.
//  Copyright © 2016年 SU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUDropMenuDelegate <NSObject>

@optional
- (void)dropMenuDidTappedAtIndex: (NSInteger)index;

@end

@interface SUPopupMenu : UIView

@property (nonatomic, assign) id <SUDropMenuDelegate> delegate;

- (instancetype)initWithTitles:(NSArray *)titles icons:(NSArray *)icons menuItemSize:(CGSize)itemSize;

- (instancetype)initWithContents:(NSString *)contentString maxWidth:(CGFloat)maxWidth;

- (void)presentWithAnchorPoint: (CGPoint)anchorPoint;

@end
