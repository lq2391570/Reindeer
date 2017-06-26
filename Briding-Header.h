//
//  Briding-Header.h
//  Reindeer
//
//  Created by shiliuhua on 2017/5/19.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

#ifndef Briding_Header_h
#define Briding_Header_h

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <NIMAVChat/NIMAVChat.h>
#import <NIMSDK/NIMSDK.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "NTESVideoChatViewController.h"
#import "NTESNetChatViewController.h"
#import "NTESAudioChatViewController.h"

//#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef __OBJC__
//#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "NTESGlobalMacro.h"




#define NTES_USE_CLEAR_BAR - (BOOL)useClearBar{return YES;}

#define NTES_FORBID_INTERACTIVE_POP - (BOOL)forbidInteractivePop{return YES;}
//#import <DDLogMacros/DDLogMacros.h>
//#import "NTESGlobalMacro.h"
//#import "NIMKit.h"
//#import <FMDB/FMDB.h>
//#import <CocoaLumberjack/CocoaLumberjack.h>
//#import <SSZipArchive/SSZipArchive.h>

//#ifdef DEBUG
//static DDLogLevel ddLogLevel = DDLogLevelVerbose;
//#else
//static DDLogLevel ddLogLevel = DDLogLevelInfo;
//#endif
//
//#define NTES_USE_CLEAR_BAR - (BOOL)useClearBar{return YES;}
//
//#define NTES_FORBID_INTERACTIVE_POP - (BOOL)forbidInteractivePop{return YES;}
//
//
#endif

#endif /* Briding_Header_h */
