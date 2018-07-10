//
//  PropertyRepairRecordCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairRecordCell.h"

@implementation PropertyRepairRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.clipsToBounds=YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.topView = [PropertyTopView view];
        [self.contentView addSubview:self.topView];
        
        self.bottomView = [[PropertyBottomNewView alloc]init];
//        [self.bottomView.gotoCommentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//            if (self.bCommentHandle) {
//                self.bCommentHandle();
//            }
//        }];
//        [self.bottomView.handleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//            if (self.bOtherHandle) {
//                self.bOtherHandle();
//            }
//        }];
        [self.contentView addSubview:self.bottomView];
        
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.right.mas_equalTo(self.topView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{

    return @"PropertyRepairRecordCell";
}

- (void)configCellWithData:(id)data{

    [self.topView config:data];
    
    [self.bottomView config:data[@"listDesignat"]];
    [self.bottomView configFooterWithData:data];
    
}

+ (CGFloat)cellHeightWithData:(id)data{

    NSArray *array = [NSArray arrayWithArray:data[@"listDesignat"]];
    float hei = 190;
    if (array.count > 0)
    {
        hei = 140*(array.count)+50;
    }
    float hight=190;
    //repairState 	String 	报修状态（01：处理中， 02：已分派， 03：待评价， 04：完成， 05：已取消）
    switch ([data[@"repairState"] integerValue])
    {
        case 1:
        {
            hight=60;
        }
            break;
        case 2:
        {
//            hight=190;
            hight=60+90*array.count+50;
  
        }
            break;
        case 3:
        {
            hight=60+90*array.count+50;

        }
            break;
        case 4:
        {
//            hight=140;
            hight=60+90*array.count;
            

        }
            break;
        case 5:
        {
            hight=60+90*array.count;

        }
            break;
            
        default:
            break;
    }
    return hight;
}

@end

@implementation PropertyTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor randomColor];
        self.clipsToBounds=YES;

        self.iconImageView = [[LocalhostImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"property_repair_weixiu"];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [UnityLHClass masonryLabel:@"路灯坏了" font:15 color:[UIColor blackColor]];
        [self addSubview:self.titleLabel];
        
        self.timeLabel = [UnityLHClass masonryLabel:@"2015/12/3" font:13 color:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:self.timeLabel];
        
        self.statusLabel = [UnityLHClass masonryLabel:@"处理中" font:15 color:[UIColor redColor]];
        [self addSubview:self.statusLabel];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.right.mas_equalTo(self.mas_right).mas_offset(-60);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
}
+ (instancetype)view{

    return [[self alloc] init];
}
- (void)config:(id)data
{
    //repairState 	String 	报修状态（01：处理中， 02：已分派， 03：待评价， 04：完成， 05：已取消）
    
    NSLog(@"%@",data);
    
    
    self.titleLabel.text=data[@"repairContent"];
    self.timeLabel.text=[UnityLHClass getCurrentTimeWithType:@"yyyy/MM/dd" andTimeString:data[@"repairTime"]];
    NSString *repairState=@"处理中";
    UIColor *color= [UIColor redColor];
    switch ([data[@"repairState"] integerValue])
    {
        case 1:
        {
            repairState=@"处理中";
            color= [UIColor redColor];
        }
            break;
        case 2:
        {
            repairState=@"已分派";
            color= [UIColor colorWithRed:0.58 green:0.89 blue:0.66 alpha:1.00];
        }
            break;
        case 3:
        {
            repairState=@"待评价";
            color= [UIColor colorWithRed:0.99 green:0.72 blue:0.45 alpha:1.00];

        }
            break;
        case 4:
        {
            repairState=@"已完成";
            color= [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00];

        }
            break;
        case 5:
        {
            repairState=@"已取消";
            color= [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00];

        }
            break;
            
        default:
            break;
    }
    self.statusLabel.text=repairState;
    self.statusLabel.textColor=color;
}
@end

//2017.07.28
@implementation PropertyBottomNewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
    
}

-(void)createUI
{
    self.tableCtrl = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableCtrl.scrollEnabled = NO;
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.tableFooterView=[UIView new];
    self.tableCtrl.backgroundColor=BM_CLEAR;
    [self addSubview:_tableCtrl];
    
    
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.10;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.data[@"repairState"] integerValue] == 4)
    {
        return 0.1;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyBottomCell *cell = [PropertyBottomCell cellWithTableView:tableView];
    [cell loadCellWithDataSource:self.dataSource[indexPath.row] type:self.data[@"repairState"]];
    if (indexPath.row == 0)
    {
        cell.topLineView.hidden = NO;
    }
    else
    {
        cell.topLineView.hidden = YES;
    }
    
    [cell.gotoCommentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self sendObject:@{@"title":@"评论",@"data":self.dataSource[indexPath.row]}];
    }];
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.data[@"repairState"] integerValue] == 4)
    {
        return nil;
    }
    else
    {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50)];
        footerView.backgroundColor = BM_WHITE;
        
        self.handleButton = [LKBottomButton buttonWithType:UIButtonTypeCustom];
        _handleButton.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 50);
        _handleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_handleButton setTitle:@"" forState:UIControlStateNormal];
        [footerView addSubview:_handleButton];
        [_handleButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(footerView.mas_right).offset(-10);
            make.top.mas_equalTo(footerView.mas_top);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        [_handleButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self sendObject:@{@"title":@"确认完成",@"data":self.dataSource}];
        }];
        
        UIView *botoomView = [UIView lineView];
        botoomView.frame = CGRectMake(0, DEF_BOTTOM(footerView)-0.5, DEF_SCREEN_WIDTH, 0.5);
        [footerView addSubview:botoomView];
        
        UIColor *color= [UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
        NSString *handleString=@"确认完成";
        UIColor *handleColor= BM_Color_Blue;
        switch ([self.data[@"repairState"] integerValue])
        {
                
            case 2:
            {
                color= [UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
                handleColor= color;
                handleString=@"确认完成";
            }
                break;
            case 3:
            {
                color= [UIColor colorWithRed:0.99 green:0.72 blue:0.45 alpha:1.00];
                handleColor= color;
                handleString=@"去评价";
                
            }
                break;
                
                
            default:
                break;
        }
        [_handleButton hll_setBackgroundImageWithColor:handleColor
                                              forState:UIControlStateNormal];
        [_handleButton setTitle:handleString forState:UIControlStateNormal];
        
        return footerView;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self sendObject:@{@"title":@"评论",@"data":self.dataSource[indexPath.row]}];
}

