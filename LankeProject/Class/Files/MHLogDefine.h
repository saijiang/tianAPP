//
//  MHLogDefine.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/27.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#ifndef PerfectProject_MHLogDefine_h
#define PerfectProject_MHLogDefine_h


#ifdef DEBUG
// DEBUG模式下进行调试打印

// 输出结果标记出所在类方法与行数
#define DEF_DEBUG(fmt, ...)   fprintf(stderr,"%s:%d\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);

#else

#define DEF_DEBUG(...)   {}

#endif


#endif
