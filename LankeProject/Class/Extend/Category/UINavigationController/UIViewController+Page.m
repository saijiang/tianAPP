//
//  UIViewController+Page.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/1.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "UIViewController+Page.h"
#import <objc/runtime.h>

@implementation UIViewController (Page)

- (void)setPageItem:(RequestPageItem *)pageItem{

    objc_setAssociatedObject(self, @selector(pageItem), pageItem, OBJC_ASSOCIATION_RETAIN);
}

- (RequestPageItem *)pageItem{

    return objc_getAssociatedObject(self, _cmd);
}

// -----
- (NSMutableArray *)responseDatas{

    return objc_getAssociatedObject(self, _cmd);
}

- (void)setResponseDatas:(NSMutableArray *)responseDatas{

    objc_setAssociatedObject(self, @selector(responseDatas), responseDatas, OBJC_ASSOCIATION_RETAIN);
}

// -----
- (NSArray *)currentData{

    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentData:(NSArray *)currentData{

    objc_setAssociatedObject(self, @selector(currentData), currentData, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark -
#pragma mark API

- (void) configurePage{
    
    if (!self.pageItem || !self.responseDatas) {
        
        self.pageItem = [[RequestPageItem alloc] init];
        self.responseDatas = [NSMutableArray array];
    }
}

- (void) refresh{
    
    [self configurePage];
    
    self.pageItem.canLoadMore = YES;
    self.pageItem.pageIndex = 1;
    self.pageItem.isRefresh = YES;
    
    [self initiateNetworkListRequest];
}

- (void) loadMore{
    
    self.pageItem.isRefresh = NO;
    if (self.pageItem.canLoadMore) {
        
        self.pageItem.pageIndex += 1;
        

    }
    [self initiateNetworkListRequest];

}

- (void)initiateNetworkListRequest{

    // subclass hook
}

- (void) didFinishRequestWithData:(id)data handleForListView:(__kindof UIScrollView *)listView{
    
    [self responseDataList:data];
    if (self.pageItem.isRefresh)
    {
        [listView headerEndRefreshing];
    }
    else
    {
        
        if (!self.pageItem.canLoadMore)
        {
            [UnityLHClass showHUDWithStringAndTime:@"没有更多了"];
        }
        [listView footerEndRefreshing];
    }
    
    [listView reloadData];
}

- (void) responseDataList:(NSArray *)list{
    
    NSAssert([list isKindOfClass:[NSArray class]], @"The response data must be kind of NSArray.");
    
    self.currentData = list;

    if (self.pageItem.pageIndex == 1) {
        [self.responseDatas removeAllObjects];
    }
    
    [self.responseDatas addObjectsFromArray:list];
    
    [self noMoreData:list.count == 0];
}

- (void) noMoreData:(BOOL)noMore{
    
    self.pageItem.canLoadMore = !noMore;
}

@end

@implementation RequestPageItem

- (instancetype)init
{
    if (self = [super init])
    {
        _pageIndex = 1;
        _pageSize = 10;
        _canLoadMore = YES;
        _isRefresh = YES;
    }
    return self;
}

- (NSDictionary *)serializeSelfToJsonObjectPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    return @{pageIndex : @(_pageIndex), pageSize : @(_pageSize)};
}

- (NSString *)description{

    return [NSString stringWithFormat:@"\nPageSize:%ld\nPageIndex:%ld",(long)self.pageSize,(long)self.pageIndex];
}
@end
