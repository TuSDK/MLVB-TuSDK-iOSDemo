//
//  AppDelegate.m
//  TRTCSimpleDemo-OC
//
//  Created by dangjiahe on 2021/4/10.
//

#import "AppDelegate.h"
#import "TuSDKManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TXLiveBase setLicenceURL:LICENSEURL key:LICENSEURLKEY];
    
    [[TuSDKManager sharedManager] initSdkWithAppKey:TuSDKAPPKET];
    /**
     如果采用自定义采集方案，需要在此处添加 [TUPEngine Init:nil];
     
     */
    [TUPEngine Init:nil];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [TUPEngine Terminate];
}


@end
