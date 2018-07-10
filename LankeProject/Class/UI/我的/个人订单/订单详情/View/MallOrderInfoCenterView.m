//
//  MallOrderInfoCenterView.m
//  LankeProject
//
//  Created by itman on 17/1/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallOrderInfoCenterView.h"

#import "JDShopGoodsDetailViewController.h"
#import "SelfSupportGoodsDetailViewController.h"
#import "GroupBuyDetailViewController.h"

@interface MallOrderInfoCenterView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *tableArray;
@property(nonatomic,strong)NSString *stateStr;

@property(nonatomic,strong)GoodsOrderStatusViewModel *viewModel;

@end

@implementation MallOrderInfoCenterView

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

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section<self.tableArray.count-1)
//    {
//        return 10;
//    }
//    return 0.01;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallOrderInfoCenterCell *cell=[MallOrderInfoCenterCell cellWithTableView:tableView];
    if (self.viewModel.isJDShop)
    {
        
        //stare订单状态01 待付款 02 已付款，待收货 03 妥投 04拒收 05 已取消

        [cell loadJDShopViewWithDatasource:self.tableArray[indexPath.row]];
        if ([self.viewModel.orderData[@"state"] integerValue]==3)
        {
            if ([cell.refund.titleLabel.text isEqualToString:@"售后已完成"]) {
                cell.refund.enabled=NO;

            }else{
                cell.refund.enabled=YES;
            }
            cell.refund.hidden=NO;
        }
        else
        {
            cell.refund.hidden=YES;
        }
        
    }
    else if (self.viewModel.isGroupGoods)
    {
       //orderState 	String 	订单状态（01：未成团 ，02：待商家确认， 03：未成团 ， 04：待发货，05：待收货 ，06：已完成 ）
        [cell loadCellWithGroupDataSource:self.tableArray[indexPath.row]];
        if ([self.viewModel.orderData[@"orderState"] integerValue]==5)
        {
            cell.refund.hidden=NO;
        }
        else
        {
            cell.refund.hidden=YES;
        }
    }
    else if (self.viewModel.isOneNumberShop)
    {
        //orderState 	String 	订单状态（01：未成团 ，02：待商家确认， 03：未成团 ， 04：待发货，05：待收货 ，06：已完 //orderStatus 	string 	订单状态（3-未支付 4-已支付 20-已出库 24-已收货 34-已取消 35-已完成 37-送货失败 38-待发货）
        [cell loadOneShopViewWithDatasource:self.tableArray[indexPath.row]];
        
        if ([self.viewModel.orderData[@"orderStatus"] integerValue]==24)
        {
            cell.refund.hidden=NO;
        }
        else
        {
            cell.refund.hidden=YES;
        }
    }
    else
    {
        [cell loadCellWithDataSource:self.tableArray[indexPath.row]];
        //订单状态（01：已取消 ， 02：待付款 ， 03：待发货 ， 04：待收货， 05：待评价 ，06：已完成 ）
        if ([self.viewModel.orderData[@"orderState"] integerValue]==4)
        {
            cell.refund.hidden=NO;
        }
        else
        {
            cell.refund.hidden=YES;
        }

    }
    [cell receiveObject:^(id object) {
        [self sendObject:@(indexPath.row)];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  
    if (self.viewModel.isJDShop)
    {
        JDShopGoodsDetailViewController * detail = [[JDShopGoodsDetailViewController alloc] init];
        
        detail.listGoodsInfo = self.tableArray[indexPath.row];
        
        [self.topViewController.navigationController pushViewController:detail animated:YES];
    }
    else if (self.viewModel.isGroupGoods)
    {
        
        GroupBuyDetailViewController *detail=[[GroupBuyDetailViewController alloc]init];
        detail.goodsId =self.tableArray[indexPath.row][@"goodsId"];
        [self.topViewController.navigationController pushViewController:detail animated:YES];
        
        
       
    }else if (self.viewModel.isOneNumberShop)
    {
      
    }else
    {
        DEF_DEBUG(@"商品详情:%@",indexPath);
        NSString * goodsId = self.tableArray[indexPath.row][@"goodsId"];
        
        
        SelfSupportGoodsDetailViewController * detail = [[SelfSupportGoodsDetailViewController alloc] init];
        
        detail.goodsId = goodsId;
        
        detail.isSorce = YES;
        
        [self.topViewController.navigationController pushViewController:detail animated:YES];
       
    }
    
    

}
-(void)configWithMallViewModel:(GoodsOrderStatusViewModel* )viewModel
{
    self.viewModel=viewModel;
    if (viewModel.isJDShop)
    {
        [self loadJDShopViewWithDatasource:viewModel.orderData];
    }
    else if (viewModel.isGroupGoods)
    {
        [self loadViewWithGroupDatasource:viewModel.orderData];
    }
    else if (viewModel.isOneNumberShop)
    {
        [self loadOneShopViewWithDatasource:viewModel.orderData];
    }
    else
    {
        [self loadViewWithDatasource:viewModel.orderData];
    }
}

-(void)loadOneShopViewWithDatasource:(NSDictionary *)dataSource
{
    self.tableArray=dataSource[@"orderItemList"];
    [self.table reloadData];
    float hight=self.table.contentSize.height;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hight);
    }];
}
-(void)loadJDShopViewWithDatasource:(NSDictionary *)dataSource
{
    self.tableArray=dataSource[@"zkJdOrderItemMapList"];
    [self.table reloadData];
    float hight=self.table.contentSize.height;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hight);
    }];
}
-(void)loadViewWithDatasource:(NSDictionary *)dataSource
{
    self.tableArray=dataSource[@"listGoods"];
    [self.table reloadData];
    float hight=self.table.contentSize.height;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hight);
    }];
}
-(void)loadViewWithGroupDatasource:(NSDictionary *)dataSource
{
    self.tableArray=@[dataSource];
    [self.table reloadData];
    float hight=self.table.contentSize.height;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hight);
    }];
}

