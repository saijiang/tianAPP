//
//  ModuleCell.m
//  DDXGProject
//
//  Created by itman on 16/1/22.
//  Copyright (c) 2016年 张涛. All rights reserved.
//

#import "ModuleCell.h"
#import "RestaurantHeaderView.h"

@implementation ModuleCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        dataSource=[[NSMutableArray alloc]init];
        //布局
        layout = [[UICollectionViewFlowLayout alloc]init];
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //最小间距
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing=0;
        //滚动方向
        //间距
        //初始化collectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.pagingEnabled=YES;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[ModelCollectionViewCell class] forCellWithReuseIdentifier:@"ModelCollectionViewCell"];
        
        page=[[MyPageControlView alloc]initWithFrame:CGRectMake(0, frame.size.height-20, DEF_SCREEN_WIDTH, 20)];
        page.backgroundColor=BM_WHITE;
        page.imagePageStateNormal=[UIImage imageNamed:@"mall_point3"];
        page.imagePageStateHighlighted=[UIImage imageNamed:@"mall_point4"];
        [self addSubview:page];
        //校验page
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewDidScroll:_collectionView];

        });
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
    page.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
    [_collectionView reloadData];

}

#pragma mark - ================= 代理回调方法 ===============

#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return page.numberOfPages;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ModelCollectionViewCell";
    ModelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell loadCellWithDataSource:dataSource[indexPath.section]];
    [cell didSelectItemAtIndexPathBlock:^(NSInteger indexPathrow)
    {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(moduleCell:didSelectIndex:)])
        {
            //每个分组显示八个
            [self.delegate moduleCell:self didSelectIndex:indexPath.section*8+indexPathrow];
        }
    }];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    page.currentPage=scrollView.contentOffset.x/DEF_WIDTH(self);

}
-(void)loadCellWithDataSource:(NSArray *)data
{
   
    [dataSource removeAllObjects];
    if (data.count%8>0)
    {
         page.numberOfPages=data.count/8+1;
        [page setCurrentPage:0];

    }
    else
    {
         page.numberOfPages=data.count/8;
        [page setCurrentPage:0];

    }
    for (int i=0; i<page.numberOfPages; i++)
    {
        NSMutableArray *sectionArr=[[NSMutableArray alloc]init];
        for (int j=0; j<8; j++)
        {
            if (i*8+j<data.count)
            {
                [sectionArr addObject:data[i*8+j]];
            }
        }
        [dataSource addObject:sectionArr];
    }

    [_collectionView reloadData];
}
@end

@implementation ModelCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        dataSource=[[NSMutableArray alloc]init];
        
        //布局
        layout = [[UICollectionViewFlowLayout alloc]init];
        //滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //最小间距
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing=0;
        //滚动方向
        //间距
        //初始化collectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.pagingEnabled=YES;
        _collectionView.bounces=NO;
        _collectionView.backgroundColor=BM_WHITE;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[RestaurantHeaderViewCell class] forCellWithReuseIdentifier:@"RestaurantHeaderViewCell"];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
//        //划线
//        UIView *line=[[UIView alloc]init];
//        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
//        [self addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.centerY.mas_equalTo(_collectionView.mas_centerY);
//            make.height.mas_equalTo(1);
//            
//        }];
//        
//        for (int i=0; i<3; i++)
//        {
//            UIView *line=[[UIView alloc]init];
//            line.backgroundColor=[UIColor groupTableViewBackgroundColor];
//            [self addSubview:line];
//            [line mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(DEF_WIDTH(self)/4.0*(i+1));
//                make.top.mas_equalTo(20);
//                make.bottom.mas_equalTo(-20);
//                make.width.mas_equalTo(1);
//                
//            }];
//        }

        
    }
    return self;
}
#pragma mark - ================= 代理回调方法 ===============

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RestaurantHeaderViewCell";
    RestaurantHeaderViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell loadMallCellWithDataSource:dataSource[indexPath.row]];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(DEF_WIDTH(self)-5.0)/4.0-0.5;
    CGSize itemSize = CGSizeMake(width, width+30);
    return  itemSize;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumInteritemSpacing = 1.0f;
    return minimumInteritemSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    CGFloat minimumLineSpacing = 1.0f;
    return minimumLineSpacing;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.didSelectItemAtIndexPathBlock)
    {
        self.didSelectItemAtIndexPathBlock(indexPath.row);
    }
    
}
-(void)didSelectItemAtIndexPathBlock:(didSelectItemAtIndexPath)selectItemAtIndexPathBlock
{
    self.didSelectItemAtIndexPathBlock=[selectItemAtIndexPathBlock copy];
}
-(void)loadCellWithDataSource:(NSArray *)data
{
    [dataSource removeAllObjects];
    [dataSource addObjectsFromArray:data];
    [_collectionView reloadData];
}
@end

