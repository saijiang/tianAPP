//
//  NLDeviceOperatorsController.m
//  MTypeSDK
//
//  Created by su on 15/7/6.
//  Copyright © 2015年 newland. All rights reserved.
//

#import "NLDeviceOperatorsController.h"
#import <MESDK/NLBluetoothHelper.h>
#import "NLDefines.h"
#import <MESDK/ME19SwiperController.h>
#import <MESDK/NLISOUtils.h>
#import <MESDK/NLTlvMsgTagDefine.h>
#import <MESDK/NLSimpleEmvPackager.h>
#import <MESDK/NLTLVPackageUtils.h>
#import <OpenMobileAPI/UPTDeviceController.h>
#import <OpenMobileAPI/Channel.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import <MESDK/NLBluetoothHelperBLE.h>
#import <OpenMobileAPI/UPTDeviceController.h>
#import <OpenMobileAPI/Channel.h>
#import <OpenMobileAPI/MEDeviceController.h>



#define TryAudioPortNotSupport \
if (self.isDeviceTypeAudio) { \
[self showMsgOnMainThread:@"音频设备不支持该操作!"]; \
return ; \
}
NSString * const  recordName = @"offRecord";
@interface NLDeviceOperatorsController ()<CSwiperControllerDelegate>
{
        NSUserDefaults * testDefaults;
}
@property (nonatomic, strong) NSOperationQueue *deviceQueue;
@property (nonatomic, strong) ME19SwiperController *reader;
@property (nonatomic, strong) NSArray *cmdArray;
@property (nonatomic, assign) uint32_t cmdIndex;
@property (nonatomic, strong)UPTDeviceController * UNController;
@property (nonatomic, strong) NSString *devState;
@end

@implementation NLDeviceOperatorsController
@synthesize reader;

- (id)init
{
    if ((self = [super init])) {
        self.deviceQueue = [NSOperationQueue new];
        reader = [ME19SwiperController sharedInstance];
        NSLog(@"reader : %@", reader);
        if (!reader) {
            [self showMsgOnMainThread:@"该设备不支持蓝牙BLE通信"];
        }
        [reader setDelegate:self];
        
        _cmdArray = @[@"F0F07503005100010A",            // 读MT100 产品序列号
                      @"f0f075030051000204",            // 读MT100 固件版本号
                      @"f0f07502005500000301090a",      // 读sim卡信息
                      @"f0f0750200520000110000000000000000000000000000000000", // 秘钥协商
                      @"f0f075020058000020cc070fc587d09b6533e001b04d083963de60f777b024724c9509d8d2d26d8da2" //鉴权
                      ];
        _cmdIndex = 0;
        
        _UNController = [UPTDeviceController new];
    }
    
    return self;
}
#pragma mark -
- (void)doScanBluetoothDevices:(NSTimeInterval)timeout
{
    [self showMsgOnMainThread:@"正在扫描蓝牙设备..."];
//    [self.deviceQueue addOperationWithBlock:^{
        [NLBluetoothHelper startScan];
        MainPerformTimeOut(self.delegate, @selector(onScanDeviceCompleted:),nil, timeout);
//    }];
}
//- (void)doInitBluetoothDeviceWithPer:(NSString*)name
//{
//    NSLog(@"doInitBluetoothDeviceWithPer name = %@",name);
//    if (self.isConnected) {
//        [self doDeleteDevice];
//    }
//    CBPeripheral *per = self.bluetoothDevicesPER[name];
//    
//    if (!per) {
//        [self showMsgOnMainThread:CString(@"%@\n[%@ - %@]！",@"附近找不到该蓝牙设备", name,@"请确认开机和未连接状态。")];
//        return ;
//    }
//    [self showMsgOnMainThread:CString(@"%@\n[%@]", @"正在连接蓝牙设备...", name )];
//    
//    [self.deviceQueue addOperationWithBlock:^{
//       //todo 设备连接
//        [reader setConnectParams:[CSwiperConnectParams paramsWithPer:per]];
//        [reader connect];
//    }];
//}
- (void)doInitBluetoothDeviceWithUUID:(NSString*)name
{
    NSLog(@"doInitBluetoothDeviceWithUUID");
    if (self.isConnected) {
        [self doDeleteDevice];
    }
    NSString *uuid = self.bluetoothDevices[name];
    if (!uuid) {
        [self showMsgOnMainThread:CString(@"%@\n[%@]！",@"附近找不到该蓝牙设备", name,@"请确认开机和未连接状态。")];
        return ;
    }
    [self showMsgOnMainThread:CString(@"%@\n[%@ - %@]", @"正在连接蓝牙设备...", name, uuid)];
    [NLBluetoothHelper stopScan];
    [self.deviceQueue addOperationWithBlock:^{
        //todo 设备连接
        [reader setConnectParams:[CSwiperConnectParams paramsWithUuid:uuid]];
        [reader connect];
    }];
}

