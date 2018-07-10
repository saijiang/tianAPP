//
//  DropDownView.m
//  LankeProject
//
//  Created by itman on 16/11/29.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DropDownView.h"

@interface  DropDownView ()

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, copy) NSString *key;
@property (nonatomic,assign) NSInteger selectedRow;//选中的第几行

@end

@implementation DropDownView
@synthesize cBlock;
- (id)initWithFrame:(CGRect)frame
{
    frame.size = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:frame];
    if (self) {
        _hasCheckImage = YES;
        _rowHeight = 50.0f;
        _maxExhibitRow = 5;
        [KAPPDELEGATE.window addSubview:self];
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //创建
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews
{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    backView.alpha = 0;
    [self addSubview:backView];
    self.backView = backView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [backView addGestureRecognizer:tap];
    
    self.showTabelView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.showTabelView.tableFooterView=[UIView new];
    self.showTabelView.dataSource = self;
    self.showTabelView.separatorInset = UIEdgeInsetsZero;
    self.showTabelView.delegate = self;
    self.showTabelView.backgroundColor= [UIColor whiteColor];
    self.showTabelView.layer.masksToBounds=YES;
    self.showTabelView.layer.cornerRadius=10;
    [self addSubview:self.showTabelView];
}

- (void)resetWithSourceArray:(NSArray *)sourceArray
{
    self.sourceArray = sourceArray;
    [self.showTabelView reloadData];
}

- (void)resetWithDictSourceArray:(NSArray *)dictSourceArray withTitleKey:(NSString *)titleKey
{
    self.key = titleKey;
    self.sourceArray = dictSourceArray;
    [self.showTabelView reloadData];
    
}
- (void)showWithRect:(CGRect)rect suitableandExhibit:(BOOL)suitableand andEndChooseBlock:(endChooseData)endChooseBlock{
    
    if (suitableand) {
        NSInteger exhibitNumber = self.sourceArray.count >= self.maxExhibitRow ? self.maxExhibitRow : self.sourceArray.count;
        rect.size.height = self.rowHeight * exhibitNumber;
    }else{
        //
        rect.size.height = rect.size.height >self.rowHeight*7 ?self.rowHeight*7:rect.size.height;
    }
    
    self.tableRect = rect;
    self.showTabelView.frame = CGRectMake(rect.origin.x, rect.origin.y, self.tableRect.size.width, 0);
    self.endChooseBlock = endChooseBlock;
    [self animateShow];
}
- (void)showWithRect:(CGRect)rect andEndChooseBlock:(endChooseData)endChooseBlock
{
    [self showWithRect:rect suitableandExhibit:NO andEndChooseBlock:endChooseBlock];
}

- (void)showWithRect:(CGRect)rect andEndChooseDictBlock:(endChooseDictData)endChooseDictBlock
{
    float hight=[self tableView:nil heightForRowAtIndexPath:nil];
    //7 行展示
    rect.size.height = rect.size.height >hight*7 ?hight*7:rect.size.height;
    self.tableRect = rect;
    self.showTabelView.frame = CGRectMake(rect.origin.x, rect.origin.y, self.tableRect.size.width, 0);
    self.endChooseDictData = endChooseDictBlock;
    [self animateShow];
}

- (void) defaultSelectedAtIndex:(NSInteger)index{
    
    self.selectedRow = index;
    [self.showTabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void) setSelectedAtIndex:(NSInteger)index
{
    self.selectedRow = index;
    [self.showTabelView reloadData];

}

- (void)cancelBlock:(CancelBlock)canBlock
{
    self.cBlock=canBlock;
}
- (void)cancel
{
    [self animateHiddle];
    if (self.cBlock) self.cBlock();
}

#pragma mark -
#pragma mark Animation M

- (void)animateShow
{
    __block UITableView *blockTable = self.showTabelView;
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        blockTable.frame = self.tableRect;
        self.backView.alpha = 0.3;
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            
        }
        
    }];
}

- (void)animateHiddle
{
    __block UITableView *blockTable = self.showTabelView;
    __block DropDownView *blockSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        
        blockTable.frame = CGRectMake(self.tableRect.origin.x, self.tableRect.origin.y, self.tableRect.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [UIView animateWithDuration:0.1 animations:^{
                
                self.backView.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                if (finished)
                {
                    blockSelf.hidden = YES;
                    [self removeFromSuperview];
                }
            }];
        }
        
    }];
}


#pragma mark -
#pragma mark TableView M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenty = @"cellIdenty";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenty];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenty];
        cell.textLabel.textColor = BM_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        if (self.hasCheckImage) {
            LocalhostImageView *rightImage=[[LocalhostImageView alloc]init];
            rightImage.tag=1314;
            
            rightImage.image=[UIImage imageNamed:@"choose"];
            [cell.contentView addSubview:rightImage];
            [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
        }
    }
    LocalhostImageView *rightImage=[cell viewWithTag:1314];
    id source = self.sourceArray[indexPath.row];
    NSString *str = nil;
    if ([source isKindOfClass:[NSDictionary class]])
    {
        str = source[self.key];
    }
    else
    {
        str = source;
    }
    cell.textLabel.text = str;
    if (self.selectedRow==indexPath.row)
    {
        rightImage.hidden=NO;
    }
    else
    {
        rightImage.hidden=YES;
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedRow=indexPath.row;
    [tableView reloadData];
    id source = self.sourceArray[indexPath.row];
    if ([source isKindOfClass:[NSDictionary class]])
    {
        if (self.endChooseDictData) {
            self.endChooseDictData(source);
        }
    }
    if (self.endChooseBlock) {
        
        self.endChooseBlock(source,indexPath.row);
    }
    
    if (self.cBlock)
    {
        self.cBlock();
    }
    [self cancel];
}

-(void)viewDidLayoutSubviews
{
    if ([self.showTabelView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.showTabelView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
    }
    
    if ([self.showTabelView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.showTabelView setLayoutMargins:UIEdgeInsetsMake(0,15,0,15)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,15,0,15)];
    }
}

@end
