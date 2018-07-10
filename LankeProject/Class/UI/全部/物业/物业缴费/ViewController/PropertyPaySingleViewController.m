//
//  PropertyPaySingleViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyPaySingleViewController.h"
#import "PropertyInfoHeaderView.h"
#import "PropertyBillCell.h"
#import "PropertyPayBillViewController.h"

@interface PropertyPaySingleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * paySingleTableView;
@property (nonatomic ,strong) PropertyInfoFooterView * footerView;
@property (nonatomic ,strong) NSArray * datas;
@property (nonatomic ,strong) id  data;

@end

@implementation PropertyPaySingleViewController

-(void)configData:(id)data
{
    self.data=data;
    //billType 	String 	缴费类型（01：水费， 02：网费/电话费， 03：停车费 ， 04：供暖费，05：物业费， 06：生活热水费 ，07：燃气费）
    NSString *billType=@"水费";
    switch ([data[@"billType"] integerValue])
    {
        case 1:
        {
            billType=@"水费";
//            NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            
            NSString *thisTimeDisplayNum=[NSString stringWithFormat:@"%.1f",[data[@"thisTimeDisplayNum"] floatValue]];
            NSString *lastTimeDisplayNum=[NSString stringWithFormat:@"%.1f",[data[@"lastTimeDisplayNum"] floatValue]];
            NSString *useNum=[[NSString stringWithFormat:@"%.1f",[data[@"useNum"] floatValue]] stringByAppendingString:@"吨"];
            NSString *unitPrice=[[NSString stringWithFormat:@"%.1f",[data[@"unitPrice"] floatValue]] stringByAppendingString:@"元"];
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]] stringByAppendingString:@"元"];
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                            @{
                                @"title": @"本次表示数",
                                @"detail": thisTimeDisplayNum
                                },
                            @{
                                @"title": @"上次表示数",
                                @"detail": lastTimeDisplayNum
                                },
                            @{
                                @"title": @"用量",
                                @"detail": useNum
                                },
                            @{
                                @"title": @"单价说明",
                                @"detail": unitPrice
                                },
                            @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];

        }
            break;
        case 2:
        {
            billType=@"网费/电话费";
           // NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]]  stringByAppendingString:@"元"];
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                                @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];

        }
            break;
            
        case 3:
        {
            billType=@"停车费";
            //NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            NSString *parkPosition=data[@"parkPosition"] ;
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]]  stringByAppendingString:@"元"];;
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                            @{
                                @"title": @"停车位置",
                                @"detail": parkPosition
                                },
                            @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];

            
        }
            break;
            
        case 4:
        {
            billType=@"供暖费";
           // NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            NSString *totalArea=[[NSString stringWithFormat:@"%.1f",[data[@"totalArea"] floatValue]]  stringByAppendingString:@"平方米"];
            NSString *unitPrice=[[NSString stringWithFormat:@"%.1f",[data[@"unitPrice"] floatValue]]  stringByAppendingString:@"元/平"];
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]]  stringByAppendingString:@"元"];
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                            @{
                                @"title": @"房屋面积",
                                @"detail": totalArea
                                },
                            @{
                                @"title": @"供暖费单价",
                                @"detail": unitPrice
                                },
                            @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];
            

            
        }
            break;
            
        case 5:
        {
            billType=@"物业费";
           // NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            NSString *totalArea=[[NSString stringWithFormat:@"%.1f",[data[@"totalArea"] floatValue]] stringByAppendingString:@"平方米"];
            NSString *unitPrice=[[NSString stringWithFormat:@"%.1f",[data[@"unitPrice"] floatValue]] stringByAppendingString:@"元/平"];
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]]  stringByAppendingString:@"元"];
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                            @{
                                @"title": @"房屋面积",
                                @"detail": totalArea
                                },
                            @{
                                @"title": @"物业费单价",
                                @"detail": unitPrice
                                },
                            @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];

            
        }
            break;
            
        case 6:
        {
            billType=@"生活热水费";
            //NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            NSString *thisTimeDisplayNum=[NSString stringWithFormat:@"%.1f",[data[@"thisTimeDisplayNum"] floatValue]];
            NSString *lastTimeDisplayNum=[NSString stringWithFormat:@"%.1f",[data[@"lastTimeDisplayNum"] floatValue]];
            NSString *useNum=[[NSString stringWithFormat:@"%.1f",[data[@"useNum"] floatValue]]  stringByAppendingString:@"吨"];
            NSString *unitPrice=[[NSString stringWithFormat:@"%.1f",[data[@"unitPrice"] floatValue]]  stringByAppendingString:@"元"];
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]]  stringByAppendingString:@"元"];
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                            @{
                                @"title": @"本次表示数",
                                @"detail": thisTimeDisplayNum
                                },
                            @{
                                @"title": @"上次表示数",
                                @"detail": lastTimeDisplayNum
                                },
                            @{
                                @"title": @"用量",
                                @"detail": useNum
                                },
                            @{
                                @"title": @"单价说明",
                                @"detail": unitPrice
                                },
                            @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];
            

        }
            break;
            
        case 7:
        {
            billType=@"燃气费";
           // NSString *time=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString*time=@"";
            NSString *time1=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billMonth"]];
            NSString *time2=[UnityLHClass getCurrentTimeWithType:@"yyyy.MM" andTimeString:data[@"billEndMonth"]];
            if (time2.length!=0) {
                
                if ([time1 isEqualToString:time2]) {
                    
                    time=time1;
                    
                }else{
                    
                    time=[NSString stringWithFormat:@"%@~%@",time1,time2];
                    
                }
            }else{
                
                time=time1;
                
                
            }
            NSString *thisTimeDisplayNum=[NSString stringWithFormat:@"%.1f",[data[@"thisTimeDisplayNum"] floatValue]];
            NSString *lastTimeDisplayNum=[NSString stringWithFormat:@"%.1f",[data[@"lastTimeDisplayNum"] floatValue]];
            NSString *useNum=[[NSString stringWithFormat:@"%.1f",[data[@"useNum"] floatValue]]  stringByAppendingString:@"立方"];
            NSString *unitPrice=[[NSString stringWithFormat:@"%.1f",[data[@"unitPrice"] floatValue]]  stringByAppendingString:@"元"];
            NSString *billAmount=[[NSString stringWithFormat:@"%.2f",[data[@"billAmount"] floatValue]]  stringByAppendingString:@"元"];
            self.datas =  @[
                            @{
                                @"title": @"业主",
                                @"detail": [KeychainManager readUserName]
                                },
                            @{
                                @"title": @"联系电话",
                                @"detail": [KeychainManager readMobileNum]
                                },
                            @{
                                @"title": @"缴费类型",
                                @"detail": billType
                                },
                            @{
                                @"title": @"账单时间",
                                @"detail": time
                                },
                            @{
                                @"title": @"本次表示数",
                                @"detail": thisTimeDisplayNum
                                },
                            @{
                                @"title": @"上次表示数",
                                @"detail": lastTimeDisplayNum
                                },
                            @{
                                @"title": @"用量",
                                @"detail": useNum
                                },
                            @{
                                @"title": @"单价说明",
                                @"detail": unitPrice
                                },
                            @{
                                @"title": @"应收总金额",
                                @"detail": billAmount
                                }
                            ];
            

            
        }
            break;
            
            
        default:
            break;
    }
    
}

