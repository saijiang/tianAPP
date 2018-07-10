//
//  FitnessConsultViewController.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessConsultViewController.h"
#import "FitnessMessageCell.h"
#import "FitnessMessage.h"
#import "FitnessMessageInputView.h"
#import "IQKeyboardManager.h"

@interface FitnessConsultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * chatTableView;
@property (nonatomic ,strong) FitnessMessageInputView * inputView;
@property (nonatomic ,strong) NSMutableArray * messages;
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation FitnessConsultViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeTimer];
}

/** type 在线客服类型（01：健康 02：健身） */
- (instancetype) initWithType:(NSString *)type{

    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.messages = [NSMutableArray array];
        self.type = @"02";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestGetOnlineService];
    [self addTimer];
    
}

#pragma mark - 对定时器的操作
- (void)addTimer
{
    if (!self.progressTimer)
    {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(requestGetOnlineService) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)removeTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
}
- (void)createUI
{
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.chatTableView.backgroundColor = [UIColor clearColor];
    self.chatTableView.backgroundView = nil;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    UIView * headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
    self.chatTableView.tableHeaderView = headerView;
    [self.chatTableView registerClass:[FitnessMessageCell class]
               forCellReuseIdentifier:[FitnessMessageCell cellIdentifier]];
    self.chatTableView.tableFooterView = [UIView new];
    [self addSubview:self.chatTableView];
  
    
    //下拉刷新
    LKWeakSelf
    [self.chatTableView addHeaderWithCallback:^{
        LKStrongSelf
        [_self requestGetOnlineService];
        [_self.chatTableView headerEndRefreshing];
    }];
    

    
    self.inputView = [FitnessMessageInputView view];
    self.inputView.bSendHandle = ^(NSString * content){
        
        LKStrongSelf
        [_self requestSendMessage:content];
    };

    [self addSubview:self.inputView];
    self.chatTableView.frame=CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT-50);
    self.inputView.frame=CGRectMake(0, DEF_BOTTOM(self.chatTableView),DEF_SCREEN_WIDTH, 50);
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//- (void)viewDidLayoutSubviews{
//
//    [super viewDidLayoutSubviews];
//    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//        make.height.mas_equalTo(50);
//        make.right.mas_equalTo(self.view.mas_right);
//    }];
//
//    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.and.top.mas_equalTo(0);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.inputView.mas_top);
//    }];
//}

- (void)keyboardwillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat height = beginFrame.size.height;

    CGFloat animationHeight = 0;
    if (beginFrame.origin.y > endFrame.origin.y) {// show
        animationHeight = -height;
        
    }else{// hide
        animationHeight = 0;
    }
    void(^animations)() = ^{
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make){
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(animationHeight);
        }];
        if ([self.chatTableView numberOfRowsInSection:0] ) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.chatTableView numberOfRowsInSection:0] - 1 inSection:0];
            [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
        
        self.chatTableView.contentOffset = CGPointMake(self.chatTableView.contentOffset.x, self.chatTableView.contentOffset.y - animationHeight);
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    [self.inputView.textInputView resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [FitnessMessageCell cellHeightWithData:self.messages[indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //
    NSDate * day = [NSDate date];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    UIView * contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.text = [dateFormatter stringFromDate:day];
    dateLabel.textColor = [UIColor colorWithHexString:@"454545"];
    [contentView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    return contentView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FitnessMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:[FitnessMessageCell cellIdentifier] forIndexPath:indexPath];
    [cell configCellWithData:self.messages[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return;
    }
    //
}

#pragma mark -
#pragma mark Network M

- (void) requestGetOnlineService{
    
    // 接口
    [UserServices getOnlineServiceWithUserId:[KeychainManager readUserId] serviceType:self.type completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            NSArray * datas = responseObject[@"data"];
            [self.messages removeAllObjects];
            if (datas && datas.count) {

                for (NSDictionary * data in datas) {
                    FitnessMessage * message = [FitnessMessage data:data];
                    [self.messages addObject:message];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.chatTableView reloadData];
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
                    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                });
            }
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestSendMessage:(NSString *)message{
    
    // 发送消息接口
    [UserServices sendOnlineServiceWithUserId:[KeychainManager readUserId] serviceType:self.type content:message userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            [self requestGetOnlineService];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}
@end