@end

@implementation MallOrderInfoCenterCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    MallOrderInfoCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MallOrderInfoCenterCell"];
    if (!cell)
    {
        cell=[[MallOrderInfoCenterCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MallOrderInfoCenterCell"];
        cell.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }
    return cell;
}

-(void)createCell
{
    self.icon=[[NetworkImageView alloc]init];
    self.icon.backgroundColor=BM_WHITE;
    [self.contentView addSubview:self.icon];
    
    self.name=[UnityLHClass masonryLabel:@"namenamenamename" font:15.0 color:BM_BLACK];
    self.name.numberOfLines=2;
    [self.contentView addSubview:self.name];
    
    self.price=[UnityLHClass masonryLabel:@"¥288.00" font:13.0 color:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.00]];
    [self.contentView addSubview:self.price];
    
    self.num=[UnityLHClass masonryLabel:@"x2" font:13.0 color:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.00]];
    self.num.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.num];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.icon.mas_top).mas_offset(10);
        make.width.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_top).mas_offset(5);
        make.right.mas_equalTo(self.num.mas_left).offset(-5);
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
        make.bottom.mas_equalTo(self.icon.mas_bottom).offset(-0);
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    self.refund=[UnityLHClass masonryButton:@" " font:15.0 color:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.00]];
    self.refund.hidden=YES;
    [self.contentView addSubview:self.refund];
    self.refund.layer.borderWidth=1;
    self.refund.layer.borderColor=[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00].CGColor;
    self.refund.layer.cornerRadius=2;
    self.refund.layer.masksToBounds=YES;
    [self.refund mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(self.refund.mas_height).multipliedBy(3.0);
    }];

    [self.refund handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self sendObject:self.refund.titleLabel.text];
    }];


}
-(void)loadOneShopViewWithDatasource:(NSDictionary *)dataSource
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dataSource[@"productCname"];
    self.num.text=[NSString stringWithFormat:@"x%@",dataSource[@"number"]];
    self.price.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"price"] floatValue]];
