//
//  LoginViewController.h
//  ShopManager
//
//  Created by Steven on 3/15/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    NSDictionary *dictLanguage;
}

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UILabel *lbRememberMe;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;
//@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *lbWelcome;
@property (strong, nonatomic) IBOutlet UILabel *lbPleaseSignIn;

- (IBAction)tapCheckBox:(id)sender;
- (IBAction)tapForgotPassword:(id)sender;
- (IBAction)tapSignIn:(id)sender;

@end
