//
//  ApplyRefundViewController.m
//  LankeProject
//
//  Created by itman on 17/1/17.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "JYZTextView.h"
#import "SelectedPhotoView.h"

@interface ApplyRefundViewController ()

@property(nonatomic,strong)JYZTextView *note;
@property(nonatomic,strong)SelectedPhotoView *photo;
@property(nonatomic,strong)UIButton *whyButton;
@property(nonatomic,assign)NSInteger seletedIndex;

@end

@implementation ApplyRefundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.seletedIndex=0;
    [self showNavBarCustomByTitle:@"申请退款"];
}
-(void)createUI
{
    float hight=DEF_SCREEN_WIDTH/2.0;
    UIView *topView=[[UIView alloc]init];
    topView.backgroundColor=BM_WHITE;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(hight);
    }];
    
    UILabel *leftLable=[UnityLHClass masonryLabel:@"退款原因" font:15.0 color:BM_BLACK];
    [topView addSubview:leftLable];
    [leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
    
    UIButton  *goImage=[UnityLHClass masonryButton:@"" imageStr:@"right_arrow" font:15.0 color:BM_BLACK];
    [topView addSubview:goImage];
    [goImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(leftLable.mas_centerY);
    }];
    [goImage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];

    }];
    
    [self.whyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
    }];
    
    self.whyButton=[UnityLHClass masonryButton:@"" imageStr:@"" font:15.0 color:BM_BLACK];
    [topView addSubview:self.whyButton];
    [self.whyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImage.mas_left).offset(-5);
        make.centerY.mas_equalTo(leftLable.mas_centerY);
    }];
    [self.whyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
    }];
    
    UIButton *whyButton=[UnityLHClass masonryButton:@"" imageStr:@"" font:15.0 color:BM_BLACK];
    whyButton.backgroundColor=BM_CLEAR;
    [topView addSubview:whyButton];
    [whyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImage.mas_left).offset(0);
        make.centerY.mas_equalTo(leftLable.mas_centerY);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    [whyButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self showDropDownView];
    }];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftLable.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(leftLable.mas_left);
        make.right.mas_equalTo(goImage.mas_right);

    }];
    
    UILabel *leftOneLable=[UnityLHClass masonryLabel:@"备注" font:15.0 color:BM_BLACK];
    [topView addSubview:leftOneLable];
    [leftOneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_left);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(line.mas_bottom).offset(15);
    }];
    
    self.note=[[JYZTextView alloc]init];
    self.note.placeholder=@"请输入";
    self.note.font=BM_FONTSIZE(15.0);
    [topView addSubview:self.note];
    [self.note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftOneLable.mas_right);
        make.right.mas_equalTo(line.mas_right);
        make.top.mas_equalTo(leftOneLable.mas_top).offset(-7);
        make.bottom.mas_equalTo(topView.mas_bottom).offset(-10);

    }];
    
    
    UILabel *photolable=[UnityLHClass masonryLabel:@"上传照片" font:15.0 color:BM_BLACK];
    photolable.frame=CGRectMake(15, hight+10+10, 100, 30);
    [self addSubview:photolable];
    
    self.photo=[[SelectedPhotoView alloc]initWithFrame:CGRectMake(10, DEF_BOTTOM(photolable), DEF_SCREEN_WIDTH-10*2, 100)];
    self.photo.maxColumn=5;
    self.photo.maxImageCount=5;
    [self addSubview:self.photo];
    
    UIButton *submitButton=[UnityLHClass masonryButton:@"提交申请" font:15.0 color:BM_WHITE];
    submitButton.layer.masksToBounds=YES;
    submitButton.layer.cornerRadius=5;
    submitButton.backgroundColor=[UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
    submitButton.frame=CGRectMake(15, DEF_BOTTOM(self.photo)+30, DEF_SCREEN_WIDTH-15*2, 40);
    [self addSubview:submitButton];
    [submitButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        [self returnOrder];
    }];
    self.contentView.contentSize=CGSizeMake(0, DEF_BOTTOM(submitButton)+30);
    
}
-(void)showDropDownView
{
    NSArray *dropArray=@[@"商品质量问题",@"卖家发错货",@"其他",];
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"商品质量问题",@"卖家发错货",@"其他", nil];
   [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
       if (buttonIndex<dropArray.count)
       {
           self.seletedIndex=buttonIndex;
           [self.whyButton setTitle:dropArray[buttonIndex] forState:UIControlStateNormal];
       }
      
   }];
}

-(void)returnOrder
{
    if (self.whyButton.titleLabel.text.length==0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请选择退款原因"];
    }
    else
    {
        [UserServices
         returnOrderWithOrderCode:self.model.orderCode
         orderType:self.model.orderType
         goodsId:self.model.goodsId
         goodsName:self.model.goodsName
         goodsPrice:self.model.goodsPrice
         goodsNum:self.model.goodsNum
         merchantId:self.model.merchantId
         merchantName:self.model.merchantName
         refundReason:[NSString stringWithFormat:@"0%ld",(long)self.seletedIndex+1]
         refundMessage:self.note.text
         userId:[KeychainManager readUserId]
         userName:[KeychainManager readUserName]
         imagesPath:self.photo.images
         completionBlock:^(int result, id responseObject)
         {
             if (result==0)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation ApplyRefundModel

+ (instancetype)ApplyRefundModelModelWithData:(id)data withIndex:(NSInteger)index
{
    ApplyRefundModel *model=[[ApplyRefundModel alloc]init];
    model.orderCode=data[@"orderCode"];
    model.merchantId=data[@"merchantId"];
    model.merchantName=data[@"merchantName"];
    NSDictionary *goodDic= data[@"listGoods"][index];
    model.goodsId=goodDic[@"goodsId"];
    model.goodsName=goodDic[@"goodsName"];
    model.goodsNum=goodDic[@"goodsNum"];
    model.goodsPrice=goodDic[@"marketPrice"];
    return model;
}
+ (instancetype)ApplyOneShopRefundModelModelWithData:(id)data withIndex:(NSInteger)index
{
    ApplyRefundModel *model=[[ApplyRefundModel alloc]init];
    model.orderCode=data[@"orderCode"];
    model.merchantId=@"YHD";
    model.merchantName=@"YHD";
    NSDictionary *goodDic= data[@"orderItemList"][index];
    model.goodsId=goodDic[@"productId"];
    model.goodsName=goodDic[@"productCname"];
    model.goodsNum=goodDic[@"number"];
    model.goodsPrice=goodDic[@"price"];
    return model;
}
+ (instancetype)ApplyRefundModelModelWithData:(id)data
{
    ApplyRefundModel *model=[[ApplyRefundModel alloc]init];
    model.orderCode=data[@"orderCode"];
    model.merchantId=data[@"merchantId"];
    model.merchantName=data[@"merchantName"];
    model.goodsId=data[@"goodsId"];
    model.goodsName=data[@"goodsName"];
    model.goodsNum=data[@"goodsNum"];
    model.goodsPrice=data[@"goodsPrice"];
    return model;
}
@end
