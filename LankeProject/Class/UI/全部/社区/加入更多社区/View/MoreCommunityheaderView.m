//
//  MoreCommunityheaderView.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MoreCommunityheaderView.h"

@interface MoreCommunityheaderView()

@property(nonatomic,strong)id data;

@end

@implementation MoreCommunityheaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=BM_WHITE;
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        [self getAssociationClass];
    }
    return self;
}


-(void)createView
{
    NSArray *dataSource=(NSArray *)self.data;
    
    
    
//    NSArray *dataSource=@[
//                          @{@"image":@"Community_huwai",
//                            @"title":@"户外",
//                            },
//                          @{@"image":@"Community_chuidiao",
//                            @"title":@"垂钓",
//                            },
//                          @{@"image":@"Community_qinzi",
//                            @"title":@"亲子",
//                            },
//                          @{@"image":@"Community_jiangzuo",
//                            @"title":@"讲座",
//                            },
//                          ];
    float viewWidth=50;//
//    float viewSpace=30;//
    float viewSpace=  (DEF_SCREEN_WIDTH-200)/5;

//    self.contentSize=CGSizeMake(viewWidth*dataSource.count, 0);
    for (int i=0; i<dataSource.count; i++)
    {
        NSDictionary *dic=dataSource[i];
        UIButton *type=[UnityLHClass masonryButton:nil font:14.0 color:BM_BLACK];
        [type sd_setImageWithURL:[NSURL URLWithString:dic[@"classImage"]] forState:UIControlStateNormal];
        type.tag=100+i;
        [self addSubview:type];
        
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(viewSpace +i*(viewWidth+viewSpace));
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
            if(i==dataSource.count-1)
            {
                make.right.mas_equalTo(self.mas_right).offset(-viewSpace);
                
            }
        }];
        [type addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *typeName=[UnityLHClass masonryLabel:dic[@"className"] font:14.0 color:BM_BLACK];
        [self addSubview:typeName];
        [typeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(type.mas_centerX);
            make.top.mas_equalTo(type.mas_bottom).offset(5);
        }];
        
    }
}
-(void)type:(UIButton *)type
{
    NSArray *dataSource=(NSArray *)self.data;
    NSDictionary *dic=dataSource[type.tag-100];
    [self sendObject:dic[@"id"]];
}

-(void)getAssociationClass
{
    [UserServices
     getAssociationClassWithCompletionBlock:^(int result, id responseObject)
     {
        if (result==0)
        {
            
          self.data=[NSArray arrayWithArray:responseObject[@"data"]];
 
            [self createView];

        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

@end
