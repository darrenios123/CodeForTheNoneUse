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
#import "DemoMeController.h"
#import "GuidePagesViewController.h"
#import "PublishViewController.h"
#import "HotViewController.h"
#import "UIView+JM.h"
#import "JMTabBarController.h"
#import "JMConfig.h"



@implementation AppDelegate
    
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    
    [AVOSCloud setApplicationId:@"oCBAIpfzBvtIT3qq2AslNPUU-gzGzoHsz" clientKey:@"0MbY3orKNzCQBb3CQbeNq5Kd"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (![userDefault boolForKey:@"isNotFirst"]) {//如果用户是第一次登录
        self.window.rootViewController = [[GuidePagesViewController alloc]init];
    }else{//否则直接进入登录页面
        // Other code
        MainViewController *vc1 = [[MainViewController alloc] init];
        vc1.view.backgroundColor = [UIColor whiteColor];
        vc1.title = @"首页";
        vc1.tabBarItem.image = [UIImage imageNamed:@"tab1_nor"];
        vc1.tabBarItem.selectedImage = [UIImage imageNamed:@"tab1_sel"];
        
        PublishViewController *vc2 = [[PublishViewController alloc] init];
        vc2.view.backgroundColor = [UIColor whiteColor];
        vc2.title = @"发布";
        vc2.tabBarItem.image = [UIImage imageNamed:@"tab3_nor"];
        vc2.tabBarItem.selectedImage = [UIImage imageNamed:@"tab3_sel"];
        
        HotViewController *vc3 = [[HotViewController alloc] init];
        vc3.view.backgroundColor = [UIColor whiteColor];
        vc3.title = @"热门";
        vc3.tabBarItem.image = [UIImage imageNamed:@"tab2_nor"];
        vc3.tabBarItem.selectedImage = [UIImage imageNamed:@"tab2_sel"];
        
        DemoMeController *vc4 = [[DemoMeController alloc] init];
        vc4.view.backgroundColor = [UIColor whiteColor];
        vc4.title = @"我的";
        vc4.tabBarItem.image = [UIImage imageNamed:@"tab4_nor"];
        vc4.tabBarItem.selectedImage = [UIImage imageNamed:@"tab4_sel"];
        
        
        UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:vc1];
        UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:vc2];
        UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:vc3];
        UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:vc4];
        
        
        navC1.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
        navC2.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
        navC3.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
        navC4.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
        
        navC1.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
        navC2.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
        navC3.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
        navC4.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
        
        
        navC1.navigationBar.translucent = NO;
        navC2.navigationBar.translucent = NO;
        navC3.navigationBar.translucent = NO;
        navC4.navigationBar.translucent = NO;
        
        
        
        
        
        /**************************************** Key Code ****************************************/
        
        //初始化配置信息
        JMConfig *config = [JMConfig config];
        
        config.tabBarAnimType = JMConfigTabBarAnimTypeRotationY;
        
        
        NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"首页",@"发布",@"热门",@"个人中心", nil];
        NSMutableArray *imageNormalArr = [NSMutableArray arrayWithObjects:@"tab1_nor",@"tab3_nor",@"tab2_nor",@"tab4_nor", nil];
        NSMutableArray *imageSelectedArr = [NSMutableArray arrayWithObjects:@"tab1_sel",@"tab3_sel",@"tab2_sel",@"tab4_sel", nil];
        NSMutableArray * controllersArr = [NSMutableArray arrayWithObjects:navC1,navC2,navC3,navC4, nil];
        
        JMTabBarController * tabBarVc = [[JMTabBarController alloc] initWithTabBarControllers:controllersArr NorImageArr:imageNormalArr SelImageArr:imageSelectedArr TitleArr:titleArr Config:config];
        
        self.window.rootViewController = tabBarVc;
        
        
        /******************************************************************************************/
    }
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
    
}
    
@end
