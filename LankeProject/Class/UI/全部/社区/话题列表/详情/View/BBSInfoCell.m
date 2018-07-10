//
//  BBSInfoCell.m
//  LankeProject
//
//  Created by itman on 17/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//



#import "BBSInfoCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface BBSInfoCell ()

@property(nonatomic,strong)UILabel *bbsUserName;
@property(nonatomic,strong)NetworkImageView *bbsUserIcon;

@property(nonatomic,strong)UILabel *bbsTitle;
@property(nonatomic,strong)UILabel *bbsTime;
@property(nonatomic,strong)UILabel *bbsInfo;
@property(nonatomic,strong)BBSInfoImageView *bbsIcon;
@property(nonatomic,strong)UIButton *bbsComments;

@property(nonatomic,strong)UIButton *bbsDelete;
@property(nonatomic,strong)UIButton *bbsLahei;

@end
@implementation BBSInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    BBSInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BBSInfoCell"];
    if (!cell)
    {
        cell=[[BBSInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BBSInfoCell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

+(CGFloat)getCellHightWithDataSource:(id)dataSource
{
    CGFloat hight=0;
    hight+=10;
    hight+=50;
    hight+=10;
    hight+=20;
    hight+=10;
    hight+=16;
    hight+=10;
    hight+=DEF_SCREEN_WIDTH/2.0*[dataSource[@"imageArr"] count];
    hight+=20;
    hight+=[UnityLHClass getHeight:dataSource[@"topicContent"] wid:DEF_SCREEN_WIDTH-30 font:14.0];
    return hight;
}
-(void)createCell
{
    self.bbsUserIcon =[[NetworkImageView alloc]init];
    self.bbsUserIcon.image=[UIImage imageNamed:@"Community_pic"];
    [self.contentView addSubview:self.bbsUserIcon];
    
    self.bbsUserName=[UnityLHClass masonryLabel:@"西门吹雪" font:14.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.bbsUserName];

    self.bbsDelete=[UnityLHClass masonryButton:@"" imageStr:@"Community_shanchu" font:13.0 color:BM_Color_Blue];
    [self.contentView addSubview:self.bbsDelete];
    
    self.bbsLahei=[UnityLHClass masonryButton:@"" imageStr:@"Community_lahei" font:13.0 color:BM_Color_Blue];
    [self.contentView addSubview:self.bbsLahei];
    
    self.bbsTitle=[UnityLHClass masonryLabel:@"《华东的雪》寒冬枝头百丈雪" font:16.0 color:BM_BLACK];
    [self.contentView addSubview:self.bbsTitle];
    
    self.bbsTime=[UnityLHClass masonryLabel:@"2017-03-14 17:00" font:13.0 color:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.bbsTime];
    
    self.bbsInfo=[UnityLHClass masonryLabel:@"" font:14.0 color:BM_Color_GrayColor];
    [self.contentView addSubview:self.bbsInfo];
    self.bbsInfo.numberOfLines=0;
    
    self.bbsIcon =[[BBSInfoImageView alloc]init];
    [self.contentView addSubview:self.bbsIcon];
    
    self.bbsComments=[UnityLHClass masonryButton:@"100" imageStr:@"BBS_huifu" font:13.0 color:BM_Color_Blue];
    self.bbsComments.userInteractionEnabled=NO;
    [self.bbsComments layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.contentView addSubview:self.bbsComments];
    
    //删除话题
    [self.bbsDelete handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定删除该话题？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                [self sendObject:@"0"];
            }
        }];
    }];
    
    //踢出群组
    [self.bbsLahei handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"确定拉黑该用户？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==1)
            {
                [self sendObject:@"1"];
            }
        }];

    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bbsUserIcon.layer.masksToBounds=YES;
    self.bbsUserIcon.layer.cornerRadius=50/2.0;
    [self.bbsUserIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.and.height.mas_equalTo(50);
    }];
    
    [self.bbsUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bbsUserIcon.mas_right).offset(5);
        make.centerY.mas_equalTo(self.bbsUserIcon.mas_centerY);
    }];
    
    [self.bbsLahei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.bbsUserIcon.mas_centerY);

    }];
    
    [self.bbsDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bbsLahei.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.bbsUserIcon.mas_centerY);
        
    }];
    
    [self.bbsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bbsUserIcon.mas_left);
        make.top.mas_equalTo(self.bbsUserIcon.mas_bottom).offset(10);
    }];
    
    [self.bbsComments mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.bbsTitle.mas_centerY);
    }];
    
    [self.bbsTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bbsTitle.mas_left);
        make.top.mas_equalTo(self.bbsTitle.mas_bottom).offset(10);
    }];
    
    [self.bbsInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.bbsTitle.mas_left);
        make.top.mas_equalTo(self.bbsTime.mas_bottom).offset(10);
    }];
    
    [self.bbsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.bbsTitle.mas_left);
        make.top.mas_equalTo(self.bbsInfo.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    [self.bbsUserIcon sd_setImageWithURL:[NSURL URLWithString:dataSource[@"headImage"]]];
    self.bbsUserName.text=dataSource[@"nickName"];
    self.bbsTitle.text=dataSource[@"topicTitle"];
    self.bbsTime.text=[UnityLHClass getCurrentTimeWithType:@"yyyy-MM-dd HH:mm" andTimeString:dataSource[@"publishTime"]];
    self.bbsInfo.text=dataSource[@"topicContent"];
    [self.bbsIcon loadViewWithDataSource:dataSource[@"imageArr"]];
    [self.bbsComments setTitle:[NSString stringWithFormat:@"%d",[dataSource[@"commentCount"] intValue]] forState:UIControlStateNormal];
    
    //注：如果是非官方话题，群主则可剔除用户，删除话题，删除评论，反之isGroup 	String 	是否是群主（0否，1是）
    //注：如果是官方话题，话题上面的剔除隐藏，群主可以删除评论，可以剔除评论的用户topicFoundType 	String 	话题创建类型（01：官方, 02：非官方）
    //[dataSource[@"topicFoundType"] integerValue]==1
    
    //踢出功能
    if ([dataSource[@"isGroup"] integerValue]==1)
    {
        self.bbsLahei.hidden=NO;
        if ([dataSource[@"topicFoundType"] integerValue]==1||[dataSource[@"publishUserId"] isEqualToString:[KeychainManager readUserId]])
        {
            self.bbsLahei.hidden=YES;

        }
    }
    else
    {
        self.bbsLahei.hidden=YES;

    }

    //删除帖子能
    if ([dataSource[@"isGroup"] integerValue]==1)
    {
        //群主
        self.bbsDelete.hidden=NO;

    }
    else
    {
        self.bbsDelete.hidden=YES;

    }
}

