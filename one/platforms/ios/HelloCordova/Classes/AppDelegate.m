/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  HelloCordova
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GuidePagesViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloud/AVAnalytics.h>


@implementation AppDelegate
    
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
    {
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        [AVOSCloud setApplicationId:@"oCBAIpfzBvtIT3qq2AslNPUU-gzGzoHsz" clientKey:@"0MbY3orKNzCQBb3CQbeNq5Kd"];
        [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        
        
        // LeanCloud - 查询 -
        // https://leancloud.cn/docs/leanstorage_guide-objc.html#查询
        AVQuery *query = [AVQuery queryWithClassName:@"data"];
        // isReal 为 o，关
        [query includeKey:@"isReal"];
        // intoUrl 为 url
        [query includeKey:@"intoUrl"];
        //wwwf 为网络协议
        [query includeKey:@"wwwf"];
        NSArray * arrray = [NSArray arrayWithArray:[query findObjects]];
        if(arrray.count>0){
            NSDictionary * dic = [arrray objectAtIndex:0];
            if ([[dic objectForKey:@"isReal"] isEqualToString:@"on"]) {
                NSLog(@"开关on状态");
                MainViewController * mainVC =  [[MainViewController alloc] init:[dic objectForKey:@"wwwf"] andUrl:[dic objectForKey:@"intoUrl"]];
                if (![userDefault boolForKey:@"isNotFirst"]) {//如果用户是第一次登录
                    NSLog(@"First blood");
                    self.window.rootViewController = [[GuidePagesViewController alloc]init];
                }else{//否则直接进入登录页面
                    self.window.rootViewController = mainVC;
                }
            }else{
                NSLog(@"开关off状态");
                MainViewController * mainVC =  [[MainViewController alloc] init];
                if (![userDefault boolForKey:@"isNotFirst"]) {//如果用户是第一次登录
                    self.window.rootViewController = [[GuidePagesViewController alloc]init];
                }else{//否则直接进入登录页面
                    self.window.rootViewController = mainVC;
                }
            }
        }else{
            NSLog(@"查询数据失败");
            MainViewController * mainVC =  [[MainViewController alloc] init];
            if (![userDefault boolForKey:@"isNotFirst"]) {//如果用户是第一次登录
                self.window.rootViewController = [[GuidePagesViewController alloc]init];
            }else{//否则直接进入登录页面
                self.window.rootViewController = mainVC;
            }
        }

        
        
        [self.window makeKeyAndVisible];
        return YES;
        
    }
    
    @end