//    returnGoodsYhdFlg 	string 	退货退至一号店标志，0：货退至平台（通过APP退款） 1：货退至一号店，若该字段为空，显示退款
//    applyState 	string 	审核状态（退货至平台，用此字段，状态:1：为待审核 2：为同意,3：为不同意）
//    returnOrderYhdState 	string 	审核状态（退货至一号店，用此字段，状态：0：待审核 4：审核拒绝 12：审核通过 34：退货取消 27：退货完成)
//    returnState 	string 	退款状态状态:1：退款中 2：已退款 3：未退款
    if ([dataSource[@"returnGoodsYhdFlg"] integerValue]==1)
    {
        self.refund.hidden=NO;
        self.refund.userInteractionEnabled=NO;
        switch ([dataSource[@"returnOrderYhdState"] integerValue])
        {
            case 0:
            {
                [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
               
            }
                break;
            case 27:
            {
                [self.refund setTitle:@"退货完成" forState:UIControlStateNormal];
            
                if ([dataSource[@"returnState"] integerValue]==0)
                {
                    [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==1)
                {
                    [self.refund setTitle:@"退款中" forState:UIControlStateNormal];
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==2)
                {
                    [self.refund setTitle:@"退款成功" forState:UIControlStateNormal];
                    
                }
                else if ([dataSource[@"returnState"] integerValue]==3)
                {
                    [self.refund setTitle:@"退款失败" forState:UIControlStateNormal];
        
                }
                
                
            }
                break;
            case 12:
            {
                [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
           
                
            }
                break;
            case 4:
            {
                [self.refund setTitle:@"审核不通过" forState:UIControlStateNormal];
             
            }
                break;
            case 34:
            {
                [self.refund setTitle:@"退货取消" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
              
            }
                break;
                
            default:
                break;
        }

    }
    else
    {
        switch ([dataSource[@"returnState"] integerValue])
        {
            case 0:
            {
                [self.refund setTitle:@"退货退款" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=YES;
                //apply_state 	String 	申请审核状态(1：审核中， 2：审核通过，3：审核不通过)
                if ([dataSource[@"applyState"] integerValue]==1)
                {
                    [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
                    self.refund.hidden=NO;
                    self.refund.userInteractionEnabled=NO;
                }
                else if ([dataSource[@"applyState"] integerValue]==2)
                {
                    [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
                    self.refund.hidden=NO;
                    self.refund.userInteractionEnabled=NO;
                }
                else if ([dataSource[@"applyState"] integerValue]==3)
                {
                    [self.refund setTitle:@"审核不通过" forState:UIControlStateNormal];
                    self.refund.hidden=NO;
                    self.refund.userInteractionEnabled=NO;
                }
                
                
            }
                break;
            case 1:
            {
                [self.refund setTitle:@"退款中" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
                
            }
                break;
            case 2:
            {
                [self.refund setTitle:@"退款成功" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
                
            }
                break;
            case 3:
            {
                [self.refund setTitle:@"退款失败" forState:UIControlStateNormal];
                self.refund.hidden = NO;
                self.refund.userInteractionEnabled=NO;
                
            }
                break;
                
            default:
                break;
        }

    }
   
}
-(void)loadJDShopViewWithDatasource:(NSDictionary *)dataSource
{

    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"imagePath"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dataSource[@"name"];
    self.num.text=[NSString stringWithFormat:@"x%@",dataSource[@"num"]];
    self.price.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"zkTotalPrice"] floatValue]];

//    if ([dataSource[@"state"] integerValue]==3)
//    {
      //  self.refund.hidden=NO;
       //            canAfterSellApply      0不可售后 1可售后
        //            afterSellApplyState     售后状态 01未完成 02已完成 03已取消
        if ([dataSource[@"canAfterSellApply"] integerValue] == 1)
        {
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=NO;

            [self.refund setTitle:@"申请售后" forState:UIControlStateNormal];
            self.refund.userInteractionEnabled=YES;
            if ([dataSource[@"afterSellApplyState"] integerValue] == 1)
            {
                [self.refund setTitle:@"申请售后中" forState:UIControlStateNormal];
                
            }
            else if ([dataSource[@"afterSellApplyState"] integerValue] == 2)
            {
                [self.refund setTitle:@"售后已完成" forState:UIControlStateNormal];
                
            }
            else if ([dataSource[@"afterSellApplyState"] integerValue] == 3)
            {
                [self.refund setTitle:@"售后已取消" forState:UIControlStateNormal];
                
            }
            

        }else{
            
                self.refund.hidden=YES;
               self.refund.userInteractionEnabled=NO;
                self.refund.layer.borderWidth=0;

            }
           
    
    
}

//    }
//    else
//    {
//        self.refund.hidden=YES;
//    }
    
    //    returnGoodsYhdFlg 	string 	退货退至一号店标志，0：货退至平台（通过APP退款） 1：货退至一号店，若该字段为空，显示退款
    //    applyState 	string 	审核状态（退货至平台，用此字段，状态:1：为待审核 2：为同意,3：为不同意）
    //    returnOrderYhdState 	string 	审核状态（退货至一号店，用此字段，状态：0：待审核 4：审核拒绝 12：审核通过 34：退货取消 27：退货完成)
    //    returnState 	string 	退款状态状态:1：退款中 2：已退款 3：未退款
//    if ([dataSource[@"returnGoodsYhdFlg"] integerValue]==1)
//    {
//        self.refund.hidden=NO;
//        self.refund.userInteractionEnabled=NO;
//        switch ([dataSource[@"returnOrderYhdState"] integerValue])
//        {
//            case 0:
//            {
//                [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
//                
//            }
//                break;
//            case 27:
//            {
//                [self.refund setTitle:@"退货完成" forState:UIControlStateNormal];
//                
//                if ([dataSource[@"returnState"] integerValue]==0)
//                {
//                    [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
//                    
//                }
//                else if ([dataSource[@"returnState"] integerValue]==1)
//                {
//                    [self.refund setTitle:@"退款中" forState:UIControlStateNormal];
//                    
//                }
//                else if ([dataSource[@"returnState"] integerValue]==2)
//                {
//                    [self.refund setTitle:@"退款成功" forState:UIControlStateNormal];
//                    
//                }
//                else if ([dataSource[@"returnState"] integerValue]==3)
//                {
//                    [self.refund setTitle:@"退款失败" forState:UIControlStateNormal];
//                    
//                }
//                
//                
//            }
//                break;
//            case 12:
//            {
//                [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
//                
//                
//            }
//                break;
//            case 4:
//            {
//                [self.refund setTitle:@"审核不通过" forState:UIControlStateNormal];
//                
//            }
//                break;
//            case 34:
//            {
//                [self.refund setTitle:@"退货取消" forState:UIControlStateNormal];
//                self.refund.hidden=NO;
//                self.refund.userInteractionEnabled=NO;
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//    }
//    else
//    {
//        switch ([dataSource[@"returnState"] integerValue])
//        {
//            case 0:
//            {
//                [self.refund setTitle:@"退货退款" forState:UIControlStateNormal];
//                self.refund.hidden=NO;
//                self.refund.userInteractionEnabled=YES;
//                //apply_state 	String 	申请审核状态(1：审核中， 2：审核通过，3：审核不通过)
//                if ([dataSource[@"applyState"] integerValue]==1)
//                {
//                    [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
//                    self.refund.hidden=NO;
//                    self.refund.userInteractionEnabled=NO;
//                }
//                else if ([dataSource[@"applyState"] integerValue]==2)
//                {
//                    [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
//                    self.refund.hidden=NO;
//                    self.refund.userInteractionEnabled=NO;
//                }
//                else if ([dataSource[@"applyState"] integerValue]==3)
//                {
//                    [self.refund setTitle:@"审核不通过" forState:UIControlStateNormal];
//                    self.refund.hidden=NO;
//                    self.refund.userInteractionEnabled=NO;
//                }
//                
//                
//            }
//                break;
//            case 1:
//            {
//                [self.refund setTitle:@"退款中" forState:UIControlStateNormal];
//                self.refund.hidden=NO;
//                self.refund.userInteractionEnabled=NO;
//                
//            }
//                break;
//            case 2:
//            {
//                [self.refund setTitle:@"退款成功" forState:UIControlStateNormal];
//                self.refund.hidden=NO;
//                self.refund.userInteractionEnabled=NO;
//                
//            }
//                break;
//            case 3:
//            {
//                [self.refund setTitle:@"退款失败" forState:UIControlStateNormal];
//                self.refund.hidden = NO;
//                self.refund.userInteractionEnabled=NO;
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//    }
//    

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dataSource[@"goodsName"];
    self.num.text=[NSString stringWithFormat:@"x%@",dataSource[@"goodsNum"]];
    self.price.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"marketPrice"] floatValue]];
    //returnState 	String 	退款状态（为null或者空则显示退款，1：退款中 ， 2：退款成功， 3：退款失败）
    switch ([dataSource[@"returnState"] integerValue])
    {
        case 0:
        {
            [self.refund setTitle:@"退货退款" forState:UIControlStateNormal];
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=YES;
            //apply_state 	String 	申请审核状态(1：审核中， 2：审核通过，3：审核不通过)
            if ([dataSource[@"applyState"] integerValue]==1)
            {
                [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
            }
            else if ([dataSource[@"applyState"] integerValue]==2)
            {
                [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
            }
            else if ([dataSource[@"applyState"] integerValue]==3)
            {
                [self.refund setTitle:@"审核不通过" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
            }
            
            
        }
            break;
        case 1:
        {
            [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=NO;

        }
            break;
        case 2:
        {
            [self.refund setTitle:@"退款成功" forState:UIControlStateNormal];
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=NO;

        }
            break;
        case 3:
        {
            [self.refund setTitle:@"退款失败" forState:UIControlStateNormal];
            self.refund.hidden = NO;
            self.refund.userInteractionEnabled=NO;

        }
            break;
            
        default:
            break;
    }

}
-(void)loadCellWithGroupDataSource:(id)dataSource
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"goodsImageList"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dataSource[@"goodsName"];
    self.num.text=[NSString stringWithFormat:@"x%@",dataSource[@"goodsNum"]];
    self.price.text=[NSString stringWithFormat:@"¥%.2f",[dataSource[@"goodsPrice"] floatValue]];
    //apply_state 	String 	申请审核状态(1：审核中， 2：审核通过，3：审核不通过)
    //returnState 	String 	退款状态（为null或者空则显示退款，1：退款中 ， 2：退款成功， 3：退款失败）
    switch ([dataSource[@"applyState"] integerValue])
    {
        case 0:
        {
            [self.refund setTitle:@"退货退款" forState:UIControlStateNormal];
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=YES;
           
            
        }
            break;
        case 1:
        {
            [self.refund setTitle:@"审核中" forState:UIControlStateNormal];
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=NO;
           
            
        }
            break;
        case 2:
        {
            [self.refund setTitle:@"审核通过" forState:UIControlStateNormal];
            self.refund.hidden=NO;
            self.refund.userInteractionEnabled=NO;
            if ([dataSource[@"returnState"] integerValue]==1)
            {
                [self.refund setTitle:@"退款中" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
            }
            else if ([dataSource[@"returnState"] integerValue]==2)
            {
                [self.refund setTitle:@"退款成功" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
            }
            else if ([dataSource[@"returnState"] integerValue]==3)
            {
                [self.refund setTitle:@"退款失败" forState:UIControlStateNormal];
                self.refund.hidden=NO;
                self.refund.userInteractionEnabled=NO;
            }
            
            
        }
            break;
        case 3:
        {
            [self.refund setTitle:@"审核不通过" forState:UIControlStateNormal];
            self.refund.hidden = NO;
            self.refund.userInteractionEnabled=NO;
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void) configForGroupBuyPay:(id)data{

    self.refund.hidden = YES;
    
    /*
     @{@"image":
     @"name":
     @"price":
     @"count":
     */
    [self.icon sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text = data[@"name"];
    self.num.text = [NSString stringWithFormat:@"x%@",data[@"count"]];
    self.price.text = [NSString stringWithFormat:@"¥%.2f",[data[@"price"] floatValue]];
}
@end
