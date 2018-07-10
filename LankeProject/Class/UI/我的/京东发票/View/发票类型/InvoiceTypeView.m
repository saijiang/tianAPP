//
//  InvoiceTypeView.m
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "InvoiceTypeView.h"

@interface InvoiceTypeView()


@end

@implementation InvoiceTypeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = BM_WHITE;
        
        _typeTitleLab = [UnityLHClass initUILabel:@"发票类型" font:16.0 color:BM_BLACK rect:CGRectMake(10, 0, 100, 50)];
        [self addSubview:_typeTitleLab];

        _noticeLable = [UnityLHClass masonryLabel:@"京东部分试点地区仅提供电子普通发票，具体以实际出具为准" font:14.0 color:BM_GRAY];
        _noticeLable.numberOfLines = 2;
        [self addSubview:_noticeLable];
        [_noticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.right.mas_equalTo(self.mas_right).offset(-10);
        }];
    
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray
{
    
    if (dataArray.count == 0)
    {
        return;
    }
    float width = 70;
    if (dataArray.count >= 4)
    {
        width = (DEF_SCREEN_WIDTH-20-10*(dataArray.count - 1))/dataArray.count;
    }
    
    for (int i = 0; i < dataArray.count; i++)
    {
        id dic = dataArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = BM_FONTSIZE14;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = BM_LIGHTGRAY.CGColor;
        btn.layer.borderWidth = 1.0;
        if ([dic isKindOfClass:[NSString class]])
        {
            [btn setTitle:dic forState:UIControlStateNormal];
        }
        else if ([dic isKindOfClass:[NSDictionary class]])
        {
            [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:dataArray[i] forState:UIControlStateNormal];
        }
        
//        if (dataArray.count == 1)
//        {
//            btn.selected = YES;
//            btn.layer.borderColor = BM_Color_Blue.CGColor;
//        }
        
        [btn setTitleColor:BM_LIGHTGRAY forState:UIControlStateNormal];
        [btn setTitleColor:BM_Color_Blue forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(10+(width+10)*i, DEF_BOTTOM(_typeTitleLab)+35*(i/4), width, 35);
   
            
            if ([dic isKindOfClass:[NSDictionary class]]) {
                btn.tag = 100+[dic[@"code"] integerValue];
            }else{
                btn.tag = 100+i;

            }


        [self addSubview:btn];
        
    }
}


-(void)btnClick:(UIButton *)btn
{
    self.typeStr = nil;
    for (id view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)view;
            if (button.tag >= 100)
            {
                button.selected = NO;
                button.layer.borderColor = BM_Color_LineColor.CGColor;
            }
        }
    }
    
    btn.selected = YES;
    btn.layer.borderColor = BM_Color_Blue.CGColor;
    
    if (self.type == 0)
    {
        switch (btn.tag - 100)
        {
            case 0:
            {
                self.typeStr = @"";
            }
                break;
            case 1:
            {
                self.typeStr = @"";
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.type == 1)
    {
        //        ，退货(10)、换货(20)、维修(30)
          self.typeStr =[NSString  stringWithFormat:@"%ld", btn.tag - 100];
//        switch (btn.tag - 100)
//        {
//            case 0:
//            {
//                self.typeStr = @"10";
//            }
//                break;
//            case 1:
//            {
//                self.typeStr = @"20";
//            }
//                break;
//            case 2:
//            {
//                self.typeStr = @"30";
//            }
//                break;
//
//            default:
//                break;
//        }
    }
    else if (self.type == 2)
    {
//       0 无包装 10 包装完整 20 包装破损
        self.typeStr =[NSString  stringWithFormat:@"%ld", btn.tag - 100];

//        switch (btn.tag - 100)
//        {
//            case 0:
//            {
//                self.typeStr = @"0";
//            }
//                break;
//            case 1:
//            {
//                self.typeStr = @"10";
//            }
//                break;
//            case 2:
//            {
//                self.typeStr = @"20";
//            }
//                break;
//
//            default:
//                break;
//        }
    }
    else if (self.type == 3)
    {
        //       4 上门取件 7 客户送货 40客户发货
        self.typeStr =[NSString  stringWithFormat:@"%ld", btn.tag - 100];

//        switch (btn.tag - 100)
//        {
//            case 0:
//            {
//                self.typeStr = @"40";
//            }
//                break;
//            case 1:
//            {
//                self.typeStr = @"7";
//            }
//                break;
//            case 2:
//            {
//                self.typeStr = @"4";
//            }
//                break;
//
//            default:
//                break;
//        }
    }

}

#pragma mark --- 服务类型
-(void)getCustomerExpectCompRequest
{
    [UserServices jdReturnOrderGetCustomerExpectCompWithJdOrderId:self.jdOrderId
                                                    skuId:self.skuId
                                                  completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                id array = data[@"result"];
                if ([array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    self.dataArray = array;
                }
            }
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

#pragma mark --- 返回京东方式
-(void)getWareReturnJdCompRequest
{
    [UserServices jdReturnOrderGetWareReturnJdCompWithJdOrderId:self.jdOrderId
                                                            skuId:self.skuId
                                                  completionBlock:^(int result, id responseObject)
     {
         if (result == 0)
         {
             id data = responseObject[@"data"];
             if ([data isKindOfClass:[NSDictionary class]])
             {
                 id array = data[@"result"];
                 if ([array isKindOfClass:[NSArray class]] && [array count] > 0)
                 {
                     self.dataArray = array;
                 }
             }
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}



@end
