//
//  MobilePlugin.h
//  fenghuang
//
//  Created by Darren on 2018/4/16.
//
#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>


@interface MobilePlugin : CDVPlugin

-(void)appraise:(CDVInvokedUrlCommand *)command;
    
-(void)checkVersion:(CDVInvokedUrlCommand *)command;

@end
