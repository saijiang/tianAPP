//
//  ME19SwiperController.h
//  MTypeSDK
//
//  Created by wanglx on 15/4/17.
//  Copyright (c) 2015年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MESwiperController.h"
#import "NLAidEntry.h"
#import "NLLocalConsumeRecord.h"
#import "NLFileOperateResult.h"

@class NLStepLenght;
@class NLPersonalParams;
@class NLFileOperateResult;
@class NLLocalConsumeRecord;
@protocol CSwiperTlvMsgManage <NSObject>
/**
 * 获取运动卡路里
 * @param sex 性别（YES男，NO女）
 * @param height 身高(cm)
 * @param weight 体重（kg）
 * @param age 年龄(year)
 * @param run 跑步步数(step)
 * @param walk 走路步数(step)
 */
+ (int)getCalorie:(bool)sex height:(int)height weight:(int)weight age:(int)age run:(int)run walk:(int)walk;
/**
 * 设置个人参数
 * @param params 个人参数
 */
-(void)setPersonalParams:(NLPersonalParams *)params;
/**
 * 获取个人参数
 */
-(NLPersonalParams *)personalParams;
/**
 * 设置步长
 * @param stepLenght 步长
 */
-(void)setStepLenght:(NLStepLenght *)stepLenght;
/**
 * 获取步长
 * @return
 */
-(NLStepLenght *)stepLenght;
/**
 * 设置当前运动目标
 * @param target 当前运动目标
 */
-(void)setCurrentSportTarget:(NSData *)target;
/**
 * 获取当前运动目标
 * @return
 */
-(NSData *)currentSportTarget;
/**
 * 设置当前睡眠目标
 * @param target 当前睡眠目标
 */
-(void)setCurrentSleepTarget:(NSData *)target;
/**
 * 获取当前睡眠目标
 * @return
 */
-(NSData *)currentSleepTarget;
/**
 * 设置久坐提醒
 * @param data 久坐提醒
 */
-(void)setSittingRemind:(NSData *)data;
/**
 * 获取久坐提醒
 * @return
 */
-(NSData *)sittingRemind;
/**
 * 设置当前运动记录(实际是做清除用)
 */
-(void)setCurrentSportRecord;
/**
 * 获取当前运动记录
 * @return
 */
-(NSData *)currentSportRecord;
/**
 * 设置历史运动记录(实际是做清除用)
 * @param day哪一天的tag
 */
-(void)setHistorySportRecord:(int)day;
/**
 * 获取某天运动记录
 * @param day哪一天的tag
 * @return
 */
-(NSData *)historySportRecord:(int)day;
/**
 * 清除运动记录
 */
-(void)clearSportRecords;
/**
 * 设置当前睡眠记录(实际是做清除用)
 */
-(void)setCurrentSleepRecord;
/**
 * 获取当前睡眠记录
 * @return
 */
-(NSData *)currentSleepRecord;
/**
 * 设置历史睡眠记录(实际是做清除用)
 * @param day哪一天的tag
 */
-(void)setHistorySleepRecord:(int)day;
/**
 * 获取某天睡眠记录
 * @param day哪一天的tag
 * @return
 */
-(NSData *)historySleepRecord:(int)day;
/**
 * 清除睡眠记录
 */
-(void)clearSleepRecords;
/**
 * 设置某个闹钟
 * @param tag  哪个闹钟的tag
 * @param data 闹钟数据
 */
-(void)setAlarmClock:(int)tag data:(NSData *)data;
/**
 * 获取某个闹钟
 * @param tag 哪个闹钟的tag
 * @return
 */
-(NSData *)alarmClock:(int)tag;
/**
 *  查找手环
 *
 *  @param data 默认00
 */
-(void)findBracelet:(NSData *)data;
/**
 * 设置卡包信息
 * @param data 卡包信息
 */
-(void)setCardPackageInfo:(NSData *)data __attribute__ ((deprecated()));
/**
 * 获取卡包信息
 * @return
 */
-(NSData *)cardPackageInfo __attribute__ ((deprecated()));
/*
 * 指定应用记录上传（指定后，cardPackageList将只返回指定的应用卡包信息列表）
 * @param aid 指定应用AID
 */
- (void)setAppointRecordWithAid:(NSData*)aid;
/**
 * 批量更新卡包信息（默认执行添加，如果AID一致则进行修改操作）
 * @param aidEntryList<NLAidEntry> 卡包信息列表
 */
