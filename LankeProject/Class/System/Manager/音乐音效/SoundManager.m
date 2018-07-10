//
//  SoundManager.m
//  BMProject
//
//  Created by MengHuan on 15/4/19.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

@synthesize musicName;
@synthesize musicOff;
@synthesize soundOff;

singleton_for_class(SoundManager)

- (void)setMusicName:(NSString *)m
{
    if (musicName != m) {
        musicName = m;
    }
    
    if (musicName) {
        // 音乐开启或换了一个音乐
        [self musicPlay];
        
    } else {
        // m为nil，将音乐关闭
        [self musicStop];
    }
}

- (void)setMusicOff:(BOOL)m
{
    musicOff = m;
    
    if (musicOff) {
        // 音乐关闭
        [self musicStop];
        
    } else {
        // 音乐开启
        [self musicPlay];
    }
}

- (void)hackDelay
{
    // 防止AVAudioPlayer第一次播放声音时卡住主线程
    if (soundPlayer) {
        [self soundStop];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bgmusic" ofType:@"mp3" inDirectory:nil]];
    
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    [soundPlayer prepareToPlay];
}

- (void)musicPlay
{
    if (musicPlayer) {
        [self musicStop];
    }
    
    if (musicOff) {
        // 背景音乐被禁，什么都不干
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3" inDirectory:nil]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 背景音乐无限循环，音量稍小一些
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.8;
    
    [musicPlayer play];
}

- (void)musicPlayByName:(NSString *)name
{
    if (musicPlayer) {
        [self musicStop];
    }
    
    if (musicOff) {
        // 背景音乐被禁，什么都不干
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3" inDirectory:nil]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 背景音乐无限循环，音量稍小一些
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.8;
    
    [musicPlayer play];
}

- (void)musicStop
{
    if (!musicPlayer) {
        return;
    }
    
    if ([musicPlayer isPlaying]) {
        [musicPlayer stop];
    }
    
    musicPlayer = nil;
}

- (void)musicPlayFirst:(NSString *)firstName thenLoop:(NSString *)loopName
{
    if (musicPlayer) {
        [self musicStop];
    }
    
    if (musicOff) {
        // 背景音乐被禁，什么都不干
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:firstName ofType:@"mp3" inDirectory:nil]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 播放第一段背景音乐，不无限循环，设置delegate，音量稍小一些
    musicPlayer.delegate    = self;
    musicPlayer.volume      = 0.8;
    
    if (musicNextLoopName != loopName) {
        musicNextLoopName = loopName;
    }
    
    [musicPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 第一段背景音乐播放完成，现在播放第二段，重复
    if (musicOff
        || !flag
        || !musicNextLoopName
        ) {
        return;
    }
    
    if (musicPlayer) {
        [self musicStop];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicNextLoopName ofType:@"mp3" inDirectory:nil]];
    
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    //播放第二段重复的背景音乐，无限循环，音量稍小一些
    musicPlayer.numberOfLoops   = -1;
    musicPlayer.volume          = 0.8;
    
    musicNextLoopName = nil;
    
    [musicPlayer play];
}


- (void)soundPlay:(NSString *)name
{
    if (soundPlayer) {
        [self soundStop];
    }
    
    if (soundOff) {
        // 音效被禁，什么都不干
        return;
    }
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3" inDirectory:nil];
    NSURL *url      = path ? [NSURL fileURLWithPath:path] : nil;
    
    if (!url) {
        NSLog(@"！！！有声音文件名写错了：%@", name);
        
        return;
    }
    
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    [soundPlayer play];
}

- (void)soundLoopsPlay:(NSString *)name
{
    if (soundPlayer) {
        [self soundStop];
    }
    
    if (soundOff) {
        // 音效被禁，什么都不干
        return;
    }
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3" inDirectory:nil];
    NSURL *url      = path ? [NSURL fileURLWithPath:path] : nil;
    
    if (!url) {
        NSLog(@"！！！有声音文件名写错了：%@", name);
        
        return;
    }
    
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    
    // 背景音乐无限循环，音量稍小一些
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.8;
    [soundPlayer play];
}

- (void)soundStop
{
    if (!soundPlayer) {
        return;
    }
    
    if ([soundPlayer isPlaying]) {
        [soundPlayer stop];
    }
    
    soundPlayer = nil;
}

@end