- (void)config:(id)data
{
    self.dataSource = data;
    [self.tableCtrl reloadData];
}

-(void)configFooterWithData:(id)data
{
    
    self.data = data;
    [self.tableCtrl reloadData];
}

@end

@implementation PropertyBottomCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    PropertyBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyBottomCell"];
    if (!cell)
    {
        cell = [[PropertyBottomCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PropertyBottomCell"];
    }
    return cell;
}

-(void)createCell
{
    self.clipsToBounds=YES;
    self.topLineView = [UIView lineView];
    [self addSubview:self.topLineView];
    
    self.iconImageView = [[LKNetworkImageView alloc] init];
    self.iconImageView.placeholderImage = [UIImage imageNamed:@"detault_user_icon"];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 25;
    [self addSubview:self.iconImageView];
    
    self.nameLabel = [UnityLHClass masonryLabel:@"张师傅" font:15 color:[UIColor blackColor]];
    [self addSubview:self.nameLabel];
    
    self.phoneLabel = [UnityLHClass masonryLabel:@"147677578" font:14 color:[UIColor colorWithHexString:@"999999"]];
    [self addSubview:self.phoneLabel];
    
    self.gradeView = [[AXRatingView alloc] init];
    self.gradeView.numberOfStar = 5;
    self.gradeView.value = 4.6;
    self.gradeView.markFont = [UIFont systemFontOfSize:16];
    self.gradeView.baseColor = [UIColor colorWithHexString:@"#CCCCCC"];
    self.gradeView.highlightColor = [UIColor colorWithHexString:@"#FDCD63"];
    [self.gradeView setStepInterval:1.0];
    self.gradeView.userInteractionEnabled = NO;
    [self addSubview:self.gradeView];
    
    self.scoreLabel = [UnityLHClass masonryLabel:@"" font:15 color:[UIColor blackColor]];
    [self addSubview:self.scoreLabel];
    
    self.gotoCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gotoCommentButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.gotoCommentButton setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    [self.gotoCommentButton setTitle:@"查看评论" forState:UIControlStateNormal];
    [self addSubview:self.gotoCommentButton];
    
    self.bottomLineView = [UIView lineView];
    [self addSubview:self.bottomLineView];
    
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.top).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.iconImageView.mas_top).mas_offset(5);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(10);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
    
    [self.gradeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.scoreLabel.mas_centerY);
        make.right.mas_equalTo(self.scoreLabel.mas_left).mas_offset(-10);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(20);
    }];
    [self.gotoCommentButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY).offset(16);
        make.right.mas_equalTo(self.scoreLabel.mas_right);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.iconImageView.mas_left);
        make.right.mas_equalTo(self.scoreLabel.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(20);
    }];
    
    
}

+ (instancetype)view{
    
    return [[self alloc] init];
}

- (void)loadCellWithDataSource:(id)data type:(id)type{
    
    self.gradeView.hidden=YES;
    self.scoreLabel.hidden=YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data[@"employeeHeadImage"]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    self.nameLabel.text=data[@"userName"];
    self.phoneLabel.text=data[@"propertyMobileNum"];
    
    if ([data[@"evalScores"] floatValue]==0) {
        self.scoreLabel.text=[NSString stringWithFormat:@"0分"];
    }else{
        self.scoreLabel.text=[NSString stringWithFormat:@"%.1f分",[data[@"evalScores"] floatValue]];
    }
    self.gradeView.value=[data[@"evalScores"] floatValue];
       NSString *repairState=@"处理中";
    UIColor *color= [UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
    NSString *handleString=@"确认完成";
    UIColor *handleColor= BM_Color_Blue;
    switch ([type integerValue])
    {
        case 1:
        {
            repairState=@"处理中";
        }
            break;
        case 2:
        {
            repairState=@"已分派";
            color= [UIColor colorWithRed:0.39 green:0.69 blue:0.86 alpha:1.00];
            handleColor= color;
            handleString=@"确认完成";
        }
            break;
        case 3:
        {
            repairState=@"待评价";
            color= [UIColor colorWithRed:0.99 green:0.72 blue:0.45 alpha:1.00];
            handleColor= color;
            handleString=@"去评价";
            
        }
            break;
        case 4:
        {
            self.gradeView.hidden=NO;
            self.scoreLabel.hidden=NO;

            repairState=@"完成";
      
            

        }
            break;
        case 5:
        {
            repairState=@"已取消";
        }
            break;
            
        default:
            break;
    }
   
    
}
@end
