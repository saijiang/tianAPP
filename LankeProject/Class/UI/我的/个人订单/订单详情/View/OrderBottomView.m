//
//  OrderBottomView.m
//  LankeProject
//
//  Created by itman on 16/12/30.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "OrderBottomView.h"
#import "FoodOrderStatusViewModel.h"
#import "GoodsOrderStatusViewModel.h"
@interface OrderBottomView ()

@property(nonatomic,strong)UIButton  *orderRightOperation;
@property(nonatomic,strong)UIButton  *orderLeftOperation;

@end

@implementation OrderBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.orderRightOperation=[UnityLHClass masonryButton:@"删除订单" font:15.0 color:[UIColor colorWithHexString:@"000000"]];
        [self addSubview:self.orderRightOperation];
        self.orderRightOperation.layer.borderWidth=1;
        self.orderRightOperation.layer.cornerRadius=4;
        self.orderRightOperation.layer.masksToBounds=YES;

        
        self.orderRightOperation.layer.borderColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00].CGColor;
       // [UIColor colorWithHexString:@"000000"].CGColor;//
        [self.orderRightOperation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(self.orderRightOperation.mas_height).multipliedBy(2.5);
        }];
        [self.orderRightOperation handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:self.orderRightOperation.titleLabel.text];
        }];
        
        self.orderLeftOperation=[UnityLHClass masonryButton:@"取消订单" font:15.0 color:[UIColor colorWithHexString:@"000000"]];
        self.orderLeftOperation.hidden=YES;
        [self addSubview:self.orderLeftOperation];
        self.orderLeftOperation.layer.borderWidth=1;
        self.orderLeftOperation.layer.cornerRadius=4;
        self.orderLeftOperation.layer.masksToBounds=YES;
        self.orderLeftOperation.layer.borderColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00].CGColor;
      //  [UIColor colorWithHexString:@"000000"].CGColor;//
        [self.orderLeftOperation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.orderRightOperation.mas_left).offset(-10);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(self.orderRightOperation.mas_height).multipliedBy(2.5);
        }];
        [self.orderLeftOperation handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:self.orderLeftOperation.titleLabel.text];
        }];

    }
    return self;
}

