//
//  HKShop.h
//  瀑布流
//
//  Created by 黄坤 on 16/4/20.
//  Copyright © 2016年 wzpnyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKShop : NSObject
/**
 *  图片
 */
@property (nonatomic,copy) NSString * icon;
/**
 *  价格
 */
@property (nonatomic,copy) NSString * price;
/**
 *  宽
 */
@property (nonatomic,assign) CGFloat width;
/**
 *  高
 */
@property (nonatomic,assign) CGFloat height;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)shopWithDict: (NSDictionary *)dict;
+ (NSArray *)shopsWithIndex:(NSInteger)index;
@end
