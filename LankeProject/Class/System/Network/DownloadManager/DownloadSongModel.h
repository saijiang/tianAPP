//
//  DownloadSongModel.h
//  LankeProject
//
//  Created by itman on 16/11/3.
//  Copyright © 2016年 张涛. All rights reserved.
//


//下载本地数据库 下载队列中的数据
#import "DBAPIManager.h"
#import "DownloadSongModel.h"

@interface DownloadSongModel : DBAPIManager

/**
 songId             string 	歌曲编号
 songTitle          string 	歌曲标题
 songCoverLink      string 	封面图片
 songLyricLink      string 	歌词
 songFileLink       string 	歌曲URL
 songDescription 	string 	歌曲描述
 songTime           string 	歌曲时间
 songSize           string 	歌曲文件大小
 
 userId             string 	上传者用户ID
 songSinger         string 	演唱者
 songOriginal       string 	原唱
 songStones         string 	作词
 songCompose        string 	作曲
 songArrangement 	string 	编曲
 songMixing         string 	混缩
 
 userApproveSingerChecked 	string 	是否歌手认证 0否 1 是
 */

@property(nonatomic,copy)NSString *songId;
@property(nonatomic,copy)NSString *songTitle;
@property(nonatomic,copy)NSString *songCoverLink;
@property(nonatomic,copy)NSString *songLyricLink;
@property(nonatomic,copy)NSString *songFileLink;
@property(nonatomic,copy)NSString *songDescription;
@property(nonatomic,copy)NSString *songSize;
@property(nonatomic,copy)NSString *songTime;

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *songSinger;
@property(nonatomic,copy)NSString *songOriginal;
@property(nonatomic,copy)NSString *songStones;
@property(nonatomic,copy)NSString *songCompose;
@property(nonatomic,copy)NSString *songArrangement;
@property(nonatomic,copy)NSString *songMixing;
@property(nonatomic,copy)NSString *userApproveSingerChecked;



@end