-(void)getPropertyBillDetail
{
    [UserServices
     getPropertyBillDetailWithBillId:self.billID
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self configData:responseObject[@"data"]];
            [self.paySingleTableView reloadData];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    self.datas =  @[
//                   @{
//                       @"title": @"业主",
//                       @"detail": @"铭泰"
//                   },
//                   @{
//                       @"title": @"联系电话",
//                       @"detail": @"13353564564"
//                   },
//                   @{
//                       @"title": @"缴费类型",
//                       @"detail": @"水费"
//                   },
//                   @{
//                       @"title": @"账单时间",
//                       @"detail": @"2016.1"
//                   },
//                   @{
//                       @"title": @"本次表示数",
//                       @"detail": @"300"
//                   },
//                   @{
//                       @"title": @"上次表示数",
//                       @"detail": @"12"
//                   },
//                   @{
//                       @"title": @"用量",
//                       @"detail": @"100吨"
//                   },
//                   @{
//                       @"title": @"单价说明",
//                       @"detail": @"2元"
//                   },
//                   @{
//                       @"title": @"应收总金额",
//                       @"detail": @"300元"
//                   }
//                   ];
    
    self.title = @"物业缴费";
    
    [self getPropertyBillDetail];
}

- (void) createUI{
    
    self.paySingleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.paySingleTableView.dataSource = self;
    self.paySingleTableView.delegate = self;
    self.paySingleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (![self.typeStr isEqualToString:@"history"]) {
        self.paySingleTableView.tableFooterView = [self tableFooterView];
    }


    [self.paySingleTableView registerClass:[PropertyBillSingelCell class]
              forCellReuseIdentifier:[PropertyBillSingelCell cellIdentifier]];
    
    [self addSubview:self.paySingleTableView];
}

- (UIView *) tableFooterView{
    
    WeakSelf
    _footerView = [[PropertyInfoFooterView alloc] init];
    _footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 150);
    _footerView.bCallOnHandle = ^(){
        
        [UnityLHClass callTel:[KeychainManager readMobileNum]];
    };
    _footerView.bGotoPayHandle = ^(){
        
        PropertyPayBillViewController * vc = [[PropertyPayBillViewController alloc] init];
        vc.billType=[NSString stringWithFormat:@"0%ld",[weakSelf.data[@"billType"] integerValue]];
        vc.billIdS=weakSelf.data[@"id"];
        vc.sumPrice=[weakSelf.data[@"billAmount"] floatValue];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [vc receiveObject:^(id object) {
            weakSelf.paySingleTableView.tableFooterView=[UIView new];
        }];

    };
    return _footerView;
}


- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.paySingleTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    PropertyInfoSectionHeaderView * sectionHeaderView = [PropertyInfoSectionHeaderView view];
    sectionHeaderView.displayLabel.textColor = BM_Color_Blue;
    sectionHeaderView.displayLabel.text=[KeychainManager readDistrictAddress];
    return sectionHeaderView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyBillSingelCell * cell = [tableView dequeueReusableCellWithIdentifier:[PropertyBillSingelCell cellIdentifier] forIndexPath:indexPath];
    [cell configCellWithData:self.datas[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark -
#pragma mark Navigation M



#pragma mark -
#pragma mark Network M

@end
