//
//  AppDelegate.h
//  ShopManager
//
//  Created by Steven on 3/15/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface NSData(AES)
- (NSString *)hexadecimalString;
+ (NSData *)dataFromHexString:(NSString *)string;
@end

@class Reachability;
@class ReachHostName;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate> {
    NSMutableDictionary *dictLanguage;
    LoginViewController *loginVC;
    
    ReachHostName* hostReach;
    Reachability* internetReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *arrayLanguage;
@property (strong, nonatomic) UINavigationController *navigationController;

+ (AppDelegate *) instance;
+ (UIImage *) imageFromColor:(UIColor *)color;

- (NSString*) getMainURL;
- (void) setMainURL:(NSString*)_url;
- (NSString*) getDatabaseURL;
- (void) setDatabaseURL:(NSString*)_url;
- (NSDictionary*) getAccountDict;
- (void) setAccountDict:(NSDictionary*)_dict;
- (NSDictionary*) getCurrentProductInfo;
- (void) setCurrentProductInfo:(NSDictionary*)_dict;

- (NSString*) encryptData:(NSString*)_inputStr;
- (NSString*) getDecryptedData:(NSString*)_hexString;

- (NSString*) getUsernameAuthorizeCouchDB;
- (NSString*) getPasswordAuthorizeCouchDB;

+ (NSString*) convertToThousandSeparator:(NSString*)_value;

@end
