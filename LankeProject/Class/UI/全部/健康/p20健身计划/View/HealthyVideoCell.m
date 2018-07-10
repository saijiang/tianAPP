//
//  HealthyVideoCell.m
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//
 #import <MediaPlayer/MediaPlayer.h>
#import "HealthyVideoCell.h"
#import "AdvDetailViewController.h"

@interface HealthyVideoCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *videoView;
@property(nonatomic,strong)NSArray *videoArray;

@end

@implementation HealthyVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    HealthyVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HealthyVideoCell"];
    if (!cell)
    {
        cell=[[HealthyVideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HealthyVideoCell"];
    }
    return cell;
    
}

-(void)createCell
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [self configFlowLayout:layout];
    self.videoView=[[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
    self.videoView.dataSource = self;
    self.videoView.delegate = self;
    self.videoView.backgroundColor = [UIColor whiteColor];
    [self.videoView registerClass:[HealthyVideoCollectionCell class] forCellWithReuseIdentifier:@"HealthyVideoCollectionCell"];
    [self.contentView addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
 
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (void) configFlowLayout:(UICollectionViewFlowLayout *)layout
{
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    CGFloat height =100;
    CGFloat width = 100*2;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    HealthyVideoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HealthyVideoCollectionCell" forIndexPath:indexPath];
    [cell loadCellWithDataSource:self.videoArray[indexPath.row]];
    return cell;
    
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data=self.videoArray[indexPath.section];
    AdvDetailViewController *adv=[[AdvDetailViewController alloc]init];
    adv.externalUrl=data[@"liveAddress"];
    adv.advType=3;
    adv.title=data[@"title"];
    [self.topViewController.navigationController pushViewController:adv animated:YES];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    self.videoArray=dataSource;
    [self.videoView reloadData];
}

@end

@interface HealthyVideoCollectionCell ()

@property(nonatomic,strong)NetworkImageView *videoIcon;
@property(nonatomic,strong)UILabel *videoName;

@end
@implementation HealthyVideoCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    
    return  self;
}
-(void)createUI
{
    self.videoName=[UnityLHClass masonryLabel:@"健身直播1" font:14.0 color:BM_BLACK];
    [self addSubview:self.videoName];
    self.videoName.textAlignment=NSTextAlignmentCenter;
    [self.videoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    self.videoIcon=[[NetworkImageView alloc]init];
    self.videoIcon.image=[UIImage imageNamed:@"category_background_vedio"];
    [self addSubview:self.videoIcon];
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.videoName.mas_top).offset(-5);
        
    }];
    
    LocalhostImageView *videoIcon=[[LocalhostImageView alloc]init];
    videoIcon.image=[UIImage imageNamed:@"Health-videoicon"];
    [self.videoIcon addSubview:videoIcon];
    [videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.videoIcon);
    }];

}
-(void)loadCellWithDataSource:(id)dataSource
{
    self.videoName.text=dataSource[@"title"];
    [self.videoIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"liveImage"]]];

}

@end