//state 0表示主动断开成功，1表示链接成功，2，表示被动断开成功，3表示重连失败，4表示重连成功 ,5表示超时  --新状态
- (void)onDeviceConnectedState:(NSString*)state{
    NSLog(@"state = %@",state);
    _devState = [NSString stringWithFormat:@"%@",state];
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

    
}

- (void)doDeleteDevice
{
//    if (self.isConnected) {
        [self showMsgOnMainThread:@"正在断开设备连接..."];
        [reader disConnect];
//    }
}
- (BOOL)isConnected
{
    return [reader isDevicePresent];
}

- (NSDictionary*)bluetoothDevicesPER
{
    return [NLBluetoothHelper devicePeripherals];
}
- (NSDictionary*)bluetoothDevices
{
    return [NLBluetoothHelper devices];
}
#pragma mark -获取设备信息
- (NSDictionary*)getDeviceInfo
{
    NSInteger battery = [reader battery];
    id<CSwiperDeviceInfo> info = [self.reader getDeviceInfo];
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setValue:[info sn] forKey:@"sn"];
    [data setValue:[info firmwareVersion] forKey:@"firmwareVersion"];
    [data setValue:[info appVer] forKey:@"appVer"];
    [data setValue:[info manufacturerUserDefined] forKey:@"manufacturerUserDefined"];
    [data setValue:[info lakalaSn] forKey:@"lakalaSn"];
    [data setValue:@(battery) forKey:@"battery"];
    return data;
  
}

