//
//  JDInvoicerContentView.m
//  LankeProject
//
//  Created by fud on 2017/12/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDInvoicerContentView.h"

@implementation JDInvoicerContentView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BM_WHITE;
        
        UILabel *titleLab = [UnityLHClass masonryLabel:@"发票内容" font:16.0 color:BM_BLACK];
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = BM_Color_LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(titleLab.mas_bottom);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH-10);
            make.height.mas_equalTo(1);
        }];
        
//        _contentLab = [UnityLHClass masonryLabel:@"非图书商品" font:15.0 color:BM_GRAY];
//        [self addSubview:_contentLab];
//        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(10);
//            make.top.mas_equalTo(line.mas_bottom);
//            make.height.mas_equalTo(40);
//        }];
        
//        1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细
        self.dataArray = @[@"明细",@"电脑配件",@"耗材",@"办公用品"];
        self.typeStr = @"明细";
        self.invoiceContentStr = @"1";
        for (int i = 0 ; i < self.dataArray.count ; i++)
        {
            LeftImageBtn *btn = [[LeftImageBtn alloc]init];
            if (i == 0)
            {
                btn.selected = YES;
            }
            btn.tag = 200 + i;
            [btn setTitleColor:BM_BLACK forState:UIControlStateNormal];
            [btn setTitle:self.dataArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = BM_FONTSIZE15;
            [btn setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(line.mas_bottom).offset(50*i);
                make.left.mas_equalTo(10);
                make.height.mas_equalTo(50);
//                make.width.mas_equalTo(80);
            }];
            [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                
                for (id view in self.subviews)
                {
                    if ([view isKindOfClass:[LeftImageBtn class]] && ![view isEqual:btn])
                    {
                        LeftImageBtn *button = (LeftImageBtn *)view;
                        button.selected = NO;
                    }
                }
                btn.selected = YES;
                if (btn.selected)
                {
                    self.typeStr = self.dataArray[btn.tag-200];
                    switch (btn.tag - 200)
                    {
                        case 0:
                        {
                            self.invoiceContentStr = @"1";
                        }
                            break;
                        case 1:
                        {
                            self.invoiceContentStr = @"3";
                        }
                            break;
                        case 2:
                        {
                            self.invoiceContentStr = @"19";
                        }
                            break;
                        case 3:
                        {
                            self.invoiceContentStr = @"22";
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
            }];
        }
    }
    return self;
}

-(void)configViewWithData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        self.invoiceContentStr = data[@"invoiceContent"];
        for (id view in self.subviews)
        {
            if ([view isKindOfClass:[LeftImageBtn class]])
            {
                LeftImageBtn *button = (LeftImageBtn *)view;
                
                if (button.tag >= 200)
                {
                    button.selected = NO;
                }
            }
        }
        
//         1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细
        LeftImageBtn *btn = (LeftImageBtn *)[self viewWithTag:200];
        switch ([data[@"invoiceContent"] integerValue])
        {
            case 3:
            {
                btn = (LeftImageBtn *)[self viewWithTag:201];
            }
                break;
            case 19:
            {
                btn = (LeftImageBtn *)[self viewWithTag:202];
            }
                break;
            case 22:
            {
                btn = (LeftImageBtn *)[self viewWithTag:203];
            }
                break;
                
            default:
                break;
        }
        btn.selected = YES;
        self.typeStr = btn.titleLabel.text;
    }
}

@end
