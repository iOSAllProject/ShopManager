//
//  AddPushNotificationViewController.m
//  ShopManager
//
//  Created by Steven on 3/28/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "AddPushNotificationViewController.h"
#import "BrowseViewController.h"

#define MAX_CHARACTER 200

@interface AddPushNotificationViewController ()

@end

@implementation AddPushNotificationViewController
@synthesize currentProductInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = NSLocalizedString(@"menuViewController.push-notification", Nil);
    // Do any additional setup after loading the view from its nib.
    _lbCustomerTitle.text = NSLocalizedString(@"addPushNotificationViewController.lb-customer-title", nil);
    _lbMessageTitle.text  = NSLocalizedString(@"addPushNotificationViewController.lb-message-title", nil);
    _lbNotMoreCharacter.text = NSLocalizedString(@"addPushNotificationViewController.lb-more-title", nil);
    [_btnSelectItem setTitle:NSLocalizedString(@"addPushNotificationViewController.btn-select-item", nil) forState:UIControlStateNormal];
    [_btnPushMessage setTitle:NSLocalizedString(@"addPushNotificationViewController.btn-push-message", nil) forState:UIControlStateNormal];
    
    _txtMessage.text = @"";
    _txtMessage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _txtMessage.layer.borderWidth = 1.0;
    
    //set background for Select Item button
    _btnSelectItem.layer.cornerRadius = 5;
    _btnSelectItem.contentMode=UIViewContentModeScaleAspectFill;
    _btnSelectItem.clipsToBounds=YES;
    
    [_btnSelectItem setBackgroundImage:[AppDelegate imageFromColor:APPLE_BLUE_COLOR] forState:UIControlStateNormal];
    [_btnSelectItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_btnSelectItem setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateHighlighted];
    
    //set background for Push Message button
    _btnPushMessage.layer.cornerRadius = 5;
    _btnPushMessage.contentMode=UIViewContentModeScaleAspectFill;
    _btnPushMessage.clipsToBounds=YES;
    
    [_btnPushMessage setBackgroundImage:[AppDelegate imageFromColor:APPLE_BLUE_COLOR] forState:UIControlStateNormal];
    [_btnPushMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_btnPushMessage setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    [_mainScrollView setContentSize:CGSizeMake(320, 568)];
    
    _lbNumberCharacter.text = [NSString stringWithFormat:@"%d",MAX_CHARACTER];
    
    [self getTotalSubscriber];
}

- (void) getTotalSubscriber {
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.getTotalSubscriber", NULL);
    dispatch_async(queue, ^(void) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-all-subscribers",[[AppDelegate instance] getDatabaseURL]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request startSynchronous];
        NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                NSString *responseStr = [request responseString];
                NSMutableArray *allSubscriber = [[responseStr JSONValue] objectForKey:@"all_subscribers"];
                if (allSubscriber != nil) {
                    _lbNumberCustomer.text = [NSString stringWithFormat:@"%d",[allSubscriber count]];
                }
            }
        });
    });
}

- (void) viewWillAppear:(BOOL)animated {
    if (currentProductInfo != nil) {
        NSLog(@"product Info = %@",currentProductInfo);
//        NSString *productId = [currentProductInfo objectForKey:@"product_ID"];
        NSDictionary *generalDict = [currentProductInfo objectForKey:@"general"];
        [_btnSelectItem setTitle:[generalDict objectForKey:@"title"] forState:UIControlStateNormal];
    }
}

- (void) handleSingleTap:(UITapGestureRecognizer*)gesture {
    [_txtMessage resignFirstResponder];
}

- (IBAction)selectItem:(id)sender {
    BrowseViewController *controller = [[BrowseViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)pushMessageAction:(id)sender {
    if ([_txtMessage.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addPushNotificationViewController.message-empty", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.pushMessage", NULL);
    dispatch_async(queue, ^(void) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=send-push-notification",[[AppDelegate instance] getDatabaseURL]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        request.requestMethod = @"POST";
        [request addPostValue:_txtMessage.text forKey:@"message"];
        [request addPostValue:[currentProductInfo objectForKey:@"product_ID"] forKey:@"product_id"];
        
        request.timeOutSeconds = 30;
        [request startSynchronous];

        NSError *error = [request error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                NSString *responseStr = [request responseString];
                responseStr = [responseStr stringByReplacingOccurrencesOfString:@"null" withString:@""];
                NSDictionary *responseDict = [responseStr JSONValue];
                NSLog(@"responseDict = %@",responseDict);
                if ([[responseDict objectForKey:@"total_user_left"] intValue] == 0) {
                    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.success", Nil) message:NSLocalizedString(@"addPushNotificationViewController.push-notification-success", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
                    [dialog show];
                }
            }
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    if(![text isEqualToString:@""]){
        if (textView.text.length > MAX_CHARACTER) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addPushNotificationViewController.exceed-characters", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
            [dialog show];
            return FALSE;
        }
    }
    int numberCharacterLeft = MAX_CHARACTER-textView.text.length;
    if (numberCharacterLeft < 0)
        numberCharacterLeft = 0;
    _lbNumberCharacter.text = [NSString stringWithFormat:@"%d",numberCharacterLeft];
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


@end
