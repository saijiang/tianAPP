//
//  RestaurantSectionView.m
//  LankeProject
//
//  Created by itman on 16/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "RestaurantSectionView.h"
#import "ProvinceRegionManager.h"

@interface RestaurantSectionView ()<ChooseNumberDelegate>

@property(nonatomic,strong)ChooseNumberView *chooseView;

@property (nonatomic ,strong) Region * region;

@end

@implementation RestaurantSectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        self.region = [[Region alloc] init];
        
        self.chooseView=[[ChooseNumberView alloc]init];
        self.chooseView.backgroundColor=BM_WHITE;
        self.chooseView.delegate=self;
        [self configChooseNuberView];
        [self addSubview:self.chooseView];
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (void) configChooseNuberView
{
    NSArray * categoryName = @[@"北京",@"北京市",@"海淀区",];
    NSMutableArray *itemArr=[[NSMutableArray alloc]init];
    for (int i=0; i<categoryName.count; i++)
    {
        ChooseNumberItem *item=[[ChooseNumberItem alloc]init];
        item.title = categoryName[i];
        item.image=[UIImage imageNamed:@"ding_xiala"];
        item.seletedImage=[UIImage imageNamed:@"ding_xiala"];
        [itemArr addObject:item];
    }
    self.chooseView.itemArray=itemArr;
}

-(void)chooseNumberView:(ChooseNumberView *)chooseNumberView SeletedItem:(UIButton *)chooseButton didSeletedIndex:(NSInteger)index
{
    
    NSInteger defaultSelectIndex = 0;
    
    NSArray * data ;
    if (index == 0) {
        data = [self.region provinceInfo];
        defaultSelectIndex = self.region.selectProvinceIndex;
    }
    if (index == 1) {
        data = [self.region cityInfo];
        defaultSelectIndex = self.region.selectCityIndex;
    }
    if (index == 2) {
        data = [self.region regionInfo];
        defaultSelectIndex = self.region.selectRegionIndex;
    }
    DropDownView *drop=[[DropDownView alloc]initWithFrame:CGRectZero];
    [drop resetWithDictSourceArray:data withTitleKey:@"regionName"];
    [drop defaultSelectedAtIndex:defaultSelectIndex];
    [drop showWithRect:CGRectMake(0, DEF_BOTTOM(self.chooseView) + 10 + 64, DEF_SCREEN_WIDTH, 5*50)
    suitableandExhibit:YES
     andEndChooseBlock:^(NSDictionary *data, NSInteger row) {
         if (index == 0) {
             [self.region selectProvinceAtIdex:row];
         }
         if (index == 1) {
             [self.region selectCityAtIdex:row];
         }
         if (index == 2) {
             [self.region selectRegionAtIdex:row];
         }
         
         ChooseNumberItem * provinceView = self.chooseView.itemArray[0];
         provinceView.title = [self.region currentProvince][@"regionName"];
         
         ChooseNumberItem * cityView = self.chooseView.itemArray[1];
         cityView.title = [self.region currentCity][@"regionName"];
         
         ChooseNumberItem * regionView = self.chooseView.itemArray[2];
         regionView.title = [self.region currentRegion][@"regionName"];
         
     }];
    
    [drop cancelBlock:^{
        chooseButton.selected=NO;
    }];
    
}

- (NSString *) currentProvinceID{

    return [self.region currentProvince][@"regionId"];
}

- (NSString *) currentCityID{

    return [self.region currentCity][@"regionId"];
}
- (NSString *) currentRegionID{

    return [self.region currentRegion][@"regionId"];
}
@end
