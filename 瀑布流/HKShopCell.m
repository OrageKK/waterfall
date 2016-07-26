//
//  HKShopCell.m
//  瀑布流
//
//  Created by 黄坤 on 16/4/20.
//  Copyright © 2016年 wzpnyg. All rights reserved.
//

#import "HKShopCell.h"
#import "HKShop.h"
@interface HKShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceView;

@end


@implementation HKShopCell
-(void)setShop:(HKShop *)shop{
    _shop = shop;
    self.imageView.image = [UIImage imageNamed:shop.icon];
    self.priceView.text = shop.price; 
}
@end
