//
//  MallHeaderView.m
//  LankeProject
//
//  Created by itman on 17/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallHeaderView.h"

@interface MallHeaderView ()

@property (nonatomic ,strong) NSArray * bannerDatas;
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UIImageView *rightImage;
@property(nonatomic,strong)UIButton *moreAll;
@property(nonatomic,strong)UIButton *scanAll;
@property(nonatomic,strong)UIView *bgView;


@end

@implementation MallHeaderView

-(void)dealloc
{
    [self.bannerView timerEnd];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.bannerView = [[CommonHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_WIDTH/2)];
        self.bannerView.delegate=self;
        [self addSubview:self.bannerView];
        
        self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0, DEF_SCREEN_WIDTH/2, DEF_SCREEN_WIDTH, 40)];
        self.bgView.userInteractionEnabled=YES;
        
        [self addSubview:self.bgView];
        self.scanAll= [UnityLHClass masonryButton:@"店铺" font:15.0 color:[UIColor colorWithHexString:@"#4D7BDB"]];
        [self.bgView addSubview:self.scanAll];
        [self.scanAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
        }];
        
        UIImageView *leftImage=[[UIImageView alloc]init];
        leftImage.image=[UIImage imageNamed:@"shangpfenlei0"];
        [self.bgView addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.scanAll.mas_left).offset(-3);
            make.centerY.mas_equalTo(self.scanAll.mas_centerY);

        }];
        self.leftImage=leftImage;
        
        UIImageView *rightImage=[[UIImageView alloc]init];
        rightImage.image=[UIImage imageNamed:@"shangpfenlei20"];
        rightImage.contentMode=UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scanAll.mas_right).offset(3);
            make.centerY.mas_equalTo(self.scanAll.mas_centerY);

        }];
        self.rightImage=rightImage;
        
        UIButton *moreAll=[UnityLHClass masonryButton:@"更多店铺" imageStr:@"more09" font:13.0 color:[UIColor colorWithHexString:@"#4D7BDB"]];
        
        [moreAll layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        [self.bgView addSubview:moreAll];
        self.moreAll=moreAll;
        [moreAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-18);
            make.centerY.mas_equalTo(self.bgView.mas_centerY);

        }];
        [moreAll handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@(0) withIdentifier:@"分类"];
        }];
        
        self.classificationView = [[ModuleCell alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.bgView), DEF_SCREEN_WIDTH,frame.size.height-DEF_HEIGHT(self.bannerView)-DEF_HEIGHT(self.bgView)-40)];
        self.classificationView.delegate=self;
        [self addSubview:self.classificationView];
        [self.classificationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];

    }
    return self;
}
//广告位delegate
-(void)commonHeaderView:(CommonHeaderView *)comonHeaderView didSelectedBannerImageAtIndex:(NSInteger)index
{
    [self sendObject:self.bannerDatas[index] withIdentifier:@"广告位"];
}

//分类delegate
-(void)moduleCell:(ModuleCell *)ModuleCell didSelectIndex:(NSInteger)index
{
    [self sendObject:@(index+1) withIdentifier:@"分类"];
}

//加载广告位数据
-(void)configureBannerViewWithImageData:(id)dataSource
{
    [self requestBanerList];
}
//加载分类数据
-(void)loadClassificationViewWithDataSource:(id)dataSource
{
    [self configureBannerViewWithImageData:nil];

////    NSArray * dataArr=@[
////                        @{@"icon":@"Mall_all",
////                          @"name":@"所有",
////                          @"eName":@"ALL",
////                          @"tag":@"01",
////                          },
////                        @{@"icon":@"Mall_tuangou",
////                          @"name":@"团购",
////                          @"eName":@"Mall_tuangou",
////                          @"tag":@"02",
////                          },
////                        ];
////    //添加京东
////     NSArray * dataArr=@[
////
//////                        @{@"icon":@"Mall_tuangou",
//////                          @"name":@"团购",
//////                          @"eName":@"Mall_tuangou",
//////                          @"tag":@"02",
//////                          },
////                        @{@"icon":@"JDjdicon",
////                          @"name":@"京东",
////                          @"eName":@"SHOP JD",
////                          @"tag":@"03",
////                          },
////                        ];
//
//    NSMutableArray *temp=[[NSMutableArray alloc]init];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    dataArray=dataSource;
//   // [temp addObjectsFromArray:dataArr];
//
//    for (int i=0; i<dataArray.count; i++) {
//        if (i==0) {
//            [temp addObject:dataArray[i]];
//
//        }else{
//            NSDictionary *data=dataArray[i];
//            NSDictionary *dataSourc= @{@"icon":[NSURL URLWithString:data[@"merchantLogo"]],
//                                        @"name":data[@"merchantName"],
//                                        @"eName":data[@"merchantName"],
//                                        @"tag":data[@"merchantId"],
//                                        };
//            [temp addObject:dataSourc];
//
//        }
//    }
//    for (NSDictionary *data in dataSource)
//    {
//        NSDictionary *dataSource= @{@"icon":[NSURL URLWithString:data[@"merchantLogo"]],
//                                    @"name":data[@"merchantName"],
//                                    @"eName":data[@"merchantName"],
//                                    @"tag":data[@"merchantId"],
//                                    };
//        [temp addObject:dataSource];
//
//    }
    [self.classificationView loadCellWithDataSource:dataArray];

//    if (temp.count>0) {
//        [self.classificationView loadCellWithDataSource:temp];
//
//    }
    
    if (dataArray.count>4)
    {
         self.classificationView.frame =CGRectMake(0, DEF_BOTTOM(self.bgView), DEF_SCREEN_WIDTH,self.frame.size.height-DEF_HEIGHT(self.bgView)-DEF_HEIGHT(self.bannerView));
    }
}

+(float)getMallHeaderViewHightWithDataSource:(NSArray *)dataSource
{
    float  hight=(DEF_SCREEN_WIDTH/2+10)+(DEF_SCREEN_WIDTH/2.0+70)+40;
    if (dataSource.count<3)
    {
        hight=(DEF_SCREEN_WIDTH/2+10)+(DEF_SCREEN_WIDTH/2.0+70)/2.0+40;
    }
    return hight;
}


#pragma mark -
#pragma mark Network M

- (void) requestBanerList{
    
    [UserServices mallAdvertGetMallAdvertCompletionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            self.bannerDatas = responseObject[@"data"];
            
            NSMutableArray * temp = [NSMutableArray arrayWithCapacity:self.bannerDatas.count];
            for (NSDictionary * data in self.bannerDatas) {
                
                [temp addObject:data[@"advertImage"]];
            }
            [self.bannerView configureBannerViewWithImageData:temp];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
