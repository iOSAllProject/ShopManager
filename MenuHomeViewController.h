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
@property (strong, nonatomic) IBOutlet UIButton *btnOrderReceipt;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) IBOutlet UIButton *btnPushNotification;
@property (strong, nonatomic) IBOutlet UIButton *btnSetting;
@property (strong, nonatomic) IBOutlet UILabel *lbSetting;

- (IBAction)tapOrderReceipt:(id)sender;
- (IBAction)tapCamera:(id)sender;
- (IBAction)tapPushNotification:(id)sender;
- (IBAction)tapSetting:(id)sender;
- (IBAction)logoutAction:(id)sender;


@end