#pragma mark -
- (void)doGetDeviceInfo
{
//    [self.deviceQueue addOperationWithBlock:^{
        id<CSwiperDeviceInfo> info = [self.reader getDeviceInfo];
        if (!info) {
            [self showRsltMsgOnMainThread:CString(@"%@",@"获取设备信息失败")];
            return ;
        }
        [self showRsltMsgOnMainThread:CString(@"%@\nsn:%@\n固件版本:%@\n设备应用版本号:%@\n厂商定义信息:%@\n拉卡拉SN号:%@", @"获取设备信息成功:", [info sn],[info firmwareVersion],[info appVer],[info manufacturerUserDefined],[info lakalaSn])];
//    }];
}
- (void)doGetBatteryInfo
{
//    [self.deviceQueue addOperationWithBlock:^{
        int ba = [reader battery];
        [self showRsltMsgOnMainThread:CString(@"%@\n%d", @"设备电量为：", ba)];
//    }];
}
- (void)doFindBracelet
{
    [reader findBracelet:nil];
}
- (void)doSysTime
{
    NSDate * date = [self.reader sysTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    [self showRsltMsgOnMainThread:CString(@"%@\n%@", @"设备时间为", text)];
}
- (void)doSetSysTime
{
    [self.reader setSysTime:[NSDate date]];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置手环时间成功")];
}
- (void)doSetRemindOpenCall
{
    Byte bytes[] = {0x03,0x03,0x03,0x01,0x03,0x03,0x03,0x03};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSLog(@"data0 =%@",data);
    [reader setRemind:data];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置手环来电提醒成功")];
}
- (void)doSetRemindCloseCall
{
    Byte bytes[] = {0x03,0x03,0x03,0x00,0x03,0x03,0x03,0x03};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSLog(@"data0 =%@",data);
    [reader setRemind:data];
    [self showRsltMsgOnMainThread:CString(@"%@",@"关闭手环来电提醒成功")];
}
- (void)doSetCallRemind
{
    Byte bytes[] = {0x00,0x04,0xc1,0xd6,0xcb,0xbc};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSLog(@"data0 =%@",data);
    for (int i = 0; i<5; i++) {
        [reader setCallRemind:data];
    }
    [self showRsltMsgOnMainThread:CString(@"%@",@"来电提醒成功")];
}
- (void)doSetPersonalParams:(NLPersonalParams*)params
{
    [reader setPersonalParams:params];
    [self showRsltMsgOnMainThread:CString(@"%@",@"个人信息设置成功")];
}
- (void)doPersonalParams
{
    NLPersonalParams *param =[self.reader personalParams];
    NSString *info = [NSString stringWithFormat:@"height:%d\nweight:%d\nsex:%d",param.height,param.weight,param.sex];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"个人信息:", info)];
}
-(void)doSetStepLenght:(NLStepLenght *)step
{
    [reader setStepLenght:step];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置步长成功")];
}
- (void)doStepLenght
{
    NLStepLenght * stepLength = [self.reader stepLenght];
    NSString *info = [NSString stringWithFormat:@"walk:%d\nrun:%d",stepLength.walkStepLenght,stepLength.runStepLenght];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"步长为:", info)];
}
- (void)doSetCurrentSleepTarget:(NSData*)data
{
    [reader setCurrentSleepTarget:data];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置睡眠目标成功")];
}
- (void)doCurrentSleepTarget
{
    NSData *data = [reader currentSleepTarget];
    NSString *info =  [NSString stringWithFormat:@"%d",[NLISOUtils intWithHexString:[NLISOUtils hexStringWithData:data]]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前睡眠目标为:", info)];
}

- (void)doSetCurrentSportTarget:(NSData*)data
{
    [reader setCurrentSportTarget:data];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置运动目标成功")];
}
- (void)doCurrentSportTarget
{
    NSData *data = [reader currentSportTarget];
    NSString *info =  [NSString stringWithFormat:@"%d",[NLISOUtils intWithHexString:[NLISOUtils hexStringWithData:data]]];
     [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前运动目标为:", info)];
}
- (void)doSetSittingRemind
{
    [self.reader setSittingRemind:[NLISOUtils hexStr2Data:@"03040050"]];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置久坐提醒成功")];
}
- (void)doSittingRemind
{
    NSString *info = [NLISOUtils hexStringWithData:[reader sittingRemind]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前久坐提醒为:", info)];
}
- (void)doCurrentSportRecord
{
    NSString *info = [NLISOUtils hexStringWithData:[reader currentSportRecord]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前运动记录为:", info)];
}
- (void)doSetHistorySportRecord
{
    [reader setHistorySportRecord:NLTlvMsgTagDefineHistorySportrecordTagDay28];
    [self showRsltMsgOnMainThread:CString(@"%@",@"清除28号运动记录成功")];
}
- (void)doHistorySportRecord
{
    int tag=NLTlvMsgTagDefineHistorySportrecordTagDay01;
    for (int i=0; i<30; i++) {
        NSData * his = [self.reader historySportRecord:tag];
        [self showRsltMsgOnMainThread:CString(@"%@  %d %@\n%@", @"第",tag,@"天 运动记录为:",[NLISOUtils hexStringWithData:his] )];
        tag++;
    }
}
- (void)doClearSportRecords
{
    [reader clearSportRecords];
    [self showRsltMsgOnMainThread:CString(@"%@",@"清除运动记录成功")];
}
- (void)doSetCurrentSleepRecord
{
    [reader setCurrentSleepRecord];
    [self showRsltMsgOnMainThread:CString(@"%@",@"清除当前睡眠记录成功")];
}
- (void)doCurrentSleepRecord
{
    NSString *info = [NLISOUtils hexStringWithData:[reader currentSleepRecord]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"当前睡眠记录为:", info)];
}
- (void)doSetHistorySleepRecord
{
    [reader setHistorySleepRecord:NLTlvMsgTagDefineHistorySleepRecordTagDay18];
    [self showRsltMsgOnMainThread:CString(@"%@",@"清除18号睡眠记录成功")];
}
- (void)doHistorySleepRecord
{
    int tag=NLTlvMsgTagDefineHistorySleepRecordTagDay01;
    for (int i=0; i<15; i++) {
        NSData * his = [self.reader historySleepRecord:tag];
        [self showRsltMsgOnMainThread:CString(@"%@  %d %@\n%@", @"第",tag,@"天 睡眠记录为:",[NLISOUtils hexStringWithData:his] )];
        tag++;
    }
}
- (void)doClearSleepRecords
{
    [reader clearSleepRecords];
    [self showRsltMsgOnMainThread:CString(@"%@",@"清除睡眠记录成功")];
}
- (void)doSetAlarmClock:(NSString*)num data:(NSData*)data
{
    [reader setAlarmClock:NLTlvMsgTagDefineAlarmClockTag1+[num intValue]-1 data:data];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置闹钟成功")];
}
- (void)doAlarmClock:(NSString*)num
{
    NSData *data = [reader alarmClock:NLTlvMsgTagDefineAlarmClockTag1-1+[num integerValue]];
    
    if (data.length>=2) {
        [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"时间:", [NLISOUtils hexStringWithData:[data subdataWithRange:NSMakeRange(0, 2)]])];
    }
    if (data.length>=3) {
        [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"FLAG:", [NLISOUtils hexStringWithData:[data subdataWithRange:NSMakeRange(2, 1)]])];
    }
    if (data.length>=4) {
        int len = [[NLISOUtils hexStringWithData:[data subdataWithRange:NSMakeRange(3, 1)]] intValue];
        if (data.length>4+len) {
            NSData * title = [data subdataWithRange:NSMakeRange(4, len)];
            [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"title:", [[NSString alloc]initWithData:title encoding:NSUTF16LittleEndianStringEncoding])];
        }
    }
}
- (void)doSyncHistorySportRecord
{
    NSArray * arr = [self.reader effectiveSprotTaglist];
    for (NSNumber * tag in arr) {
        NSData * his = [self.reader historySportRecord:[tag intValue]];
        [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"运动记录:", [NLISOUtils hexStringWithData:his])];
    }
    for (NSNumber * tag in arr) {
        [self.reader setHistorySportRecord:[tag intValue]];
    }
    [self showRsltMsgOnMainThread:CString(@"%@",@"同步运动记录成功")];
}
- (void)doSyncHistorySleepRecord
{
    NSArray * arr = [self.reader effectiveSleepTaglist];
    for (NSNumber * tag in arr) {
        NSData * his = [self.reader historySleepRecord:[tag intValue]];
        [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"睡眠记录:", [NLISOUtils hexStringWithData:his])];
    }
    for (NSNumber * tag in arr) {
        [self.reader setHistorySleepRecord:[tag intValue]];
    }
    [self showRsltMsgOnMainThread:CString(@"%@",@"同步睡眠记录成功")];
}
- (void)doSetCardPackageInfo:(NSData*)data
{
    [reader setCardPackageInfo:data];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置卡包成功")];
}
- (void)doCardPackageInfo
{
    NSString *info = [NLISOUtils hexStringWithData:[reader cardPackageInfo]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"卡包信息为:", info)];
}
- (void)doSetLocalConsumeRecords
{
    [reader setLocalConsumeRecords];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置本地消费记录成功")];
}
- (void)doLocalConsumeRecords
{
    NSString *info = [NLISOUtils hexStringWithData:[reader localConsumeRecords]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"本地消费记录信息为:", info)];
}
- (void)doSetBalanceRemind
{
    [reader setBalanceRemind:[NLISOUtils hexStr2Data:@"1388"]];
    [self showRsltMsgOnMainThread:CString(@"%@",@"设置余额提醒成功")];
}
- (void)doBalanceRemind
{
    NSString *info = [NLISOUtils hexStringWithData:[reader balanceRemind]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"余额提醒为:", info)];
}
- (void)doIcTransferWithAmout
{
    [reader icTransferWithAmout:@"0" processingCode:1 innerProcessingCode:1 isForceOnline:YES];
}
- (void)doGetPbocLog
{
    NSArray * arr = [self.reader getPbocLog];
    NSMutableString * str = [NSMutableString string];
    for (NLPbocLogDetail * detail in arr) {
        [str appendString:[NSString stringWithFormat:@"时间:%@%@,交易类型:%@",detail.transactionDate,detail.transactionTime,detail.transactionType]];
        [str appendString:@"\n"];
    }
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"PBOC记为:", str)];
}
- (void)doStartCSwiperWithAmount
{
    CSwiperParameter *param = [CSwiperParameter parameterWithContent:@"查询余额"];
    [param setEmvParamsWithTradeType98583:31 tradeTypeCUS:25 forceOnline:NO];
    [reader setStartParameter:param type:CSwiperParameterTypeSerial];
    [reader startCSwiperWithAmount:nil];
    [self showRsltMsgOnMainThread:CString(@"%@",@"余额查询成功")];
}
- (void)doStartCSwiperWithAmountOff
{
    CSwiperParameter *param = [CSwiperParameter parameterWithContent:@"交易撤销"];
    [param setEmvParamsWithTradeType98583:2 tradeTypeCUS:25 forceOnline:NO];
    [self.reader setStartParameter:param type:CSwiperParameterTypeSerial];
    [self.reader startCSwiperWithAmount:nil];
    [self showRsltMsgOnMainThread:CString(@"%@",@"交易撤销成功")];
}
- (void)doRandom
{
    NSString *info = [NLISOUtils hexStringWithData:[reader random]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"获取到的随机数为:", info)];
}
- (void)doPowerOnWithSlot
{
    NSData * data = [reader powerOnWithSlot:CSwiperICCardSlotIC1 cardType:CSwiperICCardTypeCPUCARD];
    if (data) {
        [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"上电成功:", [NLISOUtils hexStringWithData:data])];
    }
    else{
       [self showRsltMsgOnMainThread:CString(@"%@",@"上电失败")];
    }
}
- (void)doPowerOffWithSlot
{
     [reader powerOffWithSlot:CSwiperICCardSlotIC1 cardType:CSwiperICCardTypeCPUCARD];
    [self showRsltMsgOnMainThread:CString(@"%@",@"下电成功")];
}
- (void)doCallWithSlot
{
    NSData * data = [reader callWithSlot:CSwiperICCardSlotIC1 cardType:CSwiperICCardTypeCPUCARD req:[NLISOUtils hexStr2Data:@"80CA004500"] timeout:30];
    if (data) {
        [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"IC卡通信成功:", [NLISOUtils hexStringWithData:data])];
    } else {
        [self showRsltMsgOnMainThread:CString(@"%@",@"IC卡通信失败")];
    }
}
- (void)doAuthority
{
    NSError * err;
    [reader authority:@"18505911031" sn:@"000577" error:&err];
    if(err) {
        [self showRsltMsgOnMainThread:CString(@"%@",@"授权失败")];
    } else {
        [self showRsltMsgOnMainThread:CString(@"%@",@"授权成功")];
    }
}
- (void)doResetScreen
{
     [reader resetScreen];
     [self showRsltMsgOnMainThread:CString(@"%@",@"复位成功")];
}
- (void)doShutdownDeviceClose
{
    [reader shutdownDevice:NLDeviceBehavior_CLOSE];
    [self showRsltMsgOnMainThread:CString(@"%@",@"关闭设备成功")];
}
- (void)doShutdownDeviceCreboot
{
    [reader shutdownDevice:NLDeviceBehavior_CREBOOT];
    [self showRsltMsgOnMainThread:CString(@"%@",@"重启设备成功")];
}
- (void)doShutdownDeviceSleep
{
    [reader shutdownDevice:NLDeviceBehavior_SLEEP];
    [self showRsltMsgOnMainThread:CString(@"%@",@"休眠设备成功")];
}
- (void)doRestoreFactory:(NSArray*)types
{
    [reader restoreFactory:types];
    [self showRsltMsgOnMainThread:CString(@"%@",@"恢复出厂成功")];
}
- (void)doSetSysSuspendTime
{
    [reader setSysSuspendTime:1 dormantTime:2 shutdownTime:3];
    [self showRsltMsgOnMainThread:CString(@"%@",@"节能设置成功")];
}
- (void)doDeviceBinding
{
    BOOL b = [self.reader deviceBinding:nil];
    [self showRsltMsgOnMainThread:CString(@"%@",b ? @"绑定成功":@"绑定失败")];
}
- (void)doTurnToOTA
{
    BOOL b = [self.reader turnToOTA:0x00];
    [self showRsltMsgOnMainThread:CString(@"%@",b?@"进入OTA模式成功":@"进入OTA模式失败")];
}
- (void)doAutoTurnOTA:(NSString*)path
{
    [self showRsltMsgOnMainThread:CString(@"%@",@"开始自动升级固件...")];
    //进入OTA模式
    BOOL b = [self.reader turnToOTA:0x00];
    [self showRsltMsgOnMainThread:CString(@"%@",b?@"进入OTA模式成功":@"进入OTA模式失败")];
    if (!b) {
        return;
    }
    NSLog(@"判断是否断开连接");
    [self showRsltMsgOnMainThread:CString(@"%@",@"链接已断开，开始扫描设备...")];
    while(!([_devState isEqualToString:@"2"] || [_devState isEqualToString:@"0"])) {
        //线程进入等待
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NLBluetoothHelper clearAllDevices];
    dispatch_async(dispatch_get_main_queue(), ^{
        [NLBluetoothHelper startScan];
    });
    NSLog(@"判断是否扫描到DfuTarg 设备");
    while(![[NLBluetoothHelper devices] objectForKey:@"DfuTarg"]) {
        //线程进入等待
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    //停止扫描
    [NLBluetoothHelper stopScan];
    NSLog(@"进入ota升级");
    [self showRsltMsgOnMainThread:CString(@"%@",@"开始OTA固件升级...")];
    //获取DfuTarg 设备对应的uuid ，进行ota升级
    NSString *otaUuid = [[NLBluetoothHelper devices] objectForKey:@"DfuTarg"];
    NSLog(@"Dfutarg uuid = %@",otaUuid);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [reader updateOTA:path uuid:otaUuid];
    });
}
- (void)doUpdateOTA:(NSString*)path uuid:(NSString*)uuid
{
    [reader updateOTA:path uuid:uuid];
}

