//
//  JDServiceDetailViewController.m
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDServiceDetailViewController.h"
//售后进度
#import "JDProgressView.h"
//问题描述
#import "JDServiceDetailView.h"
//服务单信息
#import "JDServiceInfoView.h"
//进度详情
#import "JDProgressDetailViewController.h"
//填写客户发运信息
#import "AddLogisticsViewController.h"

@interface JDServiceDetailViewController ()
{
    UIView *numberAndTimeView;//服务单号和时间view
    UILabel *numberLab;//服务单号
    UILabel *timeLab;//申请时间
    
//    JDProgressView *progressView;//售后进度view
    
    JDServiceDetailView *messageView;//审核留言view
    JDServiceDetailView *problemView;//问题描述view
    JDServiceDetailView *checkResultView;//审核结果view
    JDServiceDetailView *handleRequestView;//处理结果view
    JDServiceInfoView *infoView;//服务单信息view
    
    UIButton *addLogisticsBtn;//填写物流
}
@end

@implementation JDServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"服务单详情";
    [self requestData];
}

-(void)createUIWithData:(NSDictionary *)data
{
    [self.contentView removeAllSubviews];
    UILabel *noticeLab = [UnityLHClass initUILabel:@"本次售后服务由京东为您提供" font:15.0 color:BM_GRAY rect:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 40)];
    noticeLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:noticeLab];
    
    numberAndTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(noticeLab), DEF_SCREEN_WIDTH, 60)];
    numberAndTimeView.backgroundColor = BM_WHITE;
    [self.contentView addSubview:numberAndTimeView];
    
    numberLab = [UnityLHClass masonryLabel:[NSString stringWithFormat:@"服务单号  %@",data[@"afsServiceId"]] font:14.0 color:BM_BLACK];
    [numberAndTimeView addSubview:numberLab];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(numberAndTimeView.mas_height).multipliedBy(0.5);
        make.top.mas_equalTo(0);
    }];
    
    timeLab = [UnityLHClass masonryLabel:@"申请时间 2017-12-10 22:33:34" font:14.0 color:BM_BLACK];
    NSString *time = [UnityLHClass getCurrentTimeWithType:@"YYYY/MM/dd HH:mm:ss" andTimeString:data[@"createDate"]];
    timeLab.text = [NSString stringWithFormat:@"申请时间  %@",time];
    
    [numberAndTimeView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberLab.mas_left);
        make.height.mas_equalTo(numberLab.mas_height);
        make.top.mas_equalTo(numberLab.mas_bottom);
    }];
    
    
    
    
    
//    progressView = [[JDProgressView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(numberAndTimeView)+15, DEF_SCREEN_WIDTH, 200)];
//    [progressView loadViewWithData:nil];
//    [self.contentView addSubview:progressView];
//    [progressView.detailBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//
//        //进度详情
//        JDProgressDetailViewController *vc=[[JDProgressDetailViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    
    
    NSString *str = data[@"approveNotes"];
    float height = [UnityLHClass getHeight:str wid:DEF_SCREEN_WIDTH-30 font:14.0]+10;
    //审核留言
    messageView = [[JDServiceDetailView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(numberAndTimeView)+15, DEF_SCREEN_WIDTH, 70+height)];
    messageView.contentLab.text = [str length] > 0 ? str : @"暂无";
    [self.contentView addSubview:messageView];
    
    
    
    
    problemView = [[JDServiceDetailView alloc]init];
    float proHeight = [UnityLHClass getHeight:data[@"questionDesc"] wid:DEF_SCREEN_WIDTH-30 font:14.0]+10;
    if ([data[@"questionPicList"] isKindOfClass:[NSArray class]] && [data[@"questionPicList"] count] > 0)
    {
        proHeight += 160;
       
        problemView.imageArray = data[@"questionPicList"];
    }
    problemView.frame = CGRectMake(0, DEF_BOTTOM(messageView)+15, DEF_SCREEN_WIDTH, 70+proHeight+20);
    problemView.contentLab.text = data[@"questionDesc"];
    problemView.contentLab.textColor=BM_Color_GrayColor;
//    problemView.timeLab.hidden = NO;
    problemView.titleLab.text = @"问题描述";
    [self.contentView addSubview:problemView];
    
    //审核结果
    checkResultView = [[JDServiceDetailView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(problemView)+15, DEF_SCREEN_WIDTH, 50)];
    checkResultView.titleLab.text = @"审核结果";
    checkResultView.rightLab.text =  [data[@"approvedResultName"] length] > 0 ? data[@"approvedResultName"] : @"暂无";
   checkResultView.rightLab.textColor=BM_Color_GrayColor;

    checkResultView.line.hidden = YES;
