//
//  LAKALABraceletManager.m
//  LankeProject
//
//  Created by itman on 17/4/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "LAKALABraceletManager.h"

#define kBindDeviceUUID          @"BindDeviceUUID"
#define kBindDeviceTYPE          @"LKLBraceletType" //LKLBraceletTypeB2/B2手环 LKLBraceletTypeB2/B3手环


@interface LAKALABraceletManager()<CSwiperControllerDelegate,LDBraceletDeviceDelegate,CBCentralManagerDelegate>

@property(nonatomic,assign)LKLBraceletType braceletType;//当前连接的手环类型
@property(nonatomic,strong)LAKALARecordParams *recordParams;//当前连接的手环睡眠运动记录
@property(nonatomic,strong)LAKALABleDeviceInfo *deviceInfo;//当前连接的手环设备信息

//B2 相关
@property (nonatomic, strong) NSOperationQueue *deviceQueue;
@property (nonatomic, strong) ME19SwiperController *reader;

//B3 相关
@property(nonatomic,strong)LDBraceletController *controller;

//连接状态
@property (nonatomic, strong) NSString *devState;

//蓝牙设备
@property (nonatomic,strong)CBCentralManager *centralManager;
@property (nonatomic,assign)BOOL blueToothOpen;

@end

@implementation LAKALABraceletManager
@synthesize reader;

+(instancetype)sharedInstance
{
    static LAKALABraceletManager *sharedLAKALABraceletManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLAKALABraceletManager = [[self alloc] init];
    });
    return sharedLAKALABraceletManager;
    
}
- (id)init
{
    if ((self = [super init]))
    {
        
        self.deviceQueue = [NSOperationQueue new];
        self.deviceInfo=[[LAKALABleDeviceInfo alloc]init];
        self.recordParams=[[LAKALARecordParams alloc]init];
        // 蓝牙检测
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];

    }
    
    return self;
}
//配置
-(void)configuration
{
    if (!reader)
    {
        reader = [ME19SwiperController sharedInstance];
        NSLog(@"reader : %@", reader);
        if (!reader)
        {
            [self showMsgOnMainThread:@"该设备不支持蓝牙BLE通信"];
        }
        [reader setDelegate:self];
    }
   
    if (!self.controller)
    {
        self.controller = [LDBraceletController shareInstance];
        self.controller.deviceDelegate = self;

    }
    
}

//获取设备类型信息
- (LKLBraceletType)getDeviceType
{
    return self.braceletType;
}
//获取设备信息
- (LAKALABleDeviceInfo*)getDeviceInfo
{
    if (self.braceletType==LKLBraceletTypeB2)
    {
        id<CSwiperDeviceInfo> info = [self.reader getDeviceInfo];
        BleDeviceInfo *param=[reader getBleDeviceInfo];
        self.deviceInfo.nickName=param.nickName;
        self.deviceInfo.deviceName=param.deviceName;
        self.deviceInfo.uuid=param.uuid;
        self.deviceInfo.powerLevel=param.powerLevel;
        self.deviceInfo.macAddress=param.macAddress;
        self.deviceInfo.firmwareVersion=[info firmwareVersion];
        self.deviceInfo.appVer=[info appVer];
        self.deviceInfo.braceletType=LKLBraceletTypeB2;
        return self.deviceInfo;

    }
    else if (self.braceletType==LKLBraceletTypeB3)
    {
        //B3
        DeviceInfo *param = [_controller deviceInfo];
        self.deviceInfo.powerLevel=param.batteryLevel;
        self.deviceInfo.macAddress=param.BtMac;
        self.deviceInfo.firmwareVersion=param.userVer;
        self.deviceInfo.appVer=param.userVer;
        self.deviceInfo.braceletType=LKLBraceletTypeB3;
        return self.deviceInfo;

    }
    return nil;
}
//获取运动信息
- (LAKALARecordParams*)getRecordParams
{
    if (self.braceletType==LKLBraceletTypeB3)
    {
        
        [self getPersonParm];
        [self currentSportRecord];
        [self currentSleepRecord];
        [self heartRate];

    }
    else if (self.braceletType==LKLBraceletTypeB2)
    {
        [self doPersonalParams];
        [self doCurrentSportRecord];
        [self doCurrentSleepRecord];

    }
    
    return self.recordParams;
}
#pragma mark---自动连接
-(void)automaticConnection
{
    if (!self.blueToothOpen)
    {
        //蓝牙没有打开的情况太会去重练
        return;
    }
    //重连设备 获取上次连接的设备信息
    NSString *identify = DEF_PERSISTENT_GET_OBJECT(kBindDeviceUUID);
    LKLBraceletType type =[DEF_PERSISTENT_GET_OBJECT(kBindDeviceTYPE) integerValue];
    
    if (identify.length > 0)
    {
        //之前连接的设备重新连接
        self.braceletType=type;
        [NLBluetoothHelper startScan];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.braceletType==LKLBraceletTypeB3)
            {
                //B3
                [self connectDevice:identify];
            }
            else if (self.braceletType==LKLBraceletTypeB2)
            {
                //B2
                [self.deviceQueue addOperationWithBlock:^{
                    //todo 设备连接
                    [reader setConnectParams:[CSwiperConnectParams paramsWithUuid:identify]];
                    [reader connect];
                }];
            }
            [NLBluetoothHelper stopScan];

        });
    }
    
}

