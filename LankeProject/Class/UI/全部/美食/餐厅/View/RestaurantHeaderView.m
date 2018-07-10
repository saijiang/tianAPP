//
//  RestaurantHeaderView.m
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestaurantHeaderView.h"
#import "CSStickyHeaderFlowLayout.h"
@interface RestaurantHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataArr;
@end

@implementation RestaurantHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.dataArr=@[
                   @{@"icon":@"ding_huoguo",
                     @"name":@"火锅",
                     @"eName":@"HOT POT",
                     @"tag":@"01",
                     },
                   @{@"icon":@"ding_shaokao",
                     @"name":@"烧烤",
                     @"eName":@"BARECUE",
                     @"tag":@"02",
                     },
                   @{@"icon":@"ding_jiazhecai",
                     @"name":@"江浙菜",
                     @"eName":@"JIANGZHE CUISINE",
                     @"tag":@"03",
                     },
                   @{@"icon":@"ding_chuancai",
                     @"name":@"川菜",
                     @"eName":@"SICHUAN CUISINE",
                     @"tag":@"04",
                     },
                   @{@"icon":@"ding_kuaican",
                     @"name":@"快餐",
                     @"eName":@"FAST FOOD",
                     @"tag":@"05",
                     },
                   @{@"icon":@"ding_jiachangcai",
                     @"name":@"家常菜",
                     @"eName":@"HOME DISHES",
                     @"tag":@"06",
                     },
                   @{@"icon":@"ding_xican",
                     @"name":@"西餐",
                     @"eName":@"WESTERN FOOD",
                     @"tag":@"07",
                     },
                   @{@"icon":@"ding_zizhucan",
                     @"name":@"自助餐",
                     @"eName":@"BUFFET",
                     @"tag":@"08",
                     },
                   ];
    CSStickyHeaderFlowLayout * layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.disableStickyHeaders=YES;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_HEIGHT(self)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical=NO;
    self.collectionView.backgroundColor=BM_WHITE;
    [self.collectionView registerClass:[RestaurantHeaderViewCell class]
            forCellWithReuseIdentifier:@"RestaurantHeaderViewCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
    }];
    
    //划线
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.collectionView.mas_centerY);
        make.height.mas_equalTo(1);
        
    }];
    
    for (int i=0; i<3; i++)
    {
        UIView *line=[[UIView alloc]init];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(DEF_WIDTH(self)/4.0*(i+1));
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(1);

        }];
    }

}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RestaurantHeaderViewCell *cell=(RestaurantHeaderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantHeaderViewCell" forIndexPath:indexPath];
    [cell loadCellWithDataSource:self.dataArr[indexPath.row]];
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(DEF_WIDTH(self)-3.0)/4.0-0.5;
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


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bRestaurantIndex) {
        self.bRestaurantIndex(self.dataArr[indexPath.row][@"id"]);
    }
}

- (void) config:(id)data{
    
    self.dataArr = data;
    [self.collectionView reloadData];
}


@end

@implementation RestaurantHeaderViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor=BM_WHITE;
        self.icon=[[LocalhostImageView alloc]init];
        [self.contentView addSubview:self.icon];
        
        self.name=[UnityLHClass masonryLabel:@"" font:13.0 color:BM_BLACK];
        self.name.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        
        self.eName=[UnityLHClass masonryLabel:@"" font:9.0 color:BM_BLACK];
        self.eName.textAlignment=NSTextAlignmentCenter;
        self.eName.hidden = YES;
        [self.contentView addSubview:self.eName];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(self.icon.mas_width);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
    [self.eName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    
    [self.icon sd_setImageWithURL:dataSource[@"restaurantClassImage"] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dataSource[@"restaurantClassName"];
//    self.eName.text=dataSource[@"eName"];

}

-(void)loadMallCellWithDataSource:(id)dataSource
{
    NSString*str=dataSource[@"name"];
    if (![str isEqualToString:@"京东"]&&[dataSource[@"icon"] isKindOfClass:[NSURL class]]

    ) {
         [self.icon sd_setImageWithURL:dataSource[@"icon"] placeholderImage:[UIImage imageNamed:@"default_dishes"]];

    }else{
        
        
        self.icon.image=[UIImage imageNamed:dataSource[@"icon"]];

    }
    
//    if ([dataSource[@"icon"] isKindOfClass:[NSURL class]])
//    {
//        [self.icon sd_setImageWithURL:dataSource[@"icon"] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
// 
//    }
//    else
//    {
//        self.icon.image=[UIImage imageNamed:dataSource[@"icon"]];
//    }
    self.name.text=dataSource[@"name"];
    self.eName.text=dataSource[@"eName"];
    
}

@end