- (void)updateCardPackageList:(NSArray *)aidEntryList;
/**
 * 批量删除卡包信息
 * @param aidEntryList<NLAidEntry> 卡包信息列表
 */
- (void)deleteCardPackageList:(NSArray *)aidEntryList;
/**
 * 获取卡包信息列表（可结合setAppointRecordWithAid:指定具体应用来获取列表）
 * @return NSArray<NLAidEntry>
 */
- (NSArray*)cardPackageList;
/**
 * 设置本地消费记录(实际是做清除用)
 */
-(void)setLocalConsumeRecords;
/**
 * 获取本地消费记录
 * @return
 */
-(NSData *)localConsumeRecords __attribute__ ((deprecated()));
/**
 * 获取本地消费记录
 * @return NSArray<NLLocalConsumeRecord*>
 */
-(NSArray*)localConsumeRecordList;
/**
 * 更新本地余额
 * @param AIDList 需要更新的AID列表 ，当参数为空时,表示更新全部余额，aid列表nsdata数组
 * @return 更新余额是否成功
 */
-(BOOL)flushBalance:(NSArray*)AIDList;
/**
 * 设置余额提醒
 * @param data 余额提醒
 */
-(void)setBalanceRemind:(NSData *)data;
/**
 * 获取余额提醒
 * @return
 */
-(NSData *)balanceRemind;
/**
 * 获取有效运动tag
 * @return NSArray (NSNumber)
 */
-(NSArray *)effectiveSprotTaglist;
/**
 * 获取有效睡眠tag
 * @return NSArray (NSNumber)
 */
-(NSArray *)effectiveSleepTaglist;
/**
 * 来电提醒设置
 * @param data 来电
 */
-(void)setCallRemind:(NSData *)data;
/**
 * 短信提醒设置
 * @param data
 */
-(void)setShortMsgRemind:(NSData *)data;
/**
 * 社交软件提醒设置
 * @param data
 */
-(void)setSocialRemind:(NSData *)data;
/**
 * 防丢提醒设置
 * @param data
 */
-(void)setLostRemind:(NSData *)data;
/**
 * 设置提醒
 * @param data
 */
-(void)setRemind:(NSData *)data;
/**
 *  获取提醒
 *
 *  @return
 */
-(NSData *)remind;
/**
 *  设置tag值
 *
 *  @param tag
 *  @param value
 */
-(void)setTag:(int)tag value:(NSData *)value;
/**
 *  获取tag值
 *
 *  @param tag
 *
 *  @return
 */
-(NSData *)valueForTag:(int)tag;
/**
 *  获取TLV数据
 *
 *  @param tags tag列表
 *
 *  @return tlv数据 (字典key为NSNumber，字典对应object为NSData)
 */
-(NSDictionary*)valuesForTags:(NSArray*)tags;
/*!
 *  设置TLV数据
 *
 *  @param tlvInfos tlv数据(字典key为NSNumber，字典对应object为NSData/十六进制NSString，如果是实现清空tag则对应value必须为0x00)
 *
 *  @return 设置是否成功
 */
- (BOOL)setTagValues:(NSDictionary*)tlvInfos;
/*!
 *  清空Tag数据
 *
 *  @param tags 要清空的tag列表(NSNumber)
 *
 *  @return 清空是否成功
 */
- (BOOL)clearValueForTags:(NSArray*)tags;

/*!
 @method
 @abstract 1935上电
 */
- (void)powerOn1935;
/*!
 @method
 @abstract 1935下电
 */
- (void)powerOff1935;
/*!
 @method
 @abstract 1935指令透传
 @param data 透传指令
 @return 返回数据
 */
- (NSData*)call1935:(NSData*)data;
/*!
 @method
 @abstract 获取1935的crc值
 @return 返回935的crc值
 */
- (NSData*)getCRC;
/*!
 @method
 @abstract SLE78 写数据
 @param data 写数据
 @return 返回数据
 */
- (NSData*)writeSEL78:(NSData*)data;
/*!
 @method
 @abstract sel78 读数据
 @param data 读数据
 @param len 长度
 @return 返回数据
 */
- (NSData*)readSEL78:(NSData*)data length:(int)len;

@end

