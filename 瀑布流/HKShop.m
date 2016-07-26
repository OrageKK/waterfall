//
//  HKShop.m
//  瀑布流
//
//  Created by 黄坤 on 16/4/20.
//  Copyright © 2016年 wzpnyg. All rights reserved.
//

#import "HKShop.h"

@implementation HKShop
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)shopWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)shopsWithIndex:(NSInteger)index{
    NSString *plistName = [NSString stringWithFormat:@"%zd.plist",index % 3 + 1];
    NSArray *dictArr =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:plistName ofType:nil]];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:dictArr.count];
    for (NSDictionary *dict in dictArr) {
        HKShop *shop = [HKShop shopWithDict:dict];
        [arrM addObject:shop];
        
    }
    return arrM;
}
@end
