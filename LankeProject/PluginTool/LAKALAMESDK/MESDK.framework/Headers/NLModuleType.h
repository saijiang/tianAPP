//
//  NLModuleType.h
//  mpos
//
//  Created by su on 13-6-21.
//  Copyright (c) 2013年 suzw. All rights reserved.
//
/*!
 @enum
 @abstract 支持的模块类型
 @constant NLModuleTypeCommonDeviceManager 通用操作模块
 @constant NLModuleTypeCommonLCD 液晶屏模块
 @constant NLModuleTypeCommonKeyboard 按键模块
 @constant NLModuleTypeCommonPinInput 密码键盘模块
 @constant NLModuleTypeCommonEMV 通用EMV流程处理模块
 @constant NLModuleTypeCommonFileIO 文件IO操作模块（ME不支持）
 @constant NLModuleTypeCommonSwiper 磁条卡模块
 @constant NLModuleTypeCommonICCard IC卡模块
 @constant NLModuleTypeCommonNCCard 通用非接卡模块
 @constant NLModuleTypeCommonSecurity 安全模块
 @constant NLModuleTypeCommonPrinter 打印模块（ME不支持）
 @constant NLModuleTypeCommonQPBOC PBOC流程处理模块
 @constant NLModuleTypeCommonScanner 扫描仪（ME不支持）
 @constant NLModuleTypeCommonBuzzer 蜂鸣器（暂不支持）
 @constant NLModuleTypeCommonIndicatorLight 指示灯（暂不支持）
 @constant NLModuleTypeCommonCardReader 读卡模块
 @constant NLModuleTypeCommonHealthManage 健康管理
 @constant NLModuleTypeCommonRemoteMsgManage  消息管理
 @constant NLModuleTypeCommonCardPackageInfoManage 卡包管理
 @constant NLModuleTypeCommonTlvMsgManage tlv设置管理
 */
typedef enum {
    NLModuleTypeCommonDeviceManager,
    NLModuleTypeCommonLCD,
    NLModuleTypeCommonKeyboard,
    NLModuleTypeCommonPinInput,
    NLModuleTypeCommonEMV,
    NLModuleTypeCommonFileIO,
    NLModuleTypeCommonSwiper,
    NLModuleTypeCommonICCard,
    NLModuleTypeCommonNCCard,
    NLModuleTypeCommonSecurity,
    NLModuleTypeCommonPrinter,
    NLModuleTypeCommonQPBOC,
    NLModuleTypeCommonScanner,
    NLModuleTypeCommonBuzzer,
    NLModuleTypeCommonIndicatorLight,
    NLModuleTypeCommonCardReader,
    NLModuleTypeCommonHealthManage,
    NLModuleTypeCommonRemoteMsgManage,
    NLModuleTypeCommonCardPackageInfoManage,
    NLModuleTypeCommonTlvMsgManage
}NLModuleType;

/*!
 @method
 @abstract 获取具体某个模块的描述信息
 @param moduleType 模块枚举类型
 @discussion
 @return 模块对应描述信息
 */
NSString* getModuleTypeDescription(NLModuleType moduleType);

