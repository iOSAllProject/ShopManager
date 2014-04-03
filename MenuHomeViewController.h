//
//  MenuHomeViewController.h
//  ShopManager
//
//  Created by Steven on 3/15/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MenuHomeViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) IBOutlet UILabel *lbOrderReceipt;
@property (strong, nonatomic) IBOutlet UILabel *lbCamera;
@property (strong, nonatomic) IBOutlet UILabel *lbPushNotification;
@property (strong, nonatomic) IBOutlet UILabel *lbUsername;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;

- (IBAction)tapOrderReceipt:(id)sender;
- (IBAction)tapCamera:(id)sender;
- (IBAction)tapPushNotification:(id)sender;
- (IBAction)logoutAction:(id)sender;


@end
