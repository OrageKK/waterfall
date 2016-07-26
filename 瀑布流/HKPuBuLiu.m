//
//  HKPuBuLiu.m
//  瀑布流
//
//  Created by 黄坤 on 16/4/22.
//  Copyright © 2016年 wzpnyg. All rights reserved.
//

#import "HKPuBuLiu.h"

@interface HKPuBuLiu()
/**
 *  存放collectionView中所有子视图的布局属性
 */
@property (strong, nonatomic) NSMutableArray *attrM;
/**
 *  用来累加每一列的当前cell高度
 */
@property (strong, nonatomic) NSMutableArray *eachColMaxH;
@end

@implementation HKPuBuLiu
/**
 *  准备布局当collectionView即将要显示的时候回来调用,当刷新表格也会来调用此方法做布局前的准备工作(itemSize等)
 */
-(void)prepareLayout{
    //每一次来计算新的cell布局属性之前,先把最后一个footerview的布局属性删除
    [self.attrM removeLastObject];
    //获取当前cell的总个数
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    //新添加的cell个数 = cell的总个数 - 之前布局属性的个数(旧的cell)
    NSInteger newCellCount = cellCount - self.attrM.count;
    //计算新添加的cell的个数
//    NSInteger newCellCount = self.dataList.count - self.attrM.count;
    
    //for循环来创建所有的布局属性
    for (NSInteger i = 0; i<newCellCount; i++) {
        
        //0.创建布局属性所对应的索引
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.attrM.count inSection:0];
        //1.创建布局属性
        UICollectionViewLayoutAttributes *cellAttr =[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //计算cell的宽
        //内容的宽度 = collectionView的宽-左边边距-右边边距
        CGFloat contentW = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        //cell的宽 = (内容的宽 - (列数 - 1) * 最小列间距)/列数
        CGFloat cellW = (contentW - (self.columnCount - 1) *self.minimumInteritemSpacing) / self.columnCount;
        //cellH
        //通过传入cell的真实的宽,和当前要计算cell的索引让代理去计算真实的高 
        CGFloat cellH = [self.delegate HKPuBuLiuScale:self cellW:cellW forIndexPath:indexPath];
        //计算列号
        //获取当前最矮那一列的列号,应该把当前的cell添加到最矮的那一列
        NSInteger col = self.minCol;
        //cellX = 组的左边边距 + (cell的宽 + 列间距) *列号
        CGFloat cellX = self.sectionInset.left + (cellW + self.minimumInteritemSpacing) * col;
        
        //cellY
        //取出当前列的高度来当cell的Y
        CGFloat cellY = [self.eachColMaxH[col] floatValue];
        //如果当前这一列添加了一个cell直接累加这一列的高度
        self.eachColMaxH[col] = @(cellY + cellH +self.minimumLineSpacing);
        
        cellAttr.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        //把当前的布局属性添加到用来保存所有子视图布局属性的数组中
        [self.attrM addObject:cellAttr];
    }
    //添加footerview的布局属性
    NSIndexPath *footerPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerPath];
    //设置footerview的frame
    footerAttr.frame = CGRectMake(0, [self.eachColMaxH[self.maxCol ] floatValue] - self.minimumLineSpacing, self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    [self.attrM addObject:footerAttr];
}

#pragma mark -计算滚动范围contentSize
//如果自己来计算cell的尺寸,一定要重写此方法来返回真是的滚动范围
-(CGSize)collectionViewContentSize{
    return CGSizeMake(0, [self.eachColMaxH[self.maxCol] floatValue] + self.footerReferenceSize.height - self.minimumLineSpacing);
}
//获取最高那一列的列号
- (NSInteger)maxCol{
    //当前最高高度
    CGFloat maxH = 0;
    //当前最高列号
    NSInteger maxCol = 0;
    for (NSInteger i = 0; i<self.columnCount; i++) {
        //如果当前列的高比我的最高高度还高,就记录新高度
        if ([self.eachColMaxH[i]floatValue] > maxH) {
            maxH = [self.eachColMaxH[i] floatValue];
            maxCol = i;
        }
    }
    return maxCol;
}

//获取最矮那一列的列号
- (NSInteger)minCol{
    //当前最矮高度
    CGFloat minH = MAXFLOAT;
    //当前最矮列号
    NSInteger minC = 0;
    for (NSInteger i = 0; i<self.columnCount; i++) {
        //如果当前列的高比我的最矮高度还矮,就记录新高度
        if ([self.eachColMaxH[i]floatValue] < minH) {
            minH = [self.eachColMaxH[i] floatValue];
            minC = i;
        }
    }
    return minC;
}

//此方法返回的是collectionView中所有子视图的索引的frame,而且每一个子视图的frame只会计算一次,
//通过测试我们可以自己修改布局对象中的frame,来改变cell的大小和位置,我们可以自己来计算每一个子视图的frame,计算好之后保存到数组中,最终通过此方法来返回,应该可以实现瀑布流效果
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrM;
}


-(NSMutableArray *)eachColMaxH{
    if (_eachColMaxH == nil) {
        _eachColMaxH = [NSMutableArray arrayWithCapacity:self.columnCount];
        //给累加每一列的数组一个默认值
        for (NSInteger i = 0; i<self.columnCount; i++) {
            _eachColMaxH[i] = @(self.sectionInset.top);
        }
    }
    return _eachColMaxH;
}

#pragma mark - 懒加载
//实例化可变数组,用来存放所有的布局属性
- (NSMutableArray *)attrM{
    if (_attrM == nil) {
        _attrM = [NSMutableArray array];
    }
    return _attrM;
}
@end
