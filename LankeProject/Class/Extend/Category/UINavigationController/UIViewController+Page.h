//
//  UIViewController+Page.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/1.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestPageItem : NSObject

@property (nonatomic ,assign) BOOL isRefresh;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL canLoadMore;

@end

/** 用于具有分页请求控制器的分页操作 */
@interface UIViewController (Page)

@property (nonatomic ,strong) NSMutableArray * responseDatas;
@property (nonatomic ,strong) NSArray * currentData;

@property (nonatomic ,strong) RequestPageItem * pageItem;

//- (void) configurePage;
- (void) refresh;
- (void) loadMore;

/** 发起分页的网络请求 */
- (void) initiateNetworkListRequest;
- (void) didFinishRequestWithData:(id)data handleForListView:(__kindof UIScrollView *)listView;

- (void) responseDataList:(NSArray *)list;
@end
