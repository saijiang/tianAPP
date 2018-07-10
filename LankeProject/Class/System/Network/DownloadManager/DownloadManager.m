//
//  DownloadManager.m
//  LankeProject
//
//  Created by itman on 16/10/20.
//  Copyright © 2016年 张涛. All rights reserved.
//


// 缓存主目录
#define GLBLCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GLBLCache"]

// 保存文件名
#define GLBLFileName(url) url.musicString

// 文件的存放路径（caches）
#define GLBLFileFullpath(url) [GLBLCachesDirectory stringByAppendingPathComponent:GLBLFileName(url)]

// 文件的已下载长度
#define GLBLDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:GLBLFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件总长度的文件路径（caches）
#define GLBLTotalLengthFullpath [GLBLCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

#import "DownloadManager.h"
#import "NSString+Hash.h"
#import "Reachability.h"
#import "DownloadSongModel.h"

@interface DownloadManager()<NSCopying, NSURLSessionDelegate>

/** 保存所有任务(注：用下载地址md5后作为key) */
@property (nonatomic, strong) NSMutableDictionary *tasks;
/** 保存所有下载相关信息 */
@property (nonatomic, strong) NSMutableDictionary *sessionModels;
@end

@implementation DownloadManager

- (NSMutableDictionary *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        _sessionModels = [NSMutableDictionary dictionary];
    }
    return _sessionModels;
}


static DownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:GLBLCachesDirectory]) {
        [fileManager createDirectoryAtPath:GLBLCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/**
 *  是否下载
 */
- (BOOL)getDownloadStatusWithSongUrl:(NSString *)songUrl;
{
    if (!songUrl) return NO;
    if ([self.tasks valueForKey:GLBLFileName(songUrl)])
    {
        NSURLSessionDataTask *task = [self getTask:songUrl];
        if (task.state == NSURLSessionTaskStateRunning)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

/**
 *  开始下载 songId 歌曲ID
 */
- (void)startWithSongUrl:(NSString *)songUrl;
{
    if (!songUrl) return;
    
    if ([self isCompletion:songUrl])
    {
        return;
    }
    
    if ([self.tasks valueForKey:GLBLFileName(songUrl)])
    {
        [self start:songUrl];
    }
    else
    {
        [[DownloadManager sharedInstance]download:songUrl progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            
        } state:^(DownloadState state) {
            
        }];
    }

}

/**
 *  暂停下载 songId 歌曲ID
 */
- (void)pauseWithSongUrl:(NSString *)songUrl
{
    if (!songUrl) return;

    if ([self.tasks valueForKey:GLBLFileName(songUrl)])
    {
        [self pause:songUrl];
    }

}

/**
 *  开启任务下载资源
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)downloadSongId:(NSString *)songId progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(DownloadState state))stateBlock
{
    //判断本地数据库是否包含此音乐信息
    NSString *sql=[NSString stringWithFormat:@" WHERE %@ = %@ ",@"songId",songId];
    DownloadSongModel *songModel= [DownloadSongModel findFirstByCriteria:sql];
    
    if (songModel.songId.length>0)
    {
       //说明数据库已经包含此首音乐信息
         [[DownloadManager sharedInstance] download:songModel.songFileLink progress:progressBlock state:stateBlock];
    }
    else
    {
        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
        switch ([r currentReachabilityStatus])
        {
            case NotReachable:
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"当前无网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    
                }];
            }
                break;
            default:
                // 请求数据
//                [UserServices
//                 getSongDetailWithSongId:songId
//                 completionBlock:^(int result, id responseObject)
//                 {
//                     // 解析,将解析好的"歌曲信息模型"
//                     DownloadSongModel * model = [[DownloadSongModel alloc] init];
//                     [model setValuesForKeysWithDictionary:responseObject[@"data"]];
//                     [model saveOrUpdate];
//                     [[DownloadManager sharedInstance] download:model.songFileLink progress:progressBlock state:stateBlock];
//                     
//                 }];
                break;
        }
        
        

    }
}

/*
  下载多首
 
 *
 *  @param songIdArray   下载歌曲的ID数组
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)downloadAll:(NSArray *)songIdArray
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"当前无网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                
            }];
        }
            break;
        default:
            for (NSString *songId in songIdArray)
            {
                [self downloadSongId:songId progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                    
                } state:^(DownloadState state) {
                    
                }];
            }
            break;
    }
    
}

/**
 *  开启任务下载资源
 */
- (void)download:(NSString *)url progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock
{
    
    if (!url) return;
    [UnityLHClass showHUDWithStringAndTime:@"该歌曲已经添加到下载列表中"];

    if ([self isCompletion:url])
    {
        stateBlock(DownloadStateCompleted);
        NSLog(@"----该资源已下载完成");
        return;
    }
    
    // 任务在队列中 暂时保持原态
    if ([self.tasks valueForKey:GLBLFileName(url)])
    {
//        [self handle:url];
        return;
    }
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            // 没有网络连接
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"当前无网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
               
            }];
        }
            break;
        case ReachableViaWWAN:
            // 使用3G网络
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"正在使用2G/3G/4G网络，如果继续下载将会消耗流量" delegate:nil cancelButtonTitle:@"继续下载" otherButtonTitles:@"取消", nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                if (buttonIndex==0)
                {
                    [[DownloadManager sharedInstance] downDataload:url progress:progressBlock state:stateBlock];
                }
            }];
        }
            
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
        {
            [[DownloadManager sharedInstance] downDataload:url progress:progressBlock state:stateBlock];
            
        }
            break;
    }
    
   
}

