//
//  MenuHomeViewController.m
//  ShopManager
//
//  Created by Steven on 3/15/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "MenuHomeViewController.h"
#import "MyOrderViewController.h"
#import "ListCameraViewController.h"
#import "AddPushNotificationViewController.h"

@interface MenuHomeViewController ()

@end

@implementation MenuHomeViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
//    self.navigationController.navigationItem.title = NSLocalizedString(@"menuViewController.title", Nil);
    
    if (![[DeviceClass instance] getDevice] == IPHONE_5) {
        _lbUsername.frame = CGRectMake(_lbUsername.frame.origin.x, _lbUsername.frame.origin.y-85, _lbUsername.frame.size.width, _lbUsername.frame.size.height);
        _btnLogout.frame = CGRectMake(_btnLogout.frame.origin.x, _btnLogout.frame.origin.y-85, _btnLogout.frame.size.width, _btnLogout.frame.size.height);
    }
    
    _lbUsername.text = [_userDict objectForKey:@"user_login"];
    _lbOrderReceipt.text = NSLocalizedString(@"menuViewController.order-receipt", Nil);
    _lbCamera.text = NSLocalizedString(@"menuViewController.camera", Nil);
    _lbPushNotification.text = NSLocalizedString(@"menuViewController.push-notification", Nil);
    
    //get banner attachment
    NSDictionary *accountDict = [[AppDelegate instance] getAccountDict];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@:5984/business/%@/logo.png",[[AppDelegate instance] getMainURL],[accountDict objectForKey:@"_id"]];
    [_bannerImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)tapOrderReceipt:(id)sender {
    MyOrderViewController *controller = [MyOrderViewController alloc];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tapCamera:(id)sender {
    ListCameraViewController *controller = [[ListCameraViewController alloc] initWithNibName:@"ListCameraViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tapPushNotification:(id)sender {
    AddPushNotificationViewController *controller = [[AddPushNotificationViewController alloc] initWithNibName:@"AddPushNotificationViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)logoutAction:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"logout.title", nil) message:NSLocalizedString(@"logout.message", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"general.no", nil),NSLocalizedString(@"general.yes", nil), nil];
    [dialog show];
}

#pragma mark UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