//搜索设备
- (void)onInitDevice
{
    //判断蓝牙设备是否打开
    if (self.blueToothOpen)
    {
        [self doScanBluetoothDevices:5.0f];

    }
    else
    {
        //打开蓝牙设置
        [UnityLHClass showAlertView:@"请先打开蓝牙设备后再搜索"];
    }
}
- (void)onInitDeviceWithBluetoothConnecteBlock:(BluetoothConnecteBlock)bluetoothConnecteBlock
{
    self.bluetoothConnecteBlock=[bluetoothConnecteBlock copy];

}
/*!
 @method
 @abstract 断开设备
 @discussion
 */
- (void)onDeleteDevice
{
    //删除本次保存的设备信息
    DEF_PERSISTENT_REMOVE(kBindDeviceTYPE);
    DEF_PERSISTENT_REMOVE(kBindDeviceUUID);

    [self showMsgOnMainThread:@"正在断开设备连接..."];
    if (self.braceletType==LKLBraceletTypeB3)
    {
        [_controller disConnectDev];
    }
    if (self.braceletType==LKLBraceletTypeB2)
    {
        [reader disConnect];

    }
}
//是否连接设备
- (BOOL)isConnected
{
    if (self.braceletType==LKLBraceletTypeB3)
    {
        return [_controller isConnect];
    }
    return [reader isDevicePresent];
}
//当前卡路里消耗同步给后台
-(void)saveFitnessPlanDetail
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        LAKALARecordParams *params=  [self getRecordParams];
        [UserServices
         saveFitnessPlanDetailWithUserId:[KeychainManager readUserId]
         consumeCalories:[NSString stringWithFormat:@"%.0f",params.sportCalories]
         completionBlock:^(int result, id responseObject)
         {
             
         }];
    });
    
}

//同步个人信息
- (void)synchronizationInformation
{
    if ([KeychainManager islogin])
    {
        [UserServices
         getUserInfoWithuserId:[KeychainManager readUserId]
         completionBlock:^(int result, id responseObject)
        {
            if (result==0)
            {
                
                [[UserInfo_Preferences sharedInstance] savePreferencesWithData:responseObject[@"data"]];
                self.recordParams.age=[[UserInfo_Preferences sharedInstance].age intValue];
                self.recordParams.sex=[[UserInfo_Preferences sharedInstance].sex intValue];
                self.recordParams.height=[[UserInfo_Preferences sharedInstance].height intValue];
                self.recordParams.weight=[[UserInfo_Preferences sharedInstance].weight intValue];
                
                [self doSetPersonalParams:self.recordParams];
                [self setPersonalParams:self.recordParams];
                
                [self saveFitnessPlanDetail];
                
            }
        }];
        
    }
   
}

/*!
 @method
 @abstract 可供连接的蓝牙设备对象（备选）
 @discussion
 @return 可供连接的蓝牙设备列表（uuid-CBPeripheral 键值对字典）
 */
- (NSDictionary*)bluetoothDevicesPER
{
    return [NLBluetoothHelper devicePeripherals];
}
/*!
 @method
 @abstract 可供连接的蓝牙设备对象（备选）
 @discussion
 @return 可供连接的蓝牙设备列表（name-uuid键值对字典）
 */
- (NSDictionary*)bluetoothDevices
{
    return [NLBluetoothHelper devices];
}

/*!
 @method
 @abstract 开始扫描
 @discussion
 */
- (void)doScanBluetoothDevices:(NSTimeInterval)timeout
{
  
    [self showMsgOnMainThread:@"正在扫描蓝牙设备..."];
    [NLBluetoothHelper startScan];
    MainPerformTimeOut(self, @selector(onScanDeviceCompleted:),nil, timeout);
}

/*!
 @method
 @abstract 可供连接的蓝牙设备对象（备选）
 @discussion
 @return 可供连接的蓝牙设备列表（name-uuid键值对字典）
 */
