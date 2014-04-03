//
//  AppDelegate.m
//  ShopManager
//
//  Created by Steven on 3/15/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "ReachHostName.h"

//static NSString *mainURL = @"http://nhuanquang.com";
static NSString *mainURL = @"http://128.199.195.111";
static NSString *dbURL  = nil;
static NSString *usernameAuthorizeCouchDB = nil;
static NSString *passwordAuthorizeCouchDB = nil;
static NSDictionary *accountDict = nil;

static BOOL connectionRequired = NO;

#define KEY_AUT @"gd23aDs"

@implementation NSData (AES)

- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

@end

@implementation AppDelegate
@synthesize arrayLanguage;

+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (AppDelegate *) instance {
	return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (NSString*) getMainURL {
    return mainURL;
}

- (void) setMainURL:(NSString*)_url {
    mainURL = _url;
}

- (NSString*) getDatabaseURL {
    return dbURL;
}

- (void) setDatabaseURL:(NSString*)_url {
    dbURL = _url;
}

- (NSDictionary*) getAccountDict {
    return accountDict;
}

- (void) setAccountDict:(NSDictionary*)_dict {
    accountDict = _dict;
}

- (NSString*) encryptData:(NSString*)_inputStr {
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:[_inputStr dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:KEY_AUT error:&error];
    return [encryptedData hexadecimalString];
}

- (NSString*) getDecryptedData:(NSString*)_hexString {
    NSError *error;
    NSData *newEncryptedData = [NSData dataFromHexString:_hexString];
    
    NSData *decryptedData = [RNDecryptor decryptData:newEncryptedData
                                        withPassword:KEY_AUT
                                               error:&error];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

- (NSString*) getUsernameAuthorizeCouchDB {
    return usernameAuthorizeCouchDB;
}

- (NSString*) getPasswordAuthorizeCouchDB {
    return passwordAuthorizeCouchDB;
}

+ (NSString*) convertToThousandSeparator:(NSString*)_value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@"."];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@","];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[_value doubleValue]]];
    return theString;
}

#pragma mark CHECK INTERNET CONNECTION
//called by status get host name change
- (void) hostNameReachabilityChanged: (NSNotification* )note
{
    connectionRequired = [internetReach connectionRequired];
    NetworkStatus internetStatus = (NetworkStatus)[internetReach currentReachabilityStatus];
    
    switch (internetStatus) {
        case NotReachable:
        {
            connectionRequired = NO;
            break;
        }
        case ReachableViaWWAN:
        case ReachableViaWiFi:
        {
            
            if (!connectionRequired){
                connectionRequired = YES;
                break;
            }
        }
        default:
            break;
    }
    if (!connectionRequired) {
//        UIAlertView *errorDialog = [[UIAlertView alloc] initWithTitle:[dictLanguage objectForKey:@"delete.message-unaccess"] message:[dictLanguage objectForKey:@"delegate.service-temporarily-unavailable"] delegate:nil cancelButtonTitle:[dictLanguage objectForKey:@"ticket.ticket-message-ok"] otherButtonTitles:nil];
//        [errorDialog show];
//        [errorDialog release];
    }
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    @try {
        connectionRequired = [internetReach connectionRequired];
        NetworkStatus internetStatus = (NetworkStatus)[internetReach currentReachabilityStatus];
        
        switch (internetStatus) {
            case NotReachable:
            {
                connectionRequired = NO;
                break;
            }
            case ReachableViaWWAN:
            case ReachableViaWiFi:
            {
                
                if (!connectionRequired){
                    connectionRequired = YES;
                    
                }
            }
            default:
                break;
        }
        if (!connectionRequired) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"general.no-internet", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
            [dialog show];
        }
    }
    @catch (NSException *e) {
        NSLog(@"%@",e);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([[DeviceClass instance] getOSVersion] == iOS7)
    {
        [NUISettings initWithStylesheet:@"CandyTheme_iOS7.NUI"];
    }
    else
    {
        [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
        [NUISettings initWithStylesheet:@"CandyTheme_iOS6.NUI"];
    }
    [NUIAppearance init];
    
    //get account to authorize couchdb webservice
    NSMutableDictionary *settingDict = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://nhuanquang.com/Setting.plist"]];
    
    usernameAuthorizeCouchDB = [settingDict objectForKey:@"username"];
    passwordAuthorizeCouchDB = [settingDict objectForKey:@"password"];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hostNameReachabilityChanged:) name: kHostNameReachabilityChangedNotification object: nil];
    
    //    //check internet connection
    hostReach = [ReachHostName reachabilityWithHostName: @"nhuanquang.com"];
	[hostReach startNotifier];
    //    //	[self updateInterfaceWithReachability: hostReach];
    //
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    if ([[DeviceClass instance] getDevice] == IPHONE_5)
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    else
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController-480" bundle:nil];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    _navigationController.view.frame = loginVC.view.frame;
    loginVC.view.bounds = loginVC.view.frame;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = _navigationController;
    
    //register push notification
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark PUSH NOTIFICATION

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = application.applicationIconBadgeNumber+1;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Token" message:token delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [dialog show];
    //    [dialog release];
    
//    [userDefault setObject:token forKey:DEVICE_TOKEN];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
