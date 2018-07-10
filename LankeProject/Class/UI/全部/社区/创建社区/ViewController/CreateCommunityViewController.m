//
//  CreateCommunityViewController.m
//  LankeProject
//
//  Created by itman on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "CreateCommunityViewController.h"
#import "JYZTextView.h"

@interface CreateCommunityViewController ()

@property(nonatomic,strong)UITextField *name;
@property(nonatomic,strong)UILabel *type;
@property(nonatomic,strong)JYZTextView *introduction;

@property(nonatomic,strong)UILabel *matters;

@property(nonatomic,strong)UIButton *agreed;


@end

@implementation CreateCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavBarCustomByTitle:@"创建社群"];
}
-(void)createUI
{
    UIView *oneView=[[UIView alloc]init];
    oneView.backgroundColor=BM_WHITE;
    [self addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *name=[UnityLHClass masonryLabel:@"社群名字" font:15.0 color:BM_BLACK];
    [oneView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(oneView.mas_centerY);
    }];
    
    self.name=[UnityLHClass masonryField:@"请输入社群名字" font:15.0 color:BM_BLACK];
    [oneView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(100);
        make.centerY.mas_equalTo(oneView.mas_centerY);
    }];
    UIView *lineOne=[[UIView alloc]init];
    lineOne.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [oneView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(oneView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIView *twoView=[[UIView alloc]init];
    twoView.backgroundColor=BM_WHITE;
    [self addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(50);
    }];
    UILabel *type=[UnityLHClass masonryLabel:@"社群分类" font:15.0 color:BM_BLACK];
    [twoView addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(twoView.mas_centerY);
    }];
    
    self.type=[UnityLHClass masonryLabel:@"户外" font:15.0 color:BM_BLACK];
    [twoView addSubview:self.type];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(100);
        make.centerY.mas_equalTo(twoView.mas_centerY);
    }];
    UIImageView *goimageView=[[UIImageView alloc]init];
    goimageView.image=[UIImage imageNamed:@"right_arrow"];
    goimageView.userInteractionEnabled=YES;
    [twoView addSubview:goimageView];
    [goimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(twoView.mas_centerY);
        make.right.mas_equalTo(-15);

    }];
    
    UIView *lineTwo=[[UIView alloc]init];
    lineTwo.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [twoView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(twoView.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [twoView addGestureRecognizer:tap];
    
    UIView *threeView=[[UIView alloc]init];
    threeView.backgroundColor=BM_WHITE;
    [self addSubview:threeView];
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(150);
    }];
    UILabel *introduction=[UnityLHClass masonryLabel:@"社群简介" font:15.0 color:BM_BLACK];
    [threeView addSubview:introduction];
    [introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(13);
    }];

    self.introduction=[[JYZTextView alloc]init];
    self.introduction.font=BM_FONTSIZE(15.0);
    self.introduction.placeholder=@"请输入社群简介";
    [threeView addSubview:self.introduction];
    [self.introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(threeView.mas_top).offset(5);
        make.bottom.mas_equalTo(threeView.mas_bottom).offset(-10);
    }];
    
    
    UIView *fourView=[[UIView alloc]init];
    fourView.backgroundColor=BM_WHITE;
    [self addSubview:fourView];
   
    UILabel *matters=[UnityLHClass masonryLabel:@"创建社群须知" font:15.0 color:BM_BLACK];
    [fourView addSubview:matters];
    [matters mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(fourView.mas_top).offset(15);
    }];
    
    self.matters=[UnityLHClass masonryLabel:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget." font:15.0 color:BM_Color_GrayColor];
    [fourView addSubview:self.matters];
    self.matters.numberOfLines=0;

    [self.matters mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(matters.mas_bottom).offset(15);
        make.bottom.mas_equalTo(fourView.mas_bottom).offset(-15);

    }];
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(threeView.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.matters.mas_bottom).offset(15);
    }];
    
    UIView *lineThree=[[UIView alloc]init];
    lineThree.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [fourView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(fourView.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    UIView *fiveView=[[UIView alloc]init];
    fiveView.backgroundColor=BM_WHITE;
    [self addSubview:fiveView];
    [fiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fourView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-70);
    }];
    self.agreed=[UnityLHClass masonryButton:@"同意创建社群须知内容" imageStr:@"no_choose" font:14.0 color:BM_BLACK];
    [self.agreed setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    self.agreed.selected=YES;
    [self.agreed layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [fiveView addSubview:self.agreed];
    [self.agreed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(fiveView.mas_centerY);
    }];
    [self.agreed handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        self.agreed.selected=!self.agreed.selected;
    }];
    
    UIButton *submit=[UnityLHClass masonryButton:@"提交申请" font:15.0 color:BM_WHITE];
    [self.view addSubview:submit];
    submit.backgroundColor=BM_Color_Blue;
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    [submit handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [UnityLHClass showHUDWithStringAndTime:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)tap
{
   
    NSArray *dropArray=@[@"户外",@"垂钓",@"亲子",@"讲座",];
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"户外",@"垂钓",@"亲子",@"讲座", nil];
    [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex<dropArray.count)
        {
            self.type.text =dropArray[buttonIndex];
        }
        
    }];


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
