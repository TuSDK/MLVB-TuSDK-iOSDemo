//
//  AppDelegate.m
//  TRTCSimpleDemo-OC
//
//  Created by dangjiahe on 2021/4/10.
//

#import "AppDelegate.h"
#import "TTLiveMediator.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TXLiveBase setLicenceURL:LICENSEURL key:LICENSEURLKEY];
    [TTLiveMediator setupWithAppKey:@"35ae2a66cce6fd38-04-ewdjn1"];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [TTLiveMediator terminate];
}

@end