-(void)onUpdateOTAProgress:(float)progress err:(NSError *)err
{
    [self.delegate onUpdateOTAProgress:progress err:err];
}
- (void)doWirteProFile
{
    [self.delegate showProcess];
    NSString *bundleName = @"E91F6E8A0F4983CEAB97371123B46C880";
    NSString * filePath =[[NSBundle mainBundle] pathForResource:bundleName ofType:@".txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSInputStream *stream = [NSInputStream inputStreamWithData:data];
    BOOL isWrite = [self.reader writeProfileWith:bundleName inputStream:stream fileType:NLFileTypeCardScript];
    [self showRsltMsgOnMainThread:CString(@"%@",isWrite?@"卡脚本文件写入成功":@"卡脚本文件写入失败")];
    [self.delegate hideProcess];
}
- (void)doWirteProFile:(NSString*)path bundleName:(NSString*)bundleName
{
    NSLog(@"filePath = %@,bundleName = %@",path,bundleName);
    [self.delegate showProcess];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data || data.length == 0) {
        [self showRsltMsgOnMainThread:CString(@"%@",@"获取卡脚本文件失败")];
        [self.delegate hideProcess];
        return;
    }
    [self showRsltMsgOnMainThread:CString(@"%@",@"正在写入卡脚本文件")];
    NSInputStream *stream = [NSInputStream inputStreamWithData:data];
    BOOL isWrite = [self.reader writeProfileWith:bundleName inputStream:stream fileType:NLFileTypeCardScript];
    [self showRsltMsgOnMainThread:CString(@"%@",isWrite?@"卡脚本文件写入成功":@"卡脚本文件写入失败")];
    [self.delegate hideProcess];
}
- (void)doProFileVersion
{
    [self.delegate showProcess];
    id<CSwiperDeviceInfo> info = [reader getDeviceInfo];
    //声明一个gbk编码类型
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //使用如下方法 将获取到的数据按照gbkEncoding的方式进行编码，结果将是正常的汉字
    NSString *verSion = [[NSString alloc] initWithData:[info profileVersion] encoding:gbkEncoding];
     [self showRsltMsgOnMainThread:CString(@"%@",verSion? [NSString stringWithFormat:@"获取配置文件名成功\n%@",verSion] :@"获取配置文件名失败")];
    [self.delegate hideProcess];
}
- (void)doFileOperateWithType1
{
    [self fileOperateWithType:NLFileOperateTypeDelete fileType:NLFileTypeCardScript];
}
- (void)doFileOperateWithType2
{
    [self fileOperateWithType:NLFileOperateTypeRead fileType:NLFileTypeCardScript];
}
- (void)doFileOperateWithType3
{
    [self fileOperateWithType:NLFileOperateTypeDelete fileType:NLFileTypeFileName];
}
- (void)doFileOperateWithType4
{
    [self fileOperateWithType:NLFileOperateTypeRead fileType:NLFileTypeFileName];
}
- (void)fileOperateWithType:(NLFileOperateType)operateType fileType:(NLFileType)fileType
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.delegate showProcess];
        NLFileOperateResult *rslt =[reader operateFileWithOperateType:operateType fileType:fileType data:nil];
        NSString *str = [[NSString alloc] initWithData:rslt.data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (operateType == NLFileOperateTypeDelete && fileType == NLFileTypeCardScript) {
                [self showRsltMsgOnMainThread:CString(@"%@",([rslt.data length] <= 0) ?@"卡脚本文件删除成功":@"卡脚本文件删除失败")];
            }
            if (operateType == NLFileOperateTypeDelete && fileType == NLFileTypeFileName) {
                [self showRsltMsgOnMainThread:CString(@"%@", ([rslt.data length] <= 0) ?@"文件删除成功":@"文件删除失败")];
            }
            if (operateType == NLFileOperateTypeRead && fileType == NLFileTypeCardScript) {
                [self showRsltMsgOnMainThread:CString(@"%@",([rslt.data length] <= 0) ?@"卡脚本文件读回失败": [NSString stringWithFormat:@"卡脚本文件读回成功\n%@",str])];
            }
            if (operateType == NLFileOperateTypeRead && fileType == NLFileTypeFileName) {
                [self showRsltMsgOnMainThread:CString(@"%@",([rslt.data length] <= 0) ?@"文件读回失败": [NSString stringWithFormat:@"文件读回成功\n%@",str])];
            }
        });
        [self.delegate hideProcess];
    });
}
- (void)doActive
{
    [reader active:10 callback:^(BOOL isSuccess, NSError *err) {
        if(isSuccess){
            [self showRsltMsgOnMainThread:CString(@"%@",@"MT100上电成功")];
        }
        else{
            [self showRsltMsgOnMainThread:CString(@"%@",@"MT100上电失败")];
        }
    }];
}
- (void)doDeactive
{
    [reader deactive:^(BOOL isSuccess) {
        if(isSuccess){
            [self showRsltMsgOnMainThread:CString(@"%@",@"MT100下电成功")];
        }
        else{
            [self showRsltMsgOnMainThread:CString(@"%@",@"MT100下电失败")];
        }
    }];
}
- (void)doOnCmd
{
    [reader onCmd:[NLISOUtils hexStr2Data:_cmdArray[_cmdIndex]] timeout:10 callback:^(BOOL isSuccess, NSData *data, NSError *err) {
        
        if (isSuccess) {
            [self showRsltMsgOnMainThread:CString(@"%@",[NSString stringWithFormat:@"MT100指令%d通信调用成功=%@",self.cmdIndex,data])];
            self.cmdIndex = (self.cmdIndex+1)%(self.cmdArray.count); // 跳到下一条指令
        }
        else{
            [self showRsltMsgOnMainThread:CString(@"%@",@"MT100指令通信调用失败")];

        }
    }];

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
- (void)doGetBleDeviceInfo
{
    BleDeviceInfo *param=[reader getBleDeviceInfo];
    NSString *info = [NSString stringWithFormat:@"nickName:%@\ndeviceName:%@\nuuid:%@\npowerLevel:%d\nmacAddress:%@",param.nickName,param.deviceName,param.uuid,param.powerLevel,param.macAddress];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"MT100设备信息:", info)];
}
- (void)doPowerOn1935
{
    [reader powerOn1935];
    [self showRsltMsgOnMainThread:CString(@"%@",@"1935上电成功")];
}
- (void)doPowerOff1935
{
    [reader powerOff1935];
    [self showRsltMsgOnMainThread:CString(@"%@",@"1935下电成功")];
}
-(void)doCall1935
{
    Byte bytes[] = {0x03,0x66,0x04,0x00};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSData *rep = [reader call1935:data];
    NSLog(@"rep = %@",rep);
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"1935指令透传返回:", [NLISOUtils hexStringWithData:rep])];
}
- (void)doGetCRC
{
    NSData *rep = [reader getCRC];
    NSLog(@"rep = %@",rep);
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"1935获取到的CRC:", [NLISOUtils hexStringWithData:rep])];
}
- (void)doWriteSEL78:(NSData*)data
{
    NSData *rep = [reader writeSEL78:data];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"SEL78写数据返回:", [NLISOUtils hexStringWithData:rep])];
}
- (void)doReadSEL78:(NSData*)data length:(NSString*)len
{
//    Byte bytes[] = {0x20};
//    NSData *reqData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSData *rep = [reader readSEL78:data length:[len intValue]];
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"SEL78读数据返回:", [NLISOUtils hexStringWithData:rep])];
}
- (void)doSetPiCiNum:(NSString*)picNum
{
    NSError * err = nil;
    [[MEDeviceController sharedInstance] setPiCiNum:picNum error:&err];
    if (err) {
        [self showRsltMsgOnMainThread:CString(@"%@",err)];
    }
    else {
        [self showRsltMsgOnMainThread:CString(@"%@",@"设置银联token批次号成功")];
    }
}
- (void)doEstablish
{
    NSError * err = nil;
    [[UPTDeviceController sharedInstance] establishWithError:&err];
    if (err) {
        [self showRsltMsgOnMainThread:CString(@"%@",err)];
    }
    else {
        [self showRsltMsgOnMainThread:CString(@"%@",@"银联tsm初始化成功")];
    }
}
- (void)doOpenLogicChannel:(NSData*)aid
{
    NSError * err = nil;
//    Byte bytes[] = {0x00};
//    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    Channel *channel = [[UPTDeviceController sharedInstance] openLogicChannelWithCommand:aid error:&err];
    if (!channel || err) {
        [self showRsltMsgOnMainThread:CString(@"%@",err)];
    }
    else {
        [self showRsltMsgOnMainThread:CString(@"%@",@"银联tsm创建通道成功")];
    }
    
}
- (void)doCloseLogicChannel
{
    NSError * err = nil;
    int flag = [[UPTDeviceController sharedInstance] closeLogicChannelWithChannelId:1 error:&err];
    if (err) {
        [self showRsltMsgOnMainThread:CString(@"%@",err)];
    }
    else {
        [self showRsltMsgOnMainThread:CString(@"%@",@"银联tsm初始化成功")];
    }

}
- (void)doBleSEStatus
{
    NSError * err = nil;
    NSString *state = [[UPTDeviceController sharedInstance] bleSEStatusWithError:&err];
    if (err) {
        [self showRsltMsgOnMainThread:CString(@"%@",err)];
    }
    else {
        [self showRsltMsgOnMainThread:CString(@"%@: %@",@"银联tsm获取blestate",state)];
    }
}
- (void)doBtcInfo
{
    NSError * err = nil;
    NSData *BtcInfo = [[UPTDeviceController sharedInstance] btcInfoWithError:&err];
    if (err) {
        [self showRsltMsgOnMainThread:CString(@"%@",err)];
    }
    else {
        [self showRsltMsgOnMainThread:CString(@"%@: %@",@"银联tsm获取btcinfo",BtcInfo)];
    }
}
#pragma mark - emv
-(BOOL)isAccountTypeSelectInterceptor
{
    return YES;
}
-(BOOL)isCardHolderCertConfirmInterceptor
{
    return YES;
}
-(BOOL)isEcSwitchInterceptor
{
    return YES;
}
-(BOOL)isTransferSequenceGenerateInterceptor
{
    return NO;
}
-(BOOL)isLCDMsgInterceptor
{
    return YES;
}
-(int)accTypeSelect
{
    return 1;
}
-(BOOL)cardHolderCertConfirm:(NLEmvCardholderCertType)certType certNo:(NSString *)certno
{
    return YES;
}
-(int)ecSwitch
{
    return 1;
}
-(int)incTsc
{
    return 0;
}