-(void)setCommentCount:(int)commentCount
{
    [self.bbsComments setTitle:[NSString stringWithFormat:@"%d",commentCount] forState:UIControlStateNormal];

}

@end

@interface BBSInfoImageView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSArray *imageDataSource;

@end

@implementation BBSInfoImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame: frame];
    if (self) {
        [self createUI];
    }
    return  self;
    
}

- (UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        self.tableCtrl.backgroundColor=BM_WHITE;
        self.tableCtrl.scrollEnabled=NO;
        self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView=[UIView new];
    }
    return _tableCtrl;
}

- (void)createUI
{
    [self addSubview:self.tableCtrl];
    [self.tableCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.imageDataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEF_SCREEN_WIDTH/2.0-10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"]
    ;
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        NetworkImageView *imageView=[[NetworkImageView alloc]init];
        imageView.tag=100;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
    }
    NetworkImageView *imageView=(NetworkImageView *)[cell.contentView viewWithTag:100];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageDataSource[indexPath.section]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *broArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < [tableView numberOfSections]; i++)
//    {
//        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
//        for (UIView* imageView in cell.contentView.subviews)
//        {
//            if ([imageView isKindOfClass:[NetworkImageView class]])
//            {
//                MJPhoto *photo = [[MJPhoto alloc]init];
//                NetworkImageView *netImageView=(NetworkImageView *)imageView;
//                photo.image = netImageView.image;
//                photo.srcImageView = netImageView;
//                [broArray addObject:photo];
//            }
//        }
//    }
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = indexPath.section; // 弹出相册时显示的第一张图片是？
//    browser.photos = broArray; // 设置所有的图片
//    [browser show];
    
}

-(void)loadViewWithDataSource:(NSArray *)imageArray
{
    self.imageDataSource=imageArray;
    [self.tableCtrl reloadData];
}


@end
