//
//  CartNumView.m
//  LankeProject
//
//  Created by itman on 17/2/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CartNumView.h"

@implementation CartNumView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
+(CartNumView *)CartNumView
{
    CartNumView *view=[[CartNumView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    view.backgroundColor = BM_RED;
    view.layer.cornerRadius = 12/2;
    view.layer.masksToBounds=YES;
    view.hidden = YES;
    [view getGoodsCartNum];
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.num=[UnityLHClass masonryLabel:@"" font:10 color:BM_WHITE];
        self.num.userInteractionEnabled = YES;
        [self addSubview:self.num];
        [self.num setAdjustsFontSizeToFitWidth:YES];
        self.num.textAlignment=NSTextAlignmentCenter;
        [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
//            make.top.mas_equalTo(self.mas_top).mas_offset(-5);
//            make.right.mas_equalTo(self.mas_right).mas_offset(5);
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGoodsCartNum) name:DEFN_AddGoodsCart object:nil];
    }
    return self;
}

-(void)getGoodsCartNum
{
   
    if (![KeychainManager islogin])
    {
        self.hidden=YES;
        return;
    }
    [UserServices
     getGoodsCartNumWithUserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             self.num.text=[NSString stringWithFormat:@"%d",[responseObject[@"data"] intValue]];
             
             if ([responseObject[@"data"] intValue]>0&&[responseObject[@"data"] intValue]<100)
             {
                 self.hidden=NO;

             }
             else if ([responseObject[@"data"] intValue]>99)
             {
                 self.hidden=NO;
                 self.num.text=@"99+";
                 
             }
             else
             {
               self.hidden=YES;

             }
         }
         else
         {
//             self.hidden=YES;
         }
    }];
}

@end
