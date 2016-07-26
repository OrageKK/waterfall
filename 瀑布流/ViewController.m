//
//  ViewController.m
//  瀑布流
//
//  Created by 黄坤 on 16/4/20.
//  Copyright © 2016年 wzpnyg. All rights reserved.
//

#import "ViewController.h"
#import "HKShop.h"
#import "HKShopCell.h"
#import "HKfooterView.h"
#import "HKPuBuLiu.h"
@interface ViewController ()<HKPuBuLiuDelegate>
@property (weak, nonatomic)HKfooterView *footerView;

@property (strong, nonatomic) NSMutableArray *shops;
/**
 *  用来记录当前加载了几次
 */
@property (nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet HKPuBuLiu *flowLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //给布局对象设置代理
    self.flowLayout.delegate = self;
    //设置默认几列
    self.flowLayout.columnCount = 3;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.index = 0;
    //一启动就加载一次数据
    [self loadData];
}


-(CGFloat)HKPuBuLiuScale:(HKPuBuLiu *)layout cellW:(CGFloat)cellW forIndexPath:(NSIndexPath *)indexPath{
    HKShop *shop =self.shops[indexPath.item];
    return shop.height / shop.width *cellW;
}
//专业加载数据
- (void)loadData{
    //通过传入一个索引读取plist,并把plist中的字典数组转换为模型数组
  NSArray *modelArr = [HKShop shopsWithIndex:self.index];
    //把数组中的每一个对象添加到shops这个数组中
    [self.shops addObjectsFromArray:modelArr];
    //让索引累加
    self.index++;
    //给布局对象中的数据列表属性传数据过去
//    self.flowLayout.dataList = self.shops;
}

#pragma mark - 数据源
//返回每一组有多少个格子
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shops.count;
}
//返回每一组的每一个格子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shop" forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}
//返回每一组的头部和尾部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //获取或创建footerview
    HKfooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    self.footerView = footerView;
    return footerView;
    
}
//只要在滚动中就会来调用此方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //如果footerview还没有出来,或风火轮正在转"正在加载数据"什么也不做
    if (self.footerView == nil ||self.footerView.activity.isAnimating == YES) {
        return;
    }else{
        //footerView完全出现后才去加载更多
        if(self.collectionView.contentOffset.y + self.collectionView.bounds.size.height >self.footerView.frame.origin.y){
            //让花花旋转
            [self.footerView.activity startAnimating];
            //开启延迟两秒之后再去加载,模拟网络延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //1.加载更多数据
                [self loadData];
                //2.刷新表格让数据源方法重新调用
                [self.collectionView reloadData];
                //3.让花花停止转动
                [self.footerView.activity stopAnimating];
                //4.把footerview属性设置为nil
                self.footerView = nil;
            });
        }
        NSLog(@"我要加载更多了");
    }
}

-(NSMutableArray *)shops{
    if (_shops == nil) {
        
        _shops = [NSMutableArray array];
    }
    return _shops;

}
@end
