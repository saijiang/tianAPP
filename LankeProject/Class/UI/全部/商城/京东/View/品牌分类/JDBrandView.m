//
//  JDBrandView.m
//  LankeProject
//
//  Created by fud on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDBrandView.h"
#import "NSString+PinYin.h"

#define TableWidth  DEF_SCREEN_WIDTH*0.85
#define TableLeft  DEF_SCREEN_WIDTH*0.15

@interface JDBrandView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableCtrl;
@property (nonatomic,strong)UITableView *sectionIndexTableCtrl;
@property (nonatomic,strong)NSMutableArray *arrayOfCharacters;
@property (nonatomic,strong)NSMutableArray *nameArray;//数据源

@property (nonatomic,strong)UIView *tableHeaderView;

@end

@implementation JDBrandView

- (instancetype)initWithFrame:(CGRect)frame DataSource:(NSArray*)dataSource
{
    
    self=[super initWithFrame:frame];
    if (self)
    {
        _arrayOfCharacters = [[NSMutableArray alloc]init];
        [_arrayOfCharacters addObjectsFromArray:@[@"a",@"b",@"c",@"d",@"e"]];
        self.hidden=YES;
        self.frame=KAPPDELEGATE.window.bounds;
        [KAPPDELEGATE.window addSubview:self];
        UIView *backView=[[UIView alloc]init];
        backView.frame=self.bounds;
        backView.backgroundColor=BM_BLACK;
        backView.alpha=0.3;
        [self addSubview:backView];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [backView addGestureRecognizer:tap];
        
        self.nameArray=[NSMutableArray arrayWithArray:[dataSource arrayWithPinYinFirstLetterFormat]];
        
        [self createUI];
        
    }
    return self;
    
}

- (void)createUI
{
    [self addSubview:self.tableHeaderView];
  
    
    self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(TableLeft, DEF_BOTTOM(self.tableHeaderView), TableWidth, DEF_SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableCtrl.backgroundColor = BM_WHITE;
    self.tableCtrl.delegate = self;
    self.tableCtrl.dataSource = self;
    self.tableCtrl.tableFooterView = [UIView new];
    [self.tableCtrl registerClass:[UITableViewCell class] forCellReuseIdentifier:@"REUSE_CELLID"];
    [self.tableCtrl registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];


    self.tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableCtrl.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableCtrl];
}

-(UIView *)tableHeaderView
{
    if (!_tableHeaderView)
    {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(TableLeft, 0, TableWidth, 64)];
        _tableHeaderView.backgroundColor = BM_WHITE;
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
        [_tableHeaderView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_tableHeaderView.mas_centerY).offset(10);
            make.left.mas_equalTo(_tableHeaderView.mas_left);
            make.height.mas_equalTo(_tableHeaderView);
            make.width.mas_equalTo(40);
        }];
        
        UILabel *titleLab = [UnityLHClass masonryLabel:@"品牌" font:16.0 color:BM_BLACK];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_tableHeaderView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_tableHeaderView.mas_centerY).offset(10);
            make.centerX.mas_equalTo(_tableHeaderView.mas_centerX);
        }];
    }
    
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.titleLabel.font = BM_FONTSIZE15;
//    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:BM_GRAY forState:UIControlStateNormal];
//    [rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//
//        [self sendObject:@"ok"];
//        [self dismissView];
//
//    }];
//    [headerView addSubview:rightBtn];
//    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(headerView.mas_right);
//        make.centerY.mas_equalTo(headerView.mas_centerY);
//        make.height.mas_equalTo(headerView);
//        make.width.mas_equalTo(60);
//    }];
    
    return _tableHeaderView;
}

#pragma mark ---- 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.nameArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
   NSString*cellName = array[indexPath.row];
    CGFloat height=  [UnityLHClass getHeight:cellName wid:DEF_WIDTH(tableView)-30 font:15]+25;
    return height;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        return 1;
//    }else{
        NSDictionary *dict = self.nameArray[section];
        NSMutableArray *array = dict[@"content"];
        return [array count];
    //}
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    NSDictionary *dict = self.nameArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
   // cell.textLabel.textColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1.0];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        
//    }
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(cell)-0.8, DEF_SCREEN_WIDTH, 0.8)];
//    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [cell.contentView addSubview:line];
//    cell.textLabel.text = @"测试测试";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //自定义Header标题
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
    titleLabel.textColor=[UIColor blackColor];
    NSString *title = self.nameArray[section][@"firstLetter"];
    titleLabel.text=title;
    
    [myView  addSubview:titleLabel];
    
    return myView;
//    UILabel *lable = [UnityLHClass masonryLabel:@"A" font:16.0 color:BM_BLACK];
//    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    lable.text = [NSString stringWithFormat:@"   A"];
//    return lable;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.nameArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    NSString*nameStr=array[indexPath.row];
    [self sendObject:nameStr];
    
    [self dismissView];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView

{
    NSMutableArray *resultArray =[NSMutableArray array];
    for (NSDictionary *dict in self.nameArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
//    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
//    
//    for(char c = 'A';c<='Z';c++)
//        
//        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
//    
//    return toBeReturned;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
      return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]; // -1 添加了搜索标识
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
//    if ([title isEqualToString:UITableViewIndexSearch])
//    {
//        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
//        return NSNotFound;
//    }
//    else
//    {
//        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
//    }
//    NSInteger count = 0;
//    for(NSString *character in _arrayOfCharacters)
//    {
//        if([character isEqualToString:title])
//            
//        {
//            return count;
//        }
//        count ++;
//    }
//    
//    return 0;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    
//    if([_arrayOfCharacters count]==0)
//    {
//        return @"";
//    }
//    return [_arrayOfCharacters objectAtIndex:section];
//}


-(void)showViewWithChooseBlock:(SideChooseBlock)sideChoose
{
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        self.hidden=NO;

    }];
}

-(void)dismissView
{
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        self.hidden=YES;

        //[self removeFromSuperview];
    }];
}

-(void)dismiss
{
    [self sendObject:@"close"];
    
    [self dismissView];
}

@end
