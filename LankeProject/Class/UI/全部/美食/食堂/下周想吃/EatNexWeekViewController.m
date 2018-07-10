//
//  EatNexWeekViewController.m
//  LankeProject
//
//  Created by itman on 16/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "EatNexWeekViewController.h"
#import "DishesDetailViewController.h"
#import "HLLPickView.h"
#import "HLLValuationBottomView.h"
#import "MessagePopupContentView.h"
#import "EatNextWeekManager.h"

@interface EatNexWeekViewController ()

@property (nonatomic ,strong) EatNextWeekManager * manager;

@property (nonatomic ,strong) HLLPickView * takeoutListMenuView;

@end

@implementation EatNexWeekViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _manager = [[EatNextWeekManager alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"下周想吃";
    
    [self showRightBarButtonItemHUDByName:@"留言"];
    
    [self creatUI];
    
    [self requestNextWeekList];
}

- (void) creatUI{
    
    self.takeoutListMenuView = [[HLLPickView alloc] init];
    self.takeoutListMenuView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.takeoutListMenuView];
    
    LKWeakSelf
    [self.manager configPickView:self.takeoutListMenuView];
    self.manager.bPickViewDidSelectItemWithDataHandle = ^(id data){
        LKStrongSelf
        [_self navigationToTakeOutDetailWithData:data];
    };
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [self.takeoutListMenuView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(0);
    }];
}

- (void)baseRightBtnAction:(UIButton *)btn{

    //
    LKWeakSelf
    MessagePopupContentView * popupContentView = [[MessagePopupContentView alloc] init];
    popupContentView.bCommitButtonHandle = ^(NSString * content){
        
        LKStrongSelf
        [_self requestSaveMessageWithContent:content];
    };

    HLLPopupView * popupView = [HLLPopupView tipInWindow:popupContentView];
    [popupView show:YES];
}


#pragma mark -
#pragma mark Navigation M

- (void) navigationToTakeOutDetailWithData:(id)data{
    
    // 跳转至详情界面
    DishesDetailViewController * detail = [[DishesDetailViewController alloc] init];
    detail.dishesData = data;
    //detail.hasBottomView = NO;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark -
#pragma mark Network M

- (void) requestNextWeekList{
    
    [UserServices nextWeekMenuDetailWithrRstaurantId:self.restaurantData[@"id"]
                                              userId:[KeychainManager readUserId]
                                     completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            id data = responseObject[@"data"];
            
            [self.manager configManagerWith:data];
            
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestSaveMessageWithContent:(NSString *)content{
    
    [UserServices saveMessageWithUserId:[KeychainManager readUserId] userName:[KeychainManager readUserName] restaurantId:self.restaurantData[@"id"] messageContent:content completionBlock:^(int result, id responseObject) {
       
        if (result == 0) {
            [UnityLHClass showHUDWithStringAndTime:@"留言成功"];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
