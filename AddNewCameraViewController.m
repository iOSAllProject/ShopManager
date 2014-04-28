//
//  AddNewCameraViewController.m
//  ShopManager
//
//  Created by Steven on 3/23/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "AddNewCameraViewController.h"
#import "ListCameraViewController.h"

@interface AddNewCameraViewController ()

@end

@implementation AddNewCameraViewController
@synthesize parent;
@synthesize isEdit;
@synthesize cameraDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(id)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        parent = _parent;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lbCameraName.text  = NSLocalizedString(@"addNewCameraVC.lb-camera-title", nil);
    _lbDomain.text      = NSLocalizedString(@"addNewCameraVC.lb-domain-title", nil);
    _lbChannel.text     = NSLocalizedString(@"addNewCameraVC.lb-channel-title", nil);
    _lbUsername.text    = NSLocalizedString(@"addNewCameraVC.lb-username-title", nil);
    _lbPassword.text    = NSLocalizedString(@"addNewCameraVC.lb-password-title", nil);
    _txtCameraName.placeholder  = NSLocalizedString(@"addNewCameraVC.txt-camera-name", nil);
    _txtDomain.placeholder      = NSLocalizedString(@"addNewCameraVC.txt-domain", nil);
    _txtUsername.placeholder    = NSLocalizedString(@"addNewCameraVC.txt-username", nil);
    _txtPassword.placeholder    = NSLocalizedString(@"addNewCameraVC.txt-password", nil);
    
    _txtChannel.text = @"1";
    _lbPublish.text  = NSLocalizedString(@"addNewCameraVC.public-camera", nil);
    
    [_mainSwitch setNuiIsApplied:@0];
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"addNewCameraVC.btn-save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveCamera)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    if (isEdit) {
        _txtCameraName.text  = [cameraDict objectForKey:@"cameraName"];
        _txtDomain.text      = [cameraDict objectForKey:@"domain"];
        _txtUsername.text    = [cameraDict objectForKey:@"username"];
        _txtPassword.text    = [cameraDict objectForKey:@"password"];
        
        _txtChannel.text = @"1";
        
        _mainSwitch.on = [[cameraDict objectForKey:@"isCameraPublic"] boolValue];
    }
}

- (void) saveCamera {
    if (_txtCameraName.text == nil || [_txtCameraName.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addNewCameraVC.required-camera-name", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if (_txtDomain.text == nil || [_txtDomain.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addNewCameraVC.required-domain", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if (_txtChannel.text == nil || [_txtChannel.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addNewCameraVC.required-channel", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (!isEdit) {
        NSMutableDictionary *tmpCameraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_txtCameraName.text,@"cameraName",_txtDomain.text,@"domain",_txtChannel.text,@"channel",_txtUsername.text,@"username",_txtPassword.text,@"password",[NSNumber numberWithInt:_mainSwitch.on],@"isCameraPublic", nil];
        [[(ListCameraViewController*)parent mainArray] addObject:tmpCameraDict];
    }
    else {
        [cameraDict setObject:_txtCameraName.text forKey:@"cameraName"];
        [cameraDict setObject:_txtDomain.text forKey:@"domain"];
        [cameraDict setObject:_txtChannel.text forKey:@"channel"];
        [cameraDict setObject:_txtUsername.text forKey:@"username"];
        [cameraDict setObject:_txtPassword.text forKey:@"password"];
        [cameraDict setObject:[NSNumber numberWithInt:_mainSwitch.on] forKey:@"isCameraPublic"];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[(ListCameraViewController*)parent mainArray] forKey:CAMERA_LIST];
    
    //save camera list to server
    //get database URL of user by email or username
    NSString *decryptedUsername = [[AppDelegate instance] getDecryptedData:[[AppDelegate instance] getUsernameAuthorizeCouchDB]];
    NSString *decryptedPassword = [[AppDelegate instance] getDecryptedData:[[AppDelegate instance] getPasswordAuthorizeCouchDB]];

    NSString *urlStr = [NSString stringWithFormat:@"%@:3001/set_camera",[[AppDelegate instance] getMainURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.requestMethod = @"POST";
    request.username = decryptedUsername;
    request.password = decryptedPassword;

    NSString *cameraListData = [[(ListCameraViewController*)parent mainArray] JSONRepresentation];
    
    [request addPostValue:[[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:USERNAME]] forKey:@"user"];
    [request addPostValue:cameraListData forKey:@"camera"];

    [request startAsynchronous];
    NSError *error = [request error];
    if (!error) {

    }
    
    [[(ListCameraViewController*)parent tableView] reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