////    申请阶段(10),审核不通过(20),客服审核(21),商家审核(22),京东收货(31),商家收货(32), 京东处理(33),商家处理(34), 用户确认(40),完成(50), 取消 (60);
//    switch ([data[@"afsServiceStep"] integerValue])
//    {
//        case 10:
//        {
//            checkResultView.rightLab.text = @"申请中";
//        }
//            break;
//        case 20:
//        {
//            checkResultView.rightLab.text = @"审核未通过";
//        }
//            break;
//        case 21:
//        {
//            checkResultView.rightLab.text = @"客服审核";
//        }
//            break;
//        case 22:
//        {
//            checkResultView.rightLab.text = @"商家审核";
//        }
//            break;
//        case 31:
//        {
//            checkResultView.rightLab.text = @"京东收货";
//        }
//            break;
//        case 32:
//        {
//            checkResultView.rightLab.text = @"商家收货";
//        }
//            break;
//        case 33:
//        {
//            checkResultView.rightLab.text = @"京东处理";
//        }
//            break;
//        case 34:
//        {
//            checkResultView.rightLab.text = @"商家处理";
//        }
//            break;
//        case 40:
//        {
//            checkResultView.rightLab.text = @"用户确认";
//        }
//            break;
//        case 50:
//        {
//            checkResultView.rightLab.text = @"已完成";
//        }
//            break;
//        case 60:
//        {
//            checkResultView.rightLab.text = @"已取消";
//        }
//            break;
//            
//        default:
//        {
//            checkResultView.rightLab.text = @"暂无";
//        }
//            break;
//    }
    
    [self.contentView addSubview:checkResultView];
    
    //处理结果
    handleRequestView = [[JDServiceDetailView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(checkResultView)+15, DEF_SCREEN_WIDTH, 50)];
    handleRequestView.titleLab.text = @"处理结果";
    handleRequestView.rightLab.text = [data[@"processResultName"] length] > 0 ? data[@"processResultName"] : @"暂无";
    handleRequestView.rightLab.textColor=BM_Color_GrayColor;

    [self.contentView addSubview:handleRequestView];
    
    
    infoView = [[JDServiceInfoView alloc]init];
    infoView.hidden = [data[@"expressCode"] length] > 0 ? NO : YES;
    [infoView loadViewWithData:data];
    [self.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(handleRequestView.mas_bottom).offset(15);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        if ([data[@"expressCode"] length] > 0)
        {
            make.height.mas_equalTo(301);
        }
        else
        {
            make.height.mas_equalTo(0);
        }
        if ([data[@"approvedResult"] integerValue] != 33)
        {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        }
    }];
    
    /*
     approvedResult 直赔积分 (11),直赔余额 (12),直赔优惠卷 (13),直赔京豆 (14),直赔商品 (21),上门换新 (22),自营取件 (31),客户送货(32),客户发货 (33),闪电退款 (34),虚拟退款 (35),大家电检测 (80),大家电安装 (81),大家电移机 (82),大家电维修(83),大家电其它 (84);
     */
    if ([data[@"approvedResult"] integerValue] == 33)
    {
        addLogisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addLogisticsBtn setTitle:@"填写快递" forState:UIControlStateNormal];
        [addLogisticsBtn addTarget:self action:@selector(updateSendSkuRequest) forControlEvents:UIControlEventTouchUpInside];
        addLogisticsBtn.backgroundColor = BM_Color_Blue;
        addLogisticsBtn.layer.cornerRadius = 5.0;
        addLogisticsBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:addLogisticsBtn];
        [addLogisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(infoView.mas_bottom).offset(30);
            make.height.mas_equalTo(35);
            make.centerX.mas_equalTo(infoView.mas_centerX);
            make.width.mas_equalTo(DEF_SCREEN_WIDTH/2.0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        }];
    }
    
}


#pragma mark --- 获取京东售后详情
-(void)requestData
{
    [UserServices jdAfterSellApplyGetJdAfterSellApplyDetailWithAfsServiceId:self.afsServiceId
                                                                  imageSize:@"n1"
                                                            completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            id data = responseObject[@"data"];
            
            [self createUIWithData:data];
            
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

#pragma mark --- 填写客户发运信息
-(void)updateSendSkuRequest
{
    AddLogisticsViewController *vc = [[AddLogisticsViewController alloc]init];
    vc.afsServiceId = self.afsServiceId;
    [vc receiveObject:^(id object) {
        [self requestData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
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
