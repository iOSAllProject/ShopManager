//
//  AddPushNotificationViewController.h
//  ShopManager
//
//  Created by Steven on 3/28/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPushNotificationViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *lbCustomerTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbNumberCustomer;
@property (strong, nonatomic) IBOutlet UILabel *lbMessageTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbNotMoreCharacter;
@property (strong, nonatomic) IBOutlet UILabel *lbNumberCharacter;
@property (strong, nonatomic) IBOutlet UITextView *txtMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnPushMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectItem;
@property (strong, nonatomic) NSDictionary *currentProductInfo;

- (IBAction)selectItem:(id)sender;
- (IBAction)pushMessageAction:(id)sender;

@end
