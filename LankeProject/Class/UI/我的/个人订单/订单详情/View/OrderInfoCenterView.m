//
//  OrderInfoCenterView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "OrderInfoCenterView.h"
#import "FoodOrderStatusViewModel.h"

@interface OrderInfoCenterView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *tableArray;


@end

@implementation OrderInfoCenterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.table.bounces=NO;
        self.table.scrollEnabled=NO;
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.backgroundColor=BM_CLEAR;
        [self addSubview:self.table];
        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        

    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13.0];
        cell.detailTextLabel.textColor=BM_Color_GrayColor;
        cell.backgroundColor=BM_CLEAR;

    }
    NSDictionary *data=self.tableArray[indexPath.row];
    cell.textLabel.text=data[@"dishesName"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"¥%.2f x%@",[data[@"dishesPrice"] floatValue],data[@"dishesNum"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)loadViewWithReservationOrderInfo:(NSDictionary *)dataSource;
{
    CGFloat rowHight=[self tableView:self.table heightForRowAtIndexPath:nil];
    UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, rowHight)];
    UILabel *titleLb=[UnityLHClass masonryLabel:@"预定" font:15.0 color:BM_BLACK];
    [tableHeaderView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tableHeaderView.mas_centerY);
        make.left.mas_equalTo(15);
    }];
    
    self.table.tableHeaderView=tableHeaderView;
    self.tableArray=dataSource[@"orderDishesList"];
    [self.table reloadData];
    float hight=(self.tableArray.count+1)*rowHight;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hight);
    }];
    
    
    
}
-(void)loadViewWithDatasource:(NSDictionary *)dataSource
{
    self.tableArray=dataSource[@"orderDishesList"];
    [self.table reloadData];
    float hight=self.tableArray.count*[self tableView:self.table heightForRowAtIndexPath:nil];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hight);
    }];
}

@end