@protocol CSwiperMT100Handler;
@interface ME19SwiperController : NSObject<CSwiperControllerBluetoothOperator, CSwiperControllerEmvOperator, CSwiperControllerQPCardOperator, CSwiperControllerPrintOperator, CSwiperControllerStorageOperator, CSwiperICCardOperator,CSwiperControllerEmvLevel2Operator,CSwiperDeviceManage,CSwiperTlvMsgManage, CSwiperMT100Handler> {
}
/*!
 @property delegate
 @abstract 要从MSR MESwiperController中获取通知信息如插入设备提示、卡信息回馈，需赋值delegate，实现CSwiperControllerDelegate的方法。
 */
@property (nonatomic, assign) NSObject<CSwiperControllerDelegate> *delegate;
/*!
 @property detectDeviceChange
 @abstract 设置是否响应onDevicePlugged和onDeviceUnPlugged事件
 */
@property (nonatomic, assign)BOOL detectDeviceChange;
/*!
 @property swipeTimeout
 @abstract 设置刷卡超时时间。单位为秒。
 */
@property (nonatomic, assign) double swipeTimeout;
/*!
 @property connectParams
 @abstract 设置连接参数。蓝牙为uuid。
 */
@property (nonatomic, strong) CSwiperConnectParams *connectParams;
/*!
 @method
 @abstract 获取实例对象
 @discussion 不要自己实例化该驱动对象，直接从这个方法获取实例对象。该实例对象是线程安全的。
 @result 返回实例对象
 */
+ (id)sharedInstance;
/*!
 @method
 @abstract 判断当前是否有设备
 @discussion 如果未插上设备或设备未插好，将返回NO，否则返回YES。只有YES的时候，程序才能进入正常刷卡流程。
 @result 是否检测到设备
 */
- (BOOL)isDevicePresent;
/*!
 @method
 @abstract 启动刷卡程序
 @discussion 启动刷卡程序，将进入刷卡流程如判断设备是否插上，启动是否成功等。
 */
- (void)startCSwiper;

/*!
 @method
 @abstract 停止刷卡程序
 @discussion 停止刷卡程序，使之暂停刷卡服务。
 */
- (void)stopCSwiper;

/*!
 @method
 @abstract 卸载刷卡驱动
 @discussion 卸载刷卡驱动，使之停止并移除刷卡服务。
 */
- (void)deleteCSwiper;

/*!
 @method
 @abstract 获取运行状态
 @discussion 获取当前刷卡程序内部运行状态。状态值范围定义在CSwiperControllerState枚举类型中。
 @result 运行状态
 */
- (CSwiperControllerState)getCSwiperState;

/*!
 @method
 @abstract 获得刷卡器系列号
 @discussion 刷卡器KSN中的左边14位BCD码，可以判断刷卡器是否合法设备
 刷卡器KeySet（4位BCD）＋10位系列号BCD码，共14个字符
 */
- (void)getCSwiperKsn;
/*!
 @method
 @abstract 获得当次刷卡扩展数据
 @discussion onDecodeCompleted方法回调期间调用有效，对应该次刷卡的扩展数据。不包含磁道等数据信息。onDecodeCompleted回调结束会被清掉，再次调用无效。外面如果要在其他地方使用，必须被copy或retain
 // @param isClean 是否调用后马上清除数据
 @return 刷卡扩展数据（key-value），如是否有IC卡isICCard。Key @reference CSwiperCardDataKey相关字符串常量定义
 */
- (NSDictionary*)getSwipeCardExtendData;
#pragma mark ME30E specify methods
/*!
 @method
 @abstract
 @discussion
 type=，可通过下发约定好的交易序号来定制交易类型显示
 eg：setStartParameter:@(1) type:CSwiperParameterTypeSerial; startCSwiperWithAmount:@"20.00";
 
 type=CSwiperParameterTypeCharsets，可通过下发自定义的字符(150字符集内)来定制交易类型显示
 eg：setStartParameter:@“自定义交易” type:CSwiperParameterTypeCharsets; startCSwiperWithAmount:@"20.00";
 
 type=，可通过下发自定义的字符(150字符集内)来调整全屏显示的信息
 eg：setStartParameter:“全屏交易测试\r\n欢迎使用拉卡拉收款宝\r\n交易金额:22.00” CSwiperParameterTypeCustom; startCSwiperWithAmount:@"";
 @param data 下发参数（NSNumber封装交易序号整数、NSString封装自定义字符串）
 @param type 交易类型显示
 @return
 */
- (BOOL)setStartParameter:(id)data type:(CSwiperParameterType)type;
/*!
 @method
 @abstract ME30E启动方式
 @discussion 启动后，会提示输入pin。30秒未完成pin输入，则发生pin输入超时
 */
