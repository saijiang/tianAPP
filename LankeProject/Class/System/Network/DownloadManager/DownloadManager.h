//
//  DownloadManager.h
//  LankeProject
//
//  Created by itman on 16/10/20.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionModel.h"

@interface DownloadManager : NSObject

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;


/**
 *  是否下载
 */
- (BOOL)getDownloadStatusWithSongUrl:(NSString *)songUrl;

/**
 *  开始下载 songId 歌曲ID  只针对已经在队列中的任务处理 如果下载 请调用downloadSongId 方法
 */
- (void)startWithSongUrl:(NSString *)songUrl;


/**
 *  暂停下载 songId 歌曲ID 只针对已经在队列中的任务处理 如果下载 请调用downloadSongId 方法
 */
- (void)pauseWithSongUrl:(NSString *)songUrl;


/**
 *  开启任务下载资源  唯一开始下载的方法
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)downloadSongId:(NSString *)songId progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(DownloadState state))stateBlock;

/*
 下载多首
  *
 *  @param songIdArray   下载歌曲的ID数组
 */
- (void)downloadAll:(NSArray *)songIdArray;

/**
 *  开启任务下载资源
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)download:(NSString *)url progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(DownloadState state))stateBlock;

/**
 *  覆盖下载
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
-(void)downDataload:(NSString *)url progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(DownloadState state))stateBlock;

/**
 *  查询该资源的下载存放路径
 *
 *  @param url 下载地址
 *
 *  @return 返回下载下载存放路径
 */
- (NSURL *)getDownloadPathQuery:(NSString *)url;

/**
 *  查询该资源的下载进度值
 *
 *  @param url 下载地址
 *
 *  @return 返回下载进度值
 */
- (CGFloat)progress:(NSString *)url;

/**
 *  获取该资源总大小
 *
 *  @param url 下载地址
 *
 *  @return 资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url;

/**
 *  判断该资源是否下载完成
 *
 *  @param url 下载地址
 *
 *  @return YES: 完成
 */
- (BOOL)isCompletion:(NSString *)url;

/*
 判断多首文件是否下载完成
 */
- (BOOL)isAllCompletion:(NSArray *)urlArray;

/**
 *  删除该资源
 *
 *  @param url 下载地址
 */
- (void)deleteFile:(NSString *)url;

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile;

/**
 *  所有下载资源大小
 */
- (NSUInteger)getSize;

@end
