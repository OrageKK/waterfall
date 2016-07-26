//
//  HKPuBuLiu.h
//  瀑布流
//
//  Created by 黄坤 on 16/4/22.
//  Copyright © 2016年 wzpnyg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKPuBuLiu;
@protocol HKPuBuLiuDelegate<NSObject>

@required
- (CGFloat)HKPuBuLiuScale:(HKPuBuLiu *)layout cellW:(CGFloat)cellW
             forIndexPath: (NSIndexPath *)indexPath;

@end

@interface HKPuBuLiu : UICollectionViewFlowLayout

@property (weak, nonatomic) id<HKPuBuLiuDelegate> delegate;
/**
 *  列数
 */
@property (nonatomic,assign) NSInteger columnCount;

@end