-(int)lcdTitle:(NSString *)title msg:(NSString *)msg isShow:(BOOL)yesnoShowed waittingTime:(int) waittingTime
{
    return 1;
}

- (void)onRequestSelectApplication:(id<NLEmvTransController>)controller context:(NLEmvTransInfo*)context error:(NSError*)err
{
}
- (void)onRequestTransferConfirm:(id<NLEmvTransController>)controller context:(NLEmvTransInfo*)context error:(NSError*)err
{
}
- (void)onRequestPinEntry:(id<NLEmvTransController>)controller context:(NLEmvTransInfo*)context error:(NSError*)err
{
    NSLog(@"cardNo:%@",context.cardNo);
}
- (void)onRequestOnline:(id<NLEmvTransController>)controller context:(NLEmvTransInfo*)context error:(NSError*)err
{
    NSLog(@"%@:%@", context, err);
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"pboc读卡:", err == nil ? @"成功!" : @"失败！")];
    NSString *info = [NSString stringWithFormat:@"cardNo:%@\ncardExpirationDate:%@\ntransactionDate:%@\n",
                       [context cardNo],
                       [context cardExpirationDate],
                       [context transactionDate]];
    [self showRsltMsgOnMainThread:CString(@"%@",info)];
    
    NSArray *fields1 = @[@"appCryptogram",//0x9f26
                         @"cryptogramInformationData",//0x9f27
                         @"issuerApplicationData",//0x9f10
                         @"unpredictableNumber",//0x9f37
                         @"appTransactionCounter",//0x9f36
                         @"terminalVerificationResults",//0x95
                         @"transactionDate",//0x9a
                         @"transactionType",//0x9c
                         @"amountAuthorisedNumeric",//0x9f02
                         @"transactionCurrencyCode",//0x5f2a
                         @"applicationInterchangeProfile",//0x82
                         @"terminalCountryCode",//0x9f1a
                         @"amountOtherNumeric",//0x9f03
                         @"terminal_capabilities",//0x9f33
                         @"cvmRslt",//0x9f34
                         @"terminalType",//0x9f35
                         @"interface_device_serial_number",//0x9f1e
                         @"dedicatedFileName",//0x84
                         @"appVersionNumberTerminal",//0x9f09
                         @"transactionSequenceCounter",//0x9f41
                         @"cardProductIdatification"//0x9f63
                         ];
    NSData *ic55 = [[NLSimpleEmvPackager sharedPackager] pack:context fields:fields1];
    //    NSArray *xArr = @[];
    NSArray *fields = [NSMutableArray arrayWithArray:[[NLEmvTransInfo emvTagDefineds] allKeys]];
    //    [fields removeObjectsInArray:xArr];
    NSData *pack8583Data = [[NLSimpleEmvPackager sharedPackager] pack:context fields:fields];
    NSLog(@"%@", pack8583Data);
    
    NSMutableData *tc55Data = [NSMutableData dataWithData:pack8583Data];
    id<TLVPackage> tlvPackage = [NLTLVPackageUtils tlvPackage];
    // 多个tag...依次append(金额等)
    [tlvPackage appendWithTag:0x00 value:[NLISOUtils str2bcd:[NSString stringWithFormat:@"%@", context.amountAuthorisedNumeric] padLeft:NO]];
    // pack
    [tc55Data appendData:[tlvPackage pack]];
    
    
    
    if (err) {
        return ;
    }
    //[self.reader emvFinish:NO];
    
    //if (![context isNeedOnLinePin]) {
    // 交易然后才二次授权
    //    [self performSelector:@selector(secondIssuance) withObject:nil];
    //} else {
    //        [self startPin:nil];
    //        self.isPBOC = YES;
    //    }
}
- (void)onEmvFinished:(BOOL)isSuccess context:(NLEmvTransInfo*)context error:(NSError*)err
{
    [self showRsltMsgOnMainThread:CString(@"%@ \n %@", @"pboc指令结束:", err == nil ? @"成功!" : @"失败！")];
    NSString *info = [NSString stringWithFormat:@"appCryptogram:%@\ntransactionDate:%@", [context appCryptogram], [context transactionDate]];
    [self showRsltMsgOnMainThread:CString(@"%@",info)];
    NSLog(@"%@:%@", context, err);
    
    [reader stopCSwiper];
}
- (void)onFallback:(NLEmvTransInfo*)context error:(NSError*)err
{
    [self showRsltMsgOnMainThread:CString(@"%@",@"IC卡读卡失败，请刷磁条卡!")];
    /*CSwiperParameter *param = [CSwiperParameter magneticCardParameterWitContent:@"收款"];
     [self.reader setStartParameter:param type:CSwiperParameterTypeSerial];
     [self.reader startCSwiperWithAmount:@"2.00"];*/
}
- (void)onError:(id<NLEmvTransController>)controller error:(NSError*)err
{

}

#pragma mark -
- (void)showMsgOnMainThread:(NSString*)msg
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onShowMessage:)]) {
        [self.delegate onShowMessage:msg];
    }
}
- (void)showRsltMsgOnMainThread:(NSString*)msg
{
    [self processingUnLock];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onShowMessage:)]) {
        [self.delegate onShowMessage:msg];
    }
}
#pragma mark -
- (void)processingLock
{
    self.isProcessing = YES;
}
- (void)processingUnLock
{
    self.isProcessing = NO;
}
@end
