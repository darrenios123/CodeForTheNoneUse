//
//  MobilePlugin.m
//  HelloCordova
//
//  Created by Darren on 2018/4/16.
//

#import "MobilePlugin.h"

@implementation MobilePlugin

-(void)appraise:(CDVInvokedUrlCommand *)command{
    NSString * callbackID = command.callbackId;
    NSString * string = [command.arguments objectAtIndex:0];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APPID&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    
    CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
    
    [self.commandDelegate sendPluginResult:result callbackId:callbackID];
    
}

@end