- (void)configWithViewModel:(FoodOrderStatusViewModel *)viewModel{

    BOOL noneButton = YES;
    
    NSDictionary * rightHandle = viewModel.orderHandles[0];
    _orderLeftOperation.hidden = [rightHandle[@"hiden"] boolValue];
    noneButton = noneButton && _orderLeftOperation.isHidden;
    [_orderLeftOperation setTitle:rightHandle[@"title"] forState:UIControlStateNormal];
    [_orderLeftOperation handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self sendObject:rightHandle[@"title"]];
    }];
    
    NSDictionary * leftHandle = viewModel.orderHandles[1];
    _orderRightOperation.hidden = [leftHandle[@"hiden"] boolValue];
    noneButton = noneButton && _orderRightOperation.isHidden;
    [_orderRightOperation setTitle:leftHandle[@"title"] forState:UIControlStateNormal];
    [_orderRightOperation handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self sendObject:leftHandle[@"title"]];
    }];

    if (noneButton) {
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void) configMallWithViewModel:(GoodsOrderStatusViewModel*)viewModel
{
    
    if (viewModel.isJDShop)
    {
        //orderStatus 	string 	订单状态//01 待付款 02 已付款，待收货 03 妥投 04拒收 05 已取消
        BOOL noneButton = NO;
        switch ([viewModel.orderData[@"state"] integerValue])
        {
                
                
            case 1:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                [_orderRightOperation setTitle:@"去付款" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"取消订单" forState:UIControlStateNormal];
                
                
            }
                break;
                
            case 2:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
            //    NSInteger shippingName = [viewModel.orderData[@"shippingName"] integerValue];
               // self.orderLeftOperation.hidden = shippingName != 3;
                [_orderRightOperation setTitle:@"确认收货" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
//                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
//                {
//                    self.orderLeftOperation.hidden=YES;
//                    
//                }
//                self.orderRightOperation.hidden=NO;
//                self.orderLeftOperation.hidden=YES;
//                [_orderRightOperation setTitle:@"查看物流" forState:UIControlStateNormal];
//                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
//                {
//                    self.orderLeftOperation.hidden=YES;
//                    
//                }
                
            }
                break;
            case 3:
            {
                           //是否已经评价
                           if ([viewModel.orderData[@"isEvaluate"] integerValue] == 1)
                           {
                               //已经评价过了
                               self.orderRightOperation.hidden=NO;
                               [_orderRightOperation setTitle:@"电子发票" forState:UIControlStateNormal];                           }
                           else
                           {
                               self.orderRightOperation.hidden=NO;
                               [_orderRightOperation setTitle:@"评价" forState:UIControlStateNormal];
                           }
                // }
              
                
                
            }
                break;
            case 4:
            {
                
                
            }
                break;
                
            case 5:
            {
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                
            }
                break;
                
                
            default:
                break;
        }
        
        if (noneButton)
        {
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        
        
    }else if (viewModel.isOneNumberShop)
    {
        //orderStatus 	string 	订单状态（3-未支付 4-已支付 20-已出库 24-已收货 34-已取消 35-已完成 37-送货失败 38-待发货）
        BOOL noneButton = NO;
        switch ([viewModel.orderData[@"orderStatus"] integerValue])
        {
            case 3:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                [_orderRightOperation setTitle:@"去付款" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"取消订单" forState:UIControlStateNormal];

                
            }
                break;
            case 4:
            {
                noneButton = YES;
                self.orderRightOperation.hidden=YES;
                self.orderLeftOperation.hidden=YES;
            }
                break;
            case 20:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;

                }

            }
                break;
            case 24:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                [_orderRightOperation setTitle:@"评价" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
            case 34:
            {
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                
            }
                break;

            case 35:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
                
            case 37:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
                
            case 38:
            {
                noneButton = YES;
                self.orderRightOperation.hidden=YES;
                self.orderLeftOperation.hidden=YES;
                
                
            }
                break;
                
            default:
                break;
        }
        
        if (noneButton)
        {
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }

        
    }
    else if (viewModel.isGroupGoods)
    {
        //orderState 	订单状态（01：未成团 ，02：待商家确认， 03：未成团 ， 04：待发货，05：待收货 ，06：已完成  07：已取消， 08：待支付）
        BOOL noneButton = NO;
        switch ([viewModel.orderData[@"orderState"] integerValue])
        {
            case 1:
            {
                if (0) {// 是否截止（01：截止时间已到 ，02：截止时间未到）
                    
                    self.orderRightOperation.hidden=NO;
                    [self.orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                }else{
                    
                    self.orderRightOperation.hidden = YES;
                }
                self.orderLeftOperation.hidden=YES;
                
            }
            break;
            case 3:
            {
                if (1) {// 是否截止（01：截止时间已到 ，02：截止时间未到）
                    
                    self.orderRightOperation.hidden=NO;
                    [self.orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                }else{
                
                    self.orderRightOperation.hidden = YES;
                }
                self.orderLeftOperation.hidden=YES;
                
            }
                break;
            case 2:
            case 4:
            {
                noneButton = YES;
                self.orderRightOperation.hidden=YES;
                self.orderLeftOperation.hidden=YES;
                
            }
                break;
            case 5:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                NSInteger shippingName = [viewModel.orderData[@"shippingName"] integerValue];
                self.orderLeftOperation.hidden = shippingName != 3;
                [_orderRightOperation setTitle:@"确认收货" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
            case 6:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
              
            }
                   break;
            case 7:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                   break;
            case 8:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"去付款" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
                
            default:
                break;
        }
        if (noneButton)
        {
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }

    }
    else
    {
        //orderState 	String 	订单状态（01：已取消 (删除)， 02：待付款（取消订单，付款） ， 03：待发货（无） ， 04：待收货（查看物流，确认收货）， 05：待评价（查看物流，评价） ，06：已完成（查看物流，删除） ）
        BOOL noneButton = NO;
        switch ([viewModel.orderData[@"orderState"] integerValue])
        {
            case 1:
            {
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                
            }
                break;
            case 2:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                [_orderRightOperation setTitle:@"去付款" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"取消订单" forState:UIControlStateNormal];
                
            }
                break;
            case 3:
            {
                noneButton = YES;
                self.orderRightOperation.hidden=YES;
                self.orderLeftOperation.hidden=YES;
                
                
            }
                break;
            case 4:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                NSInteger shippingName = [viewModel.orderData[@"shippingName"] integerValue];
                self.orderLeftOperation.hidden = shippingName != 3;
                [_orderRightOperation setTitle:@"确认收货" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }

                
            }
                break;
            case 5:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=NO;
                [_orderRightOperation setTitle:@"评价" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
            case 6:
            {
                self.orderRightOperation.hidden=NO;
                self.orderLeftOperation.hidden=YES;
                [_orderRightOperation setTitle:@"删除订单" forState:UIControlStateNormal];
                [_orderLeftOperation setTitle:@"查看物流" forState:UIControlStateNormal];
                if ([viewModel.orderData[@"shippingName"] intValue]!=3)
                {
                    self.orderLeftOperation.hidden=YES;
                    
                }
                
            }
                break;
                
            default:
                break;
        }
        
        if (noneButton)
        {
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }

  
    }
    
    [_orderLeftOperation handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self sendObject:_orderLeftOperation.titleLabel.text];
    }];
    
    [_orderRightOperation handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self sendObject:_orderRightOperation.titleLabel.text];
    }];
    
   
}

@end