- (void)onScanDeviceCompleted:(NSDictionary *)devices
{
    [self hideProcess];
    [NLBluetoothHelper stopScan];
    //扫描的所有设备
    NSArray *deviceNames = [[NLBluetoothHelper devices] allKeys];
    //帅选出Lakala设备
    NSMutableArray *lakalaDeviece=[[NSMutableArray alloc]init];

    for (NSString *name in deviceNames)
    {
        if (name && [name containsString:@"LakalaB"])
        {
            [lakalaDeviece addObject:name];
        }
    }
    
    DEF_DEBUG(@"%@",CString(@"%@%lu",@"扫描结束，共发现可连接蓝牙设备台数为：",(unsigned long)deviceNames.count));
    DEF_DEBUG(@"%@",CString(@"%@%lu",@"扫描结束，共发现可连接lakalaDeviece蓝牙设备台数为：",(unsigned long)lakalaDeviece.count));

    if (lakalaDeviece.count <= 0)
    {
        [UnityLHClass showAlertView:@"没发现可以连接的手环设备"];
        return ;
    }
    
    UIActionSheet *deviceSelectorSheet = [[UIActionSheet alloc] initWithTitle:@"选择设备类型" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil  otherButtonTitles:nil];
 
    for (NSString *name in lakalaDeviece)
    {
        [deviceSelectorSheet addButtonWithTitle:name];

    }
    [deviceSelectorSheet addButtonWithTitle:@"取消"];
    [deviceSelectorSheet showInView:self.topViewController.view withCompletionHandler:^(NSInteger buttonIndex)
     {
        if (buttonIndex<lakalaDeviece.count)
        {
            NSString *title = lakalaDeviece[buttonIndex];
            if (title && [title containsString:@"LakalaB3"])
            {
                self.braceletType=LKLBraceletTypeB3;
            }
            else if (title && [title containsString:@"LakalaB2"])
            {
                self.braceletType=LKLBraceletTypeB2;
            }
            [self doInitBluetoothDeviceWithUUID:title];  //根据uuid连接手环
            //[self.deviceOperators doInitBluetoothDeviceWithPer:title];  //通过蓝牙对象连接手环
            
        }
    }];
    

}
/*!
 @method
 @abstract 连接蓝牙
 @discussion
 */
- (void)doInitBluetoothDeviceWithUUID:(NSString*)name
{
    DEF_DEBUG(@"doInitBluetoothDeviceWithUUID");
    NSString *uuid = self.bluetoothDevices[name];
    if (!uuid)
    {
        [self showMsgOnMainThread:CString(@"%@\n[%@]！%@",@"附近找不到该蓝牙设备", name,@"请确认开机和未连接状态。")];
        return ;
    }
    [self showMsgOnMainThread:CString(@"%@\n[%@ - %@]", @"正在连接蓝牙设备...", name, uuid)];
    self.deviceInfo.nickName=name;
    self.deviceInfo.deviceName=name;
    self.deviceInfo.uuid=uuid;
  
    if ([self isConnected])
    {
        [self onDeleteDevice];
    }
    if (self.braceletType==LKLBraceletTypeB3)
    {
         //B3
        [self connectDevice:uuid];
    }
    else if (self.braceletType==LKLBraceletTypeB2)
    {
        //B2
        [NLBluetoothHelper stopScan];
        [self.deviceQueue addOperationWithBlock:^{
            //todo 设备连接
            [reader setConnectParams:[CSwiperConnectParams paramsWithUuid:uuid]];
            [reader connect];
        }];
    }
    
    //保存设备信息
    DEF_PERSISTENT_SET_OBJECT(@(self.braceletType), kBindDeviceTYPE);
    DEF_PERSISTENT_SET_OBJECT(uuid, kBindDeviceUUID);
}

#pragma mark =====================B2相关=====================
/**
 *  查找手环
 *
 *  @param data 默认00
 */
