//
//  LoginViewController.m
//  ShopManager
//
//  Created by Steven on 3/15/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuHomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    _btnForgotPassword.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    dictLanguage = [delegate.arrayLanguage objectAtIndex:0];
    
    //set title by language key for labels and button
//    _txtUsername.placeholder = NSLocalizedString(@"login.username", nil);
//    _txtPassword.placeholder = NSLocalizedString(@"login.password", nil);
    _lbRememberMe.text  = NSLocalizedString(@"login.remember", nil);
    [_btnForgotPassword setTitle:NSLocalizedString(@"login.forgot-password", nil) forState:UIControlStateNormal];
    [_btnSignIn setTitle:NSLocalizedString(@"login.sign-in", nil) forState:UIControlStateNormal];
    
    UIColor *color = [UIColor lightTextColor];
    _txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"login.username", nil) attributes:@{NSForegroundColorAttributeName: color}];
    _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"login.password", nil) attributes:@{NSForegroundColorAttributeName: color}];
    
    //set border for text field
    _txtUsername.textColor = [UIColor whiteColor];
    _txtUsername.backgroundColor   = [UIColor blackColor];
    _txtUsername.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtUsername.layer.borderWidth = 0.5;
    _txtUsername.layer.cornerRadius = 3;
    
    _txtPassword.textColor = [UIColor whiteColor];
    _txtPassword.backgroundColor   = [UIColor blackColor];
    _txtPassword.layer.borderColor = [UIColor whiteColor].CGColor;
    _txtPassword.layer.borderWidth = 0.5;
    _txtPassword.layer.cornerRadius = 3;
    
    [_txtUsername setNuiIsApplied:@0];
    [_txtPassword setNuiIsApplied:@0];
    
    UIImageView *imgLockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lock.png"]];
    
    [_txtPassword setRightViewMode:UITextFieldViewModeAlways];
    _txtPassword.rightView = imgLockView;
    
    //set background for Sign in button
    _btnSignIn.layer.cornerRadius = 5;
    _btnSignIn.contentMode=UIViewContentModeScaleAspectFill;
    _btnSignIn.clipsToBounds=YES;
    [_btnSignIn setNuiIsApplied:@0];
    
    [_btnSignIn setBackgroundImage:[AppDelegate imageFromColor:APPLE_BLUE_COLOR] forState:UIControlStateNormal];
    [_btnSignIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_btnSignIn setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateHighlighted];
    
    _lbWelcome.text = NSLocalizedString(@"login.lb-welcome", nil);
    _lbPleaseSignIn.text = NSLocalizedString(@"login.lb-please-sign-in", nil);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    //check remember me
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isRemember = [[userDefaults objectForKey:IS_REMEMBER] boolValue];
    
    if (isRemember) {
        [_btnCheckBox setSelected:isRemember];
        _txtUsername.text = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:USERNAME]];
        _txtPassword.text = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:PASSWORD]];
    }
    
    //disable NUI
    [_lbWelcome setNuiIsApplied:@0];
    [_lbPleaseSignIn setNuiIsApplied:@0];
    [_lbRememberMe setNuiIsApplied:@0];
}

- (IBAction)tapCheckBox:(id)sender {
    [_btnCheckBox setSelected:!_btnCheckBox.isSelected];
}

- (IBAction)tapForgotPassword:(id)sender {
    
}

- (void) getSetting {
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-settings",[[AppDelegate instance] getDatabaseURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *settings = [rawJson JSONValue];
    
    [[SettingDataClass instance] setSetting:settings];
}

-(NSDictionary*)user_login:(NSString*)username password:(NSString*)password{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&deviceID=%@",username,password,[[DeviceClass instance] getUUID]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-login",[[AppDelegate instance] getDatabaseURL]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *user_data = [rawJson JSONValue];
    NSLog(@"User Dtaa : %@",user_data);
    return user_data;
}

- (IBAction)tapSignIn:(id)sender {
    //check validate for inputting username
    if (_txtUsername.text == nil || [_txtUsername.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"login.username.blank", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
//    NSString *emailRegexString	= @"^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
//    if (![_txtUsername.text isMatchedByRegex:emailRegexString]) {
//        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:[dictLanguage objectForKey:@"general.warning"] message:[dictLanguage objectForKey:@"login.username.wrong-format"] delegate:nil cancelButtonTitle:[dictLanguage objectForKey:@"general.ok"] otherButtonTitles:nil];
//        [dialog show];
//        return;
//    }
    
    //check validate for inputting password
    if (_txtPassword.text == nil || [_txtPassword.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"login.password.blank", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    //get Database URL of user
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(getDatabaseURLByUser:) withObject:_txtUsername.text afterDelay:0.5];
}


- (void) getDatabaseURLByUser:(NSString*)_username {
    //get database URL of user by email or username
    NSString *decryptedUsername = [[AppDelegate instance] getDecryptedData:[[AppDelegate instance] getUsernameAuthorizeCouchDB]];
    NSString *decryptedPassword = [[AppDelegate instance] getDecryptedData:[[AppDelegate instance] getPasswordAuthorizeCouchDB]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:3001/get_user",[[AppDelegate instance] getMainURL]];
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.28:3001/get_user"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.requestMethod = @"POST";
    request.username = decryptedUsername;
    request.password = decryptedPassword;
    
    [request addPostValue:_txtUsername.text forKey:@"username"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        
        NSMutableDictionary *dict = [response JSONValue];
        
        //check status of this user
        BOOL status = [[dict objectForKey:@"status"] boolValue];
        
        if (status) {
            NSString *databaseUrl = [dict objectForKey:@"databaseUrl"];
            
            [[AppDelegate instance] setAccountDict:dict];
            [[AppDelegate instance] setDatabaseURL:databaseUrl];
            
            dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.login", NULL);
            dispatch_async(queue,^(void) {
                NSDictionary * user_data = [self user_login:_txtUsername.text password:_txtPassword.text];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if([[user_data objectForKey:@"status"] intValue] == 0)
                    {
                        //save user
                        NSString *encryptedUsername = [[AppDelegate instance] encryptData:_txtUsername.text];
                        NSString *encryptedPassword = [[AppDelegate instance] encryptData:_txtPassword.text];
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:encryptedUsername forKey:USERNAME];
                        [userDefaults setObject:encryptedPassword forKey:PASSWORD];
                        [userDefaults synchronize];
                        
                        //save remember me status
                        [userDefaults setObject:[NSNumber numberWithBool:_btnCheckBox.isSelected] forKey:IS_REMEMBER];
                        
                        [[DataService instance] loadAllData];
                        
                        //successful logged
                        MenuHomeViewController *controller = [[MenuHomeViewController alloc] initWithNibName:@"MenuHomeViewController" bundle:nil];
                        controller.userDict = [user_data objectForKey:@"user"];
                        [self.navigationController pushViewController:controller animated:YES];
                        
                    }
                    else {
                        //failed
                        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.failed", nil) message:NSLocalizedString(@"login.wrong-username-or-password", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
                        [dialog show];
                    }
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                });
            });
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"login.user-not-existed", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
            [dialog show];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"login.user-not-existed", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

- (void) handleSingleTap:(UITapGestureRecognizer*)_gesture {
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
}

#pragma mark UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtUsername) {
        [_txtPassword becomeFirstResponder];
    }
    else {
        //process login
        [self tapSignIn:nil];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = APPLE_BLUE_COLOR.CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
