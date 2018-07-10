//
//  NearAddressView.m
//  LankeProject
//
//  Created by itman on 16/12/23.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "NearAddressView.h"
#import "BaiduMapHeader.h"

@interface NearAddressView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation NearAddressView


- (UITableView *)table
{
    if (!_table)
    {
        self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.table.backgroundColor=BM_CLEAR;
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table.delegate = self;
        self.table.dataSource = self;
        
    }
    return _table;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        [self addSubview:self.table];
        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearAddressCell *cell=[NearAddressCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.dataSource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sendObject:self.dataSource[indexPath.row]];
}

-(void)loadNearAddressWithDataSource:(NSArray *)dataSource
{
    self.dataSource=dataSource;
    [self.table reloadData];
}

@end

@implementation NearAddressCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NearAddressCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NearAddressCell"];
    if (!cell)
    {
        cell=[[NearAddressCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NearAddressCell"];
    }
    return cell;
}

-(void)createCell
{
    LocalhostImageView *location=[[LocalhostImageView alloc]init];
    [self.contentView addSubview:location];
    location.image=[UIImage imageNamed:@"navigation_bar_location"];
    
    self.name=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    [self.contentView addSubview:self.name];
    
    self.address=[UnityLHClass masonryLabel:@"" font:13.0 color:BM_LIGHTGRAY];
    [self.contentView addSubview:self.address];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(15);

    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-3);
        make.left.mas_equalTo(location.mas_right).offset(15);
        
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(3);
        make.left.mas_equalTo(location.mas_right).offset(15);
        
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(location.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
}


-(void)loadCellWithDataSource:(id)dataSource
{
    BMKPoiInfo *info=(BMKPoiInfo *)dataSource;
    self.name.text=info.name;
    self.address.text=info.address;
}

@end
