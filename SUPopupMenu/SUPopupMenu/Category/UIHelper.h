//
//  UIHelper.h
//  SUPopupMenu
//
//  Created by SU on 16/9/23.
//  Copyright © 2016年 SU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIHelper : NSObject

@end

@interface UIColor (Convertor)

+ (instancetype)colorWithHexString:(NSString *)hexString;

@end

@interface UIImage (Convertor)

+ (instancetype)imageWithColor:(UIColor *)color;
+ (instancetype)imageWithHexString:(NSString *)hexString;

@end

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGPoint origin;

@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize  size;

@end



