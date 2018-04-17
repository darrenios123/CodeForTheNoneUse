//
//  MobilePlugin.m
//  HelloCordova
//
//  Created by Darren on 2018/4/16.
//

#import "MobilePlugin.h"
#import <UIKit/UIDevice.h>

@implementation MobilePlugin

-(void)appraise:(CDVInvokedUrlCommand *)command{
    
    NSString * callbackID = command.callbackId;
    NSString * string = [command.arguments objectAtIndex:0];
    NSLog(@"into cordova plugin:%@",string);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APPID&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    
    CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
    
    [self.commandDelegate sendPluginResult:result callbackId:callbackID];
    
}

-(void)checkVersion:(CDVInvokedUrlCommand *)command{
    NSString * callbackID = command.callbackId;
    NSString * string = [command.arguments objectAtIndex:0];
    NSLog(@"into cordova plugin:%@",string);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSLog(@"Name:%@    Version:%@     BuildVersion:%@",app_Name,app_Version,app_build);
    
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    NSMutableDictionary * deviceDic = [NSMutableDictionary dictionary];
    [deviceDic setObject:app_Name forKey:@"app_Name"];
    [deviceDic setObject:app_Version forKey:@"app_Version"];
    [deviceDic setObject:app_build forKey:@"app_build"];
    [deviceDic setObject:userPhoneName forKey:@"userPhoneName"];
    [deviceDic setObject:deviceName forKey:@"deviceName"];
    [deviceDic setObject:phoneVersion forKey:@"phoneVersion"];
    [deviceDic setObject:phoneModel forKey:@"phoneModel"];
    [deviceDic setObject:localPhoneModel forKey:@"localPhoneModel"];
    
    
    CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"恭喜您，已经是最新版本啦！"];
    [self.commandDelegate sendPluginResult:result callbackId:callbackID];
    
}


@end