- (void)startInputPIN;
/*!
 @method
 @abstract ME30E启动方式
 @discussion 启动时带入金额参数
 @param amount 金额，单位是分且无小数点
 */
- (void)startCSwiperWithAmount:(NSString*)amount;
/*!
 @method
 @abstract ME30E重置之前的操作
 @discussion 撤销前面的操作，回到欢迎界面
 */
- (void)resetScreen;
/*!
 @method
 @abstract ME30E关机
 @discussion 主动进行关机
 */
- (void)powerOff;
#pragma mark - device info
- (id<CSwiperDeviceInfo>)getDeviceInfo;

#pragma mark - ME19专用API
/*!
 @method
 @abstract 配置文件操作
 @discussion
 @param operateType 文件操作类型
 @param fileType 文件类型
 @param data 内容
 @return 操作结果
 */
- (NLFileOperateResult*)operateFileWithOperateType:(NLFileOperateType)opType fileType:(NLFileType)fileType data:(NSData *)data;
/*!
 @method
 @abstract 配置文件写入
 @param filePath 文件路径
 @param fileType 文件类型 开机文件 卡操作脚本文件
 @return 配置文件写入是否成功
 */
- (BOOL)writeProfileWith:(NSString*)filePath fileType:(NLFileType)fileType;
- (BOOL)writeProfileWith:(NSString *)fileName  inputStream:(NSInputStream*)input fileType:(NLFileType)fileType;

@end
/*!
 蓝牙设备对象（bleDevice）
 */
@interface BleDeviceInfo : NSObject
/**
 * 设备别名，可以由用户设置，设置后替代deviceName显示于界面
 */
@property (nonatomic, strong) NSString* nickName;
/**
 * 设备名称，只读
 */
@property (nonatomic, strong) NSString *deviceName;
/**
 * 设备唯一性标示，只读
 */
@property (nonatomic, strong) NSString *uuid;
/**
 * 当前电量，只读
 */
@property (nonatomic) int powerLevel;
/**
 * 厂商设备类型，只读
 */
@property (nonatomic) NLProductID type;
/**
 * 设备物理地址，只读
 */
@property (nonatomic, strong) NSString *macAddress;

- (id)initWithDeviceUUID:(NSString*)uuid;
@end

@protocol CSwiperMT100Handler <NSObject>
/*!
 @method
 @abstract MT100上电
 @discussion
 @param timeout 超时时间（单位为秒）
 @param callback :{isSuccess:是否成功 err:上电失败原因}
 @return
 */
- (void)active:(NSTimeInterval)timeout callback:(void (^)(BOOL isSuccess, NSError *err))callback;
- (BOOL)active:(NSTimeInterval)timeout error:(NSError**)err;
/*!
 @method
 @abstract MT100指令通信调用
 @discussion
 @param data 指令数据
 @param timeout 指令响应超时时间（单位为秒）
 @param callback (isSuccess:是否成功 data:指令响应数据 err:通信失败原因)
 @return
 */
- (void)onCmd:(NSData*)data timeout:(NSTimeInterval)interval callback:(void (^)(BOOL isSuccess, NSData *data, NSError *err))callback;
- (NSData*)onCmd:(NSData*)data timeout:(NSTimeInterval)interval error:(NSError**)err;
/*!
 @method
 @abstract MT100下电
 @param callback (isSuccess:是否成功)
 @return
 */
- (void)deactive:(void (^)(BOOL isSuccess))callback;
- (BOOL)deactive;
/*!
 @method
 @abstract 撤销当前执行指令，以便进行MT100指令通信
 @discussion 如果是在进行圈存等Emv操作，不可撤销。
 @param callback (isSuccess:是否成功,不可撤销、撤销失败返回NO，撤销指令成功返回YES)
 @return
 */
- (void)cancel:(void (^)(BOOL isSuccess))callback;
/*!
 @method
 @abstract 获取蓝牙设备对象
 @discussion
 @param callback (isSuccess:是否成功)
 @return  蓝牙设备对象（bleDevice）
 */
- (BleDeviceInfo*)getBleDeviceInfo;
/*!
 @method
 @abstract 当ancs是关闭的情况下可以使用这个函数进行打开ancs，打开的情况下也可以调用没有影响。
*/
-(void)openAncs;
/*!
 @method
 @abstract 判断当前设备是否ancs配对
 @discussion 如果当前连接设备已ancs配对，将返回yes，否则返回no。
 @result 是否ancs配对
 */
- (BOOL)isAncsExit;
@end