- (void)doFindBracelet
{
    [reader findBracelet:nil];
}
- (void)doSetB2SysTime
{
    [self.reader setSysTime:[NSDate date]];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置手环时间成功")];
}
- (void)doSetPersonalParams:(LAKALARecordParams*)personalParams
{
    NLPersonalParams*params=[[NLPersonalParams alloc]init];
    params.height=personalParams.height;
    params.weight=personalParams.weight;
    params.sex=personalParams.sex;
    [reader setPersonalParams:params];
    [self showRsltMsgOnMainThread:CString(@"%@",@"个人信息设置成功")];
}
- (void)doPersonalParams
{

    NLPersonalParams *param =[self.reader personalParams];
    self.recordParams.height=param.height;
    self.recordParams.weight=param.weight;
    self.recordParams.sex=param.sex;
    [self showRsltMsgOnMainThread:CString(@"%@",@"获取个人信息成功")];

}
- (void)doCurrentSleepTarget
{
    NSData *data = [reader currentSleepTarget];
    NSString *info =  [NSString stringWithFormat:@"%d",[NLISOUtils intWithHexString:[NLISOUtils hexStringWithData:data]]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前睡眠目标为:", info)];
}
- (void)doCurrentSportTarget
{
    NSData *data = [reader currentSportTarget];
    NSString *info =  [NSString stringWithFormat:@"%d",[NLISOUtils intWithHexString:[NLISOUtils hexStringWithData:data]]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前运动目标为:", info)];
}
- (void)doCurrentSportRecord
{
    NSData *info = [reader currentSportRecord];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前运动记录为:",[self unpackSportRecord:info])];
}

- (void)doCurrentSleepRecord
{
    NSData *info =[reader currentSleepRecord];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前睡眠记录为:",[self unpackSleepRecordData:info])];
}
-(NSString*)unpackSportRecord:(NSData*)his
{
    int sumcount = 0;
    int sumWalk = 0;
    int sumRun = 0;
    
    int sumDistance = 0;
    int sumWalkDistance = 0;
    int sumRunDistance = 0;
    
    int sumTime = 0;
    int sumWalkTime = 0;
    int sumRunTime = 0;

    //前四字节为日期，后240字节为运动数据
    NSMutableString *sportRecord = [NSMutableString new];
    [sportRecord appendString:CString(@"日期:%@ \n", [his subdataWithRange:NSMakeRange(0, 4)])];
    for (int i = 0; i<24; i++)
    {
        NSData *step = [his subdataWithRange:NSMakeRange(4+i*10, 10)];
        int walkCount = [NLISOUtils unPackIntFromBytes:[step subdataWithRange:NSMakeRange(0, 2)] offset:0 len:2 isBigEndian:YES];
        int runCount = [NLISOUtils unPackIntFromBytes:[step subdataWithRange:NSMakeRange(2, 2)] offset:0 len:2 isBigEndian:YES];  //跑步步数
        int walkDistance = [NLISOUtils unPackIntFromBytes:[step subdataWithRange:NSMakeRange(4, 2)] offset:0 len:2 isBigEndian:YES];  //步行距离
        int runDistance = [NLISOUtils unPackIntFromBytes:[step subdataWithRange:NSMakeRange(6, 2)] offset:0 len:2 isBigEndian:YES];  //跑步距离
        int walkTime = [NLISOUtils unPackIntFromBytes:[step subdataWithRange:NSMakeRange(8, 1)] offset:0 len:1 isBigEndian:YES];  //步行时间
        int runTime = [NLISOUtils unPackIntFromBytes:[step subdataWithRange:NSMakeRange(9, 1)] offset:0 len:1 isBigEndian:YES];  // 跑步时间
        
        sumWalk += walkCount;
        sumRun += runCount;
        
        sumWalkDistance += walkDistance;
        sumRunDistance += runDistance;
        
        sumWalkTime += walkTime;
        sumRunTime += runTime;
        [sportRecord appendString:CString(@"第 %d 小时走路步数:%d, 跑步步数: %d \n",i+1,walkCount,runCount)];
    }
    sumcount=sumWalk +sumRun;
    sumDistance=sumWalkDistance +sumRunDistance;
    sumTime=sumWalkTime +sumRunTime;

    [sportRecord appendString:CString(@"总步数: %d 总距离: %d 总时间: %d",sumcount,sumDistance,sumTime)];
    
    //运动距离
    self.recordParams.walkStepLenght=sumWalkDistance;
    self.recordParams.runStepLenght=sumRunDistance;
    self.recordParams.sportStepLenght=sumDistance;
    
    //运动时间
    self.recordParams.walkStepTime=sumWalkTime;
    self.recordParams.runStepTime=sumRunTime;
    self.recordParams.sportTime=sumTime;
    
    //运动步数
    self.recordParams.walkStepNum=sumWalk;
    self.recordParams.runStepNum=sumRun;
    self.recordParams.sportStepNum=sumcount;
    
    bool sex=NO;
    if ( self.recordParams.sex==1)
    {
        sex=YES;
    }
    /**
     * 获取运动卡路里
     * @param sex 性别（YES男，NO女）
     * @param height 身高(cm)
     * @param weight 体重（kg）
     * @param age 年龄(year)
     * @param run 跑步步数(step)
     * @param walk 走路步数(step)
     */
    double sportCalories= [ME19SwiperController getCalorie:sex height:self.recordParams.height weight:self.recordParams.weight age:self.recordParams.age run:self.recordParams.runStepLenght walk:self.recordParams.walkStepLenght];
    self.recordParams.sportCalories=sportCalories;
    return sportRecord;
}
//解析睡眠记录数据
-(NSString *)unpackSleepRecordData:(NSData*)his
{
    int sum_qx = 0; //清醒时间
    int sum_qys = 0; //潜意识时间
    int sum_qs = 0; //浅睡时间
    int sum_ss = 0; //深睡时间
    NSMutableString *sleepRecord = [NSMutableString new];
    //前四字节为日期，后24字节为睡眠数据
    [sleepRecord appendString:CString(@"日期:%@ \n", [his subdataWithRange:NSMakeRange(0, 4)])];
    Byte *dBytes = (Byte*)[[his subdataWithRange:NSMakeRange(4, 24)] bytes];
    for (int i = 0; i<24; i++) {
        //获取i至i+1点睡眠数据 ，0 深睡眠 1 浅睡眠 2潜意识 3清醒
        [sleepRecord appendString:CString(@"第 %d 小时的睡眠状态:\n 0-15min: %d \n 16-30min: %d \n31-45min: %d \n46-60min: %d \n",i+1,((dBytes[i] & 0xc0) >> 6),((dBytes[i] & 0x30) >> 4),((dBytes[i] & 0x0c) >> 2),((dBytes[i] & 0x03) >> 0))];
        switch (((dBytes[i] & 0xc0) >> 6)) {
            case 0:
                sum_ss += 15;
                break;
            case 1:
                sum_qs += 15;
                break;
            case 2:
                sum_qys += 15;
                break;
            case 3:
                sum_qx += 15;
                break;
            default:
                break;
        }
        switch (((dBytes[i] & 0x30) >> 4)) {
            case 0:
                sum_ss += 15;
                break;
            case 1:
                sum_qs += 15;
                break;
            case 2:
                sum_qys += 15;
                break;
            case 3:
                sum_qx += 15;
                break;
            default:
                break;
        }
        switch (((dBytes[i] & 0x0c) >> 2)) {
            case 0:
                sum_ss += 15;
                break;
            case 1:
                sum_qs += 15;
                break;
            case 2:
                sum_qys += 15;
                break;
            case 3:
                sum_qx += 15;
                break;
            default:
                break;
        }
        switch (((dBytes[i] & 0x03) >> 0)) {
            case 0:
                sum_ss += 15;
                break;
            case 1:
                sum_qs += 15;
                break;
            case 2:
                sum_qys += 15;
                break;
            case 3:
                sum_qx += 15;
                break;
            default:
                break;
        }
    }
    self.recordParams.awakeTime=sum_qx;
    self.recordParams.subconsciousMindTime=sum_qys;
    self.recordParams.latentSleepTime=sum_qs;
    self.recordParams.deepSleepTime=sum_ss;
    [sleepRecord appendString:CString(@"清醒时间:%d mins \n",sum_qx)];
    [sleepRecord appendString:CString(@"潜意识时间:%d mins \n",sum_qys)];
    [sleepRecord appendString:CString(@"浅睡时间:%d mins \n",sum_qs)];
    [sleepRecord appendString:CString(@"深睡时间:%d mins \n",sum_ss)];
    return sleepRecord;
}



- (void)doDeviceBinding
{
    BOOL b = [self.reader deviceBinding:nil];
    [self showRsltMsgOnMainThread:CString(@"%@",b ? @"绑定成功":@"绑定失败")];
}

- (void)doCancel
{
    [reader cancel:^(BOOL isSuccess) {
        if (isSuccess) {
            [self showRsltMsgOnMainThread:CString(@"%@",@"撤销指令成功")];
        }
        else{
            [self showRsltMsgOnMainThread:CString(@"%@",@"撤销指令失败")];
        }
    }];
}
#pragma mark---CSwiperControllerDeviceStateListener
/**
 * 当设备连接上时响应
 */
- (void)onDeviceConnected
{
    if (self.bluetoothConnecteBlock) {
        self.bluetoothConnecteBlock(1);
    }
}
/**
 * 当设备中断连接时响应
 */
- (void)onDeviceDisconnected
{
    [self hideProcess];

}
/**
 *MT100设备连接状态响应
 * state 0表示主动断开成功，1表示链接成功，2，表示被动断开成功，3表示重连失败，4表示重连成功 ,5表示超时 ，6表示连接失败
 */
- (void)onDeviceConnectedState:(NSString*)state
{
    _devState = [NSString stringWithFormat:@"%@",state];
    if (self.bluetoothConnecteBlock)
    {
        self.bluetoothConnecteBlock([_devState integerValue]);
        
    }
    if([state isEqualToString:@"0"]){
        [self showMsgOnMainThread:localKey(@"蓝牙断开成功")];
    }
    else if([state isEqualToString:@"1"]){
        [self showMsgOnMainThread:localKey(@"蓝牙连接成功")];
    }
    else if([state isEqualToString:@"2"]){
        [self showMsgOnMainThread:localKey(@"蓝牙被动断开")];
    }
    else if([state isEqualToString:@"3"]){
        [self showMsgOnMainThread:localKey(@"蓝牙重连失败")];
    }
    else if([state isEqualToString:@"4"]){
        [self showMsgOnMainThread:localKey(@"蓝牙重连成功")];
    }
    else if([state isEqualToString:@"5"]){
        [self showMsgOnMainThread:localKey(@"蓝牙连接超时")];
    }
    else if([state isEqualToString:@"6"]){
        [self showMsgOnMainThread:localKey(@"蓝牙连接失败")];
    }
    [self hideProcess];
}
/**
 *MT100 ancs配对状态
 *1表示配对成功，0表示配对失败
 */
- (void)onDeviceANCSState:(NSString*)state
{
    if([state isEqualToString:@"0"])
    {
        [self showRsltMsgOnMainThread:localKey(@"配对失败")];
    }
    else if([state isEqualToString:@"1"])
    {
        [self showRsltMsgOnMainThread:localKey(@"配对成功")];
    }
    
}

#pragma mark =====================B3相关=====================
- (BOOL)isConnect
{
    BOOL bConnect = [_controller isConnect];
    return bConnect;
}

- (void)stopScan
{
    [_controller stopSearchDev];
}

- (void )connectDevice:(NSString*)uuid
{
    [_controller connectDevUUID:uuid];
}

-(void)disconnect
{
    [_controller disConnectDev];
}
- (int)heartRate
{
    self.recordParams.heartNum= [_controller heartRate];
    
    
    return self.recordParams.heartNum;
}

/**
 开始进入心率实时监听模式
 
 @return 心率实时监听模式进入结果
 */
- (BOOL)startHeartRateRealTimeMonitor
{
    return [_controller startHeartRateRealTimeMonitor];
}
/**
 退出实时心率实时监听模式
 */
- (BOOL)stopHeartRateRealTimeMonitor
{
    return [_controller stopHeartRateRealTimeMonitor];
}




-(void)findBracelet:(NSString *)data
{
    [_controller findBracelet:data];
}
-(void)doSetB3SysTime
{
    [_controller setDeviceSysTime:[NSDate date]];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置手环时间成功")];
    
}
/**
*  获取电池电量
*
*  @return 电池电量百分比
*/
-(NSInteger)battery
{
    NSInteger power = [_controller batteryPower];
    return power;
}

/*
 *  绑定设备
 *
 *  @param data
 *
 *  @return
 */
- (BOOL)deviceBinding:(NSData*)data
{
//    Byte byte[2] = {0x01,0x02};
//    NSData *data = [NSData dataWithBytes:byte length:2];

    return  [_controller bindDevice:data];
}
/**
 * 设置个人参数
 * weight 体重
 * height 身高
 * sex    性别
 *
 **/

-(void)setPersonalParams:(LAKALARecordParams *)params
{
    LklPersonalParams *personParam = [[LklPersonalParams alloc] init];
    personParam.weight = params.weight;
    personParam.height = params.height;
    personParam.sex = params.sex;
    [_controller setPersonalParams:personParam];
    
}

//获取个人参数
- (void)getPersonParm
{
    LklPersonalParams *personParam = [_controller personalParams];
    self.recordParams.height=personParam.height;
    self.recordParams.weight=personParam.weight;
    self.recordParams.sex=personParam.sex;
    self.recordParams.age=30;

    NSMutableDictionary *personDic = [[NSMutableDictionary alloc] init];
    personDic[@"weight"] = @(personParam.weight);
    personDic[@"height"] = @(personParam.height);
    personDic[@"sex"] = @(personParam.sex);
    personDic[@"birthDay"]= personParam.birthDay;
    [self showRsltMsgOnMainThread:[NSString stringWithFormat:@"个人参数：%@",personDic]];
}

/**
 *
 * 获取当前运动记录
 *包含以下属性：
 * 行走的步数  walkCount;
 * 行走的距离，单位：米 walkDistance;
 * 行走的时间，单位：分钟* walkTime;
 * 跑步的步数  runCount;
 * 跑步的距离，单位：米 runDistance;
 * 跑步的时间，单位：分钟 runTime;
 **/
-(void)currentSportRecord
{
    NSArray *sportRecordArray= [_controller currentSportRecord];
    [self showRsltMsgOnMainThread:[NSString stringWithFormat:@"获取当前运动记录：%@",sportRecordArray]];
    [self getSportRecord:sportRecordArray];

}
/**
 *
 * [
 * {
 *  date:日期
 *  starTime:开始时间
 *  endTime:结束时间
 *  status:状态
 *  }
 * {
 *  date:日期
 *  starTime:开始时间
 *  endTime:结束时间
 *  status:状态
 *  }
 * ]
 **/
-(void )currentSleepRecord
{
    NSArray *sleepRecordArray= [_controller currentSleepRecord];
    [self showRsltMsgOnMainThread:[NSString stringWithFormat:@"获取当前睡眠记录：%@",sleepRecordArray]];
    [self getSleepRecordData:sleepRecordArray];

}
/**
 *  获取卡路里（根据身高，体重，年龄，步行步数，跑步步数）
 */
- (double)getCalorie:(bool)sex
              height:(int)height
              weight:(int)weight
                 age:(int)age
                 run:(int)run
                walk:(int)walk
{
    return [_controller getCalorie:sex height:height weight:weight age:age run:run walk:walk]/1000;
}
-(void)getSportRecord:(NSArray*)hisRecord
{
    int sumcount = 0;
    int sumWalk = 0;
    int sumRun = 0;
    
    int sumDistance = 0;
    int sumWalkDistance = 0;
    int sumRunDistance = 0;
    
    int sumWalkTime = 0;
    int sumRunTime = 0;
    int sumTime = 0;
    int calorie = 0;

    /* 行走的步数  walkCount;
    * 行走的距离，单位：cm walkDistance;
    * 行走的时间，单位：分钟* walkTime;
    * 跑步的步数  runCount;
    * 跑步的距离，单位：cm runDistance;
    * 跑步的时间，单位：分钟 runTime;
    */
    
    //前四字节为日期，后240字节为运动数据
    NSMutableString *sportRecord = [NSMutableString new];
    for (int i = 0; i<hisRecord.count; i++)
    {
        NSDictionary *step = hisRecord[i];
        int walkCount = [step[@"walkCount"] intValue];    //步行步数
        int runCount = [step[@"runCount"] intValue];  //跑步步数
        int walkDistance =  [step[@"walkDistance"] intValue];  //步行距离
        int runDistance = [step[@"runDistance"] intValue];  //跑步距离
        int runTime = [step[@"runTime"] intValue];  // 运动时间
        int walkTime = [step[@"walkTime"] intValue];  // 运动时间
        calorie = [step[@"calorie"] intValue];// 运动卡路里
        sumWalk += walkCount;
        sumRun += runCount;
        
        sumWalkDistance += walkDistance;
        sumRunDistance += runDistance;
        
        sumWalkTime+=walkTime;
        sumRunTime+=runTime;

        [sportRecord appendString:CString(@"第 %d 小时走路步数:%d, 跑步步数: %d \n",i+1,walkCount,runCount)];
    }
    
    sumTime =sumWalkTime+sumRunTime;
    sumcount=sumWalk +sumRun;
    sumDistance=sumWalkDistance +sumRunDistance;
    
    sumDistance=sumDistance/100.0;
    [sportRecord appendString:CString(@"总步数: %d 总距离: %d 总时间: %d",sumcount,sumDistance,sumTime)];
    
    self.recordParams.walkStepLenght=sumWalkDistance;
    self.recordParams.runStepLenght=sumRunDistance;
    self.recordParams.sportStepLenght=sumDistance;
 
    self.recordParams.walkStepNum=sumWalk;
    self.recordParams.runStepNum=sumRun;
    self.recordParams.sportStepNum=sumcount;
    
    self.recordParams.walkStepTime=sumWalkTime;
    self.recordParams.runStepTime=sumRunTime;
    self.recordParams.sportTime=sumTime;
    
    self.recordParams.sportCalories=calorie;
}

//解析睡眠记录数据
-(void)getSleepRecordData:(NSArray *)hisSleepRecord
{
    /* date:日期
    *  starTime:开始时间
    *  endTime:结束时间
    *  status:状态
    */
    
    int sum_qx = 0; //清醒时间
    int sum_qys = 0; //潜意识时间
    int sum_qs = 0; //浅睡时间
    int sum_ss = 0; //深睡时间
    
    //status:状态（睡眠状态，0：深睡眠，1：浅睡眠，2：意识睡眠，3：活动状态）
    
    for (int i=0; i<hisSleepRecord.count; i++)
    {
        NSDictionary *data=hisSleepRecord[i];
        int status= [data[@"Status"] intValue];
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString * starTime = data[@"StartTime"];
        NSString * endTime = data[@"EndTime"];
        NSDate * date1 = [df dateFromString:starTime];
        NSDate * date2 = [df dateFromString:endTime];
        NSTimeInterval time = [date2 timeIntervalSinceDate:date1]; //date1是前一个时间(早)，date2是后一个时间(晚)
        int mins=time;
        
        if (status==0)
        {
            sum_ss+=mins;
        }
        else if (status==1)
        {
            sum_qs+=mins;
        }
        else if (status==2)
        {
            sum_qys+=mins;

        }
        else if (status==3)
        {
            sum_qx+=mins;

        }
    }
    
    self.recordParams.awakeTime=sum_qx/60.0;
    self.recordParams.subconsciousMindTime=sum_qys/60.0;
    self.recordParams.latentSleepTime=sum_qs/60.0;
    self.recordParams.deepSleepTime=sum_ss/60.0;
    NSMutableString *sleepRecord = [NSMutableString new];
    [sleepRecord appendString:CString(@"清醒时间:%d     s \n",sum_qx)];
    [sleepRecord appendString:CString(@"潜意识时间:%d    s \n",sum_qys)];
    [sleepRecord appendString:CString(@"浅睡时间:%d     s \n",sum_qs)];
    [sleepRecord appendString:CString(@"深睡时间:%d     s \n",sum_ss)];
    [self showRsltMsgOnMainThread:sleepRecord];
}
#pragma mark - LDBraceletDeviceDelegate
- (void)deviceConnectWithResultCode:(BLEConnectCode)code
{
   
    switch (code) {
        case BLEConnectCode_ActiveConnectSucc:
            [self ADATPTERonCurrentSwiperConnectedType:LKL_ADAPTER_CONNECT_1];
            break;
            
        case BLEConnectCode_ReconnectSucc:
            [self ADATPTERonCurrentSwiperConnectedType:LKL_ADAPTER_CONNECT_4];
            break;
        case BLEConnectCode_ReconnectFail:
            [self ADATPTERonCurrentSwiperConErrorType:LKL_ADAPTER_CONNECT_3];
            break;
        case BLEConnectCode_ActiveConnectFail:
            [self ADATPTERonCurrentSwiperConErrorType:LKL_ADAPTER_CONNECT_6];
            break;
        case BLEConnectCode_ActiveConnectTimeout:
            [self ADATPTERonCurrentSwiperConErrorType:LKL_ADAPTER_CONNECT_5];
            break;
        case BLEConnectCode_ActiveDisconnectSucc:
            [self ADATPTERonCurrentSwiperDisconnectedType:LKL_ADAPTER_CONNECT_0];
            break;
        case BLEConnectCode_InactiveDisconnectSucc:
            [self ADATPTERonCurrentSwiperDisconnectedType:LKL_ADAPTER_CONNECT_2];
            break;
        default:
            break;
    }
    
    NSLog(@"deviceConnectWithResultCode:%lu",(unsigned long)code);
}
#pragma mark - TESTonCurrentSwiperConnectedType

/**
 * 设备连接成功
 * 设备连接成功 & 以哪种方式连接成功
 **/
- (void)ADATPTERonCurrentSwiperConnectedType:(LKLWatchAdapterConnectType)type
{
    [self hideProcess];
    switch (type) {
        case LKL_ADAPTER_CONNECT_1:
            [self showRsltMsgOnMainThread:@"主动连接成功"];
            break;
        case LKL_ADAPTER_CONNECT_4:
            [self showRsltMsgOnMainThread:@"重连成功"];
            break;
        default:
            break;
    }
    
    if (self.bluetoothConnecteBlock) {
        self.bluetoothConnecteBlock(1);
    }
}

/**
 * 设备断开
 * 设备断开成功 & 以哪种方式断开成功
 **/
- (void)ADATPTERonCurrentSwiperDisconnectedType:(LKLWatchAdapterConnectType)type
{
    [self hideProcess];
    switch (type) {
        case LKL_ADAPTER_CONNECT_0:
            [self showRsltMsgOnMainThread:@"主动断开成功"];
            break;
        case LKL_ADAPTER_CONNECT_2:
            [self showRsltMsgOnMainThread:@"被动断开成功"];
            break;
        default:
            break;
    }
    
    if (self.bluetoothConnecteBlock) {
        self.bluetoothConnecteBlock(0);
    }
}

/**
 * 设备连接失败
 * 设备连接失败 & 以哪种方式连接失败
 **/
- (void)ADATPTERonCurrentSwiperConErrorType:(LKLWatchAdapterConnectType)type
{
    [self hideProcess];
    switch (type) {
        case LKL_ADAPTER_CONNECT_6:
            [self showRsltMsgOnMainThread:@"主动连接失败"];
            break;
        case LKL_ADAPTER_CONNECT_3:
            [self showRsltMsgOnMainThread:@"重连失败"];
            break;
        default:
            break;
    }
    if (self.bluetoothConnecteBlock) {
        self.bluetoothConnecteBlock(0);
    }
}
#pragma mark - CLLocationManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //第一次打开或者每次蓝牙状态改变都会调用这个函数
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        DEF_DEBUG(@"蓝牙设备开着");
        self.blueToothOpen = YES;
        
        [self configuration];
        //自动重练
        [self automaticConnection];

    }
    else
    {
        DEF_DEBUG(@"蓝牙设备关着");
        self.blueToothOpen = NO;

    }
}
#pragma ＝＝＝＝＝＝＝＝＝＝＝＝hud＝＝＝＝＝＝＝＝＝＝＝＝
- (void)onShowMessage:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msg)
        {
            [self showProcessWithMsg:msg];
        }
    });
}
-(void)showProcess
{
    [self hideProcess];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window]  animated:YES];
    });
}
-(void)showProcessWithMsg:(NSString *)msg
{
    [self hideProcess];
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        hud.labelText = msg;
        
    });
}
-(void)hideProcess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    });
}

#pragma mark -
- (void)showMsgOnMainThread:(NSString*)msg
{
    DEF_DEBUG(@"msg = %@",msg);
    [self showProcessWithMsg:msg];

}
- (void)showRsltMsgOnMainThread:(NSString*)msg
{
    DEF_DEBUG(@"msg = %@",msg);

}



@end


@implementation LAKALARecordParams

@end

@implementation LAKALABleDeviceInfo

@end