-(void)downDataload:(NSString *)url progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock
{
    // 创建缓存目录文件
    [self createCacheDirectory];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    DEF_DEBUG(@"文件保存的路径为：%@",GLBLFileFullpath(url));

    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:GLBLFileFullpath(url) append:YES];
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",GLBLDownloadLength(url)];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 创建一个Data任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    
    // 保存任务
    [self.tasks setValue:task forKey:GLBLFileName(url)];
    
    SessionModel *sessionModel = [[SessionModel alloc] init];
    sessionModel.url = url;
    sessionModel.progressBlock = progressBlock;
    sessionModel.stateBlock = stateBlock;
    sessionModel.stream = stream;
    [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
    
    [self start:url];

}

- (void)handle:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task.state == NSURLSessionTaskStateRunning) {
        [self pause:url];
    } else {
        [self start:url];
    }
}

/**
 *  开始下载
 */
- (void)start:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];
    
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
}

/**
 *  暂停下载
 */
- (void)pause:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task suspend];
    
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateSuspended);
}

/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(NSString *)url
{
    return (NSURLSessionDataTask *)[self.tasks valueForKey:GLBLFileName(url)];
}

/**
 *  根据url获取对应的下载信息模型
 */
- (SessionModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    return (SessionModel *)[self.sessionModels valueForKey:@(taskIdentifier).stringValue];
}

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url
{
    if ([self fileTotalLength:url] &&GLBLDownloadLength(url) == [self fileTotalLength:url]) {
        return YES;
    }
    return NO;
}

/*
    判断多首文件是否下载完成
 */
- (BOOL)isAllCompletion:(NSArray *)urlArray
{
    BOOL isFinish =YES;
    for (NSString *url in urlArray)
    {
        BOOL isDownload =  [self isCompletion:url];
        if (!isDownload)
        {
            isFinish= NO;
        }
    }
    return isFinish;
}


/**
 *  查询该资源的下载存放路径
 *
 *  @param url 下载地址
 *
 *  @return 返回下载下载存放路径
 */
- (NSURL *)getDownloadPathQuery:(NSString *)url
{
    if ([self isCompletion:url])
    {
      
        return  [NSURL fileURLWithPath:GLBLFileFullpath(url)];

    }
    return [NSURL URLWithString:url];

}

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 *GLBLDownloadLength(url) /  [self fileTotalLength:url];
}

/**
 *  获取该资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url
{
    return [[NSDictionary dictionaryWithContentsOfFile:GLBLTotalLengthFullpath][GLBLFileName(url)] integerValue];
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:GLBLFileFullpath(url)]) {
        
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:GLBLFileFullpath(url) error:nil];
        // 删除任务
        [self.tasks removeObjectForKey:GLBLFileName(url)];
        [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:GLBLTotalLengthFullpath]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:GLBLTotalLengthFullpath];
            [dict removeObjectForKey:GLBLFileName(url)];
            [dict writeToFile:GLBLTotalLengthFullpath atomically:YES];
            
        }
    }
}

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:GLBLCachesDirectory]) {
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:GLBLCachesDirectory error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (SessionModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:GLBLTotalLengthFullpath]) {
            [fileManager removeItemAtPath:GLBLTotalLengthFullpath error:nil];
        }
    }
}

#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    SessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] +GLBLDownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    
    // 存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:GLBLTotalLengthFullpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[GLBLFileName(sessionModel.url)] = @(totalLength);
    [dict writeToFile:GLBLTotalLengthFullpath atomically:YES];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    SessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize =GLBLDownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    
    sessionModel.progressBlock(receivedSize, expectedSize, progress);
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    SessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    
    if ([self isCompletion:sessionModel.url])
    {
//        //本地数据库包含此音乐信息
//        NSString *sql=[NSString stringWithFormat:@" WHERE %@ = %@ ",@"songFileLink",sessionModel.url];
//        DownloadSongModel *songModel= [DownloadSongModel findFirstByCriteria:sql];
//        [UserServices
//         addDownloadBysongId:songModel.songId
//         userId:[KeychainManager readUserId]
//         completionBlock:^(int result, id responseObject) {
//            
//        }];
        
        // 下载完成
        sessionModel.stateBlock(DownloadStateCompleted);
    }
    else if (error)
    {
        // 下载失败
        sessionModel.stateBlock(DownloadStateFailed);
    }
    
    // 关闭流
    [sessionModel.stream close];
    sessionModel.stream = nil;
    
    // 清除任务
    [self.tasks removeObjectForKey:GLBLFileName(sessionModel.url)];
    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
}


- (NSUInteger)getSize
{
    __block NSUInteger size = 0;
    
    for (DownloadSongModel *model in [DownloadSongModel findAll])
    {
        size =size +[self fileTotalLength:model.songFileLink];
    }
    
    return size;
}



@end
