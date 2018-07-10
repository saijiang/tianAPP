//
//  CitiesDataTool.m
//  ChooseLocation
//
//  Created by Sekorm on 16/10/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "CitiesDataTool.h"
#import "FMDB.h"
#import "AddressItem.h"

static NSString * const dbName = @"location.db";
static NSString * const locationTabbleName = @"locationTabble";

@interface CitiesDataTool ()
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic, strong) FMDatabase *fmdb;
@end

@implementation CitiesDataTool

static CitiesDataTool *shareInstance = nil;

#pragma mark - Singleton
+ (CitiesDataTool *)sharedManager
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [[self alloc] init];
        }
    }
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
        }
    }
    return shareInstance;
}

- (id)copy
{
    return shareInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self requestGetData];
    }
    return self;
}

//发送网络请求，获取省市区数据，这里用的是本地json数据
- (void)requestGetData{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"cityArray"] != nil) {

        self.dataArray=[userDefaults objectForKey:@"cityArray"];
        if (self.dataArray.count!=0) {
            return;
        }
        
       
    }

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserServices getJDAddressInfoCompletionBlock:^(int result, id responseObject) {
            
            if (result == 0)
            {
                id datas = responseObject[@"data"];
                
                [[NSUserDefaults standardUserDefaults] setObject:datas forKey:@"cityArray"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.dataArray = datas;
               // [self writeFileToplist];
            }
            else
            {
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
    });

}
//根据areaLevel 查询
- (NSMutableArray *)queryAllProvince
{
   
    //NSMutableArray*cityArray=[NSMutableArray arrayWithArray:[self loadFileToplist]];
    NSMutableArray*cityArray=self.dataArray;
    
    NSMutableArray*shenArray=[NSMutableArray array];
        for (NSDictionary*dic in cityArray) {
            AddressItem *item = [[AddressItem alloc] init];
            item.name=dic[@"name"];
            item.value=dic[@"value"];
            [shenArray addObject:item];
        }

    return shenArray;
}



//根据areaLevel级别，省ID 查询 市
- (NSMutableArray *)queryAllRecordWithSheng:(NSString *) sheng

{
  
    NSMutableArray*cityArray=self.dataArray;
    NSMutableArray*shiArray=[NSMutableArray array];
    for (NSDictionary*dic in cityArray) {
        if ([dic[@"name"] isEqualToString:sheng]) {
            NSMutableArray*array=[NSMutableArray arrayWithArray:dic[@"list"]];
            if (array.count!=0) {
            for (NSDictionary*shiDic in array) {
                AddressItem *item = [[AddressItem alloc] init];
                item.name=shiDic[@"name"];
                item.value=shiDic[@"value"];
                [shiArray addObject:item];
            }
        }
    }
       
    }
    if (shiArray.count==0) {
        return nil;
        
    }else{
        
        return shiArray;

    }
}
//根据areaLevel级别，省ID 查询 市
- (NSMutableArray *)queryAllRecordWithShengDic:(NSString *) sheng

{
  
    NSMutableArray*cityArray=self.dataArray;
    NSMutableArray*shiArray=[NSMutableArray array];
    for (NSDictionary*dic in cityArray) {
        
        if ([dic[@"name"] isEqualToString:sheng]) {
            
            NSMutableArray*array=[NSMutableArray arrayWithArray:dic[@"list"]];
            if (array.count!=0) {
                shiArray=array;
                break ;

            }
        }
        
    }
    if (shiArray.count==0) {
        return nil;
        
    }else{
        
        return shiArray;
        
    }
}
//根据areaLevel级别，省ID 查询 市 qu
- (NSMutableArray *)queryAllRecordWithshengDic:(NSString *)sheng shiDic:(NSString *) shi

{
    
    NSMutableArray*shiArray=[self queryAllRecordWithShengDic:sheng];
    NSMutableArray*quArray=[NSMutableArray array];
    
    for (NSDictionary*dic in shiArray) {
        
        if ([dic[@"name"] isEqualToString:shi]) {
            
            NSMutableArray*array=[NSMutableArray arrayWithArray:dic[@"list"]];
            if (array.count!=0) {
                quArray=array;
                break ;
            }
        }
    }
    
    if (quArray.count==0) {
        return nil;
        
    }else{
        
        return quArray;
    }
}
- (NSMutableArray *)queryAllRecordWithSheng:(NSString *) sheng shi:(NSString *)shi{
    
    NSMutableArray*shiArray=[self queryAllRecordWithShengDic:sheng];
    NSMutableArray*quArray=[NSMutableArray array];

    for (NSDictionary*dic in shiArray) {
        
        if ([dic[@"name"] isEqualToString:shi]) {
            NSMutableArray*array=[NSMutableArray arrayWithArray:dic[@"list"]];
            if (array.count!=0) {
                for (NSDictionary*quDic in array) {
                    AddressItem *item = [[AddressItem alloc] init];
                    item.name=quDic[@"name"];
                    item.value=quDic[@"value"];
                    [quArray addObject:item];
                }
            }
        }
    }
    
    if (quArray.count==0) {
        return nil;
        
    }else{
        
        return quArray;
    }
 
}
- (NSMutableArray *)queryAllRecordWithSheng:(NSString *) sheng shi:(NSString *)shi qu:(NSString *)qu{
    
    NSMutableArray*quArray=[self queryAllRecordWithshengDic:sheng shiDic:shi];
    NSMutableArray*townArray=[NSMutableArray array];
    
    for (NSDictionary*dic in quArray) {
        
        if ([dic[@"name"] isEqualToString:qu]) {
            NSMutableArray*array=[NSMutableArray arrayWithArray:dic[@"list"]];
            if (array.count!=0) {
                for (NSDictionary*quDic in array) {
                    AddressItem *item = [[AddressItem alloc] init];
                    item.name=quDic[@"name"];
                    item.value=quDic[@"value"];
                    [townArray addObject:item];
                }
                break;

            }
        }
    }
    if (townArray.count==0) {
        return nil;
        
    }else{
        return townArray;
    }
    
}
- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
