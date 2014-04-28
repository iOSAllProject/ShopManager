//
//  OrderViewController.m
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/13/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import "OrderViewController.h"
#import "MyOrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController
@synthesize parent;

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    NSLog(@"dealloc %@",self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setNuiClass:@"ViewInit"];
    
//    self.title = NSLocalizedString(@"order_title_label", nil);
    
    scroller = [[MGScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scroller.bottomPadding = 8;
    scroller.contentLayoutMode = MGLayoutGridStyle;
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    if(noCloseBtn == YES)
    {
    }
    else
    {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
        closeBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [closeBtn setTitle:NSLocalizedString(@"order_close_btn", nil) forState:UIControlStateNormal];
        [closeBtn addTarget:self
                     action:@selector(closeBtnExe)
           forControlEvents:UIControlEventTouchDown];
        
        [closeBtn setNuiClass:@"UiBarButtonItem"];
        [closeBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]
                                   initWithCustomView:closeBtn];
        self.navigationItem.leftBarButtonItem = button;
    }
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    payBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [payBtn setTitle:NSLocalizedString(@"order_pay_btn", nil) forState:UIControlStateNormal];
    [payBtn addTarget:self
               action:@selector(payBtnExe)
     forControlEvents:UIControlEventTouchDown];
    
    [payBtn setNuiClass:@"UiBarButtonItem"];
    [payBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    payBtnItem = [[UIBarButtonItem alloc]
                  initWithCustomView:payBtn];
    
    orderNotes = [UIButton buttonWithType:UIButtonTypeCustom];
    orderNotes.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    [orderNotes setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateNormal];
    orderNotes.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [orderNotes setTitle:NSLocalizedString(@"orderViewController_order_notes_btn_title", nil) forState:UIControlStateNormal];
    [orderNotes addTarget:self
                   action:@selector(notesAction)
         forControlEvents:UIControlEventTouchDown];
    
    [orderNotes setNuiClass:@"UiBarButtonItem"];
//    [orderNotes.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    orderNotesBtnItems = [[UIBarButtonItem alloc] initWithCustomView:orderNotes];
    
    //create Save button
//    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnSave.frame = CGRectMake(10, self.view.frame.size.height-40, 300, 30);
//    [btnSave setTitle:NSLocalizedString(@"orderViewController.save", nil) forState:UIControlStateNormal];
//    btnSave.layer.cornerRadius = 5;
//    btnSave.contentMode=UIViewContentModeScaleAspectFill;
//    btnSave.clipsToBounds=YES;
//    
//    [btnSave setBackgroundImage:[AppDelegate imageFromColor:APPLE_BLUE_COLOR] forState:UIControlStateNormal];
//    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    [btnSave setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateHighlighted];
//    [btnSave addTarget:self action:@selector(updateOrder) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnSave];
}

- (void) updateOrder {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.update-order", NULL);
    dispatch_async(queue, ^(void) {
        NSString *newOrderStatus = @"pending";
        
        for (MGBox *section in scroller.boxes) {
            if (section.tag == kStatusTag) {
                MGBox *box = [section.boxes objectAtIndex:0];
                UILabel *lbStatus = (UILabel*)[box viewWithTag:kStatusTag];
                
                if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.all", nil)])
                    newOrderStatus = @"All";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.pending", nil)])
                    newOrderStatus = @"pending";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.failed", nil)])
                    newOrderStatus = @"failed";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.on-hold", nil)])
                    newOrderStatus = @"on-hold";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.processing", nil)])
                    newOrderStatus = @"processing";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.completed", nil)])
                    newOrderStatus = @"completed";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.refunded", nil)])
                    newOrderStatus = @"refunded";
                else if ([lbStatus.text isEqualToString:NSLocalizedString(@"status_list.cancelled", nil)])
                    newOrderStatus = @"cancelled";
                break;
            }
        }
        
        NSDictionary *orderDict = [[MyOrderClass instance] getMyOrder];

        //update status for order
        NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=update-order-status",[[AppDelegate instance] getDatabaseURL]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        request.requestMethod = @"POST";
        [request addPostValue:[orderDict objectForKey:@"orderID"] forKey:@"order_id"];
        [request addPostValue:newOrderStatus forKey:@"order_status"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                NSString *response = [request responseString];
                NSDictionary *result = [response JSONValue];
                if ([[result objectForKey:@"success"] boolValue]) {
                    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.success", nil) message:NSLocalizedString(@"orderViewController.update-status-successful", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
                    [dialog show];
                    
                    [(MyOrderViewController*)parent listOrder];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.fail", nil) message:NSLocalizedString(@"orderViewController.update-status-fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
                    [dialog show];
                }
                
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            }
        });
    });
}

-(void)notesAction
{
    OrderNotesViewController *notes = [[OrderNotesViewController alloc] init];
    [self.navigationController pushViewController:notes animated:YES];
}


-(void)noCloseBtn{
    noCloseBtn = YES;
}

-(void)closeBtnExe{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
//        [[[MainViewClass instance] cartNav] popToRootViewControllerAnimated:YES];
    }];
}

-(void)payBtnExe{
    
//    PaymentWebViewController *payment = [[PaymentWebViewController alloc] init];
//    [payment setOrderViewController:self];
//    UINavigationController *paymentNav = [[UINavigationController alloc] initWithRootViewController:payment];
//    [payment loadUrlInWebView:[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-api&orderKey=%@&orderID=%@&paymentMethodID=%@",[[AppDelegate instance] getDatabaseURL],
//                               [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"],
//                               [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
//                               [[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]
//                               ]];
//    [self presentViewController:paymentNav animated:YES completion:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [self viewCompile];
    [self.view setNeedsDisplay];
}


-(void)viewCompile{
    
    [scroller.boxes removeAllObjects];
    [payBtn removeFromSuperview];
    
    NSDictionary *status = [[MyOrderClass instance] getMyOrder];
    
    [self date:[status objectForKey:@"orderDate"]];
    [self setPaymentMethod];
    if([[status objectForKey:@"status"] isEqualToString:@"on-hold"])
    {
        NSString *paymentDesc;
        if ([[status objectForKey:@"payment_desc"] isKindOfClass:[NSNull class]])
            paymentDesc = @"";
        else
            paymentDesc = [status objectForKey:@"payment_desc"];
//        [self shortDesc:[status objectForKey:@"payment_desc"]];
        [self shortDesc:paymentDesc];
    }
    [self lblBox:NSLocalizedString(@"order_id_label", nil) value:[NSString stringWithFormat:@"#%@",[status objectForKey:@"orderID"]]];
    
    //change language for status
    NSString *statusStr = [status objectForKey:@"status"];
    if ([statusStr isEqualToString:@"All"])
        statusStr = NSLocalizedString(@"status_list.all", nil);
    else if ([statusStr isEqualToString:@"pending"])
        statusStr = NSLocalizedString(@"status_list.pending", nil);
    else if ([statusStr isEqualToString:@"failed"])
        statusStr = NSLocalizedString(@"status_list.failed", nil);
    else if ([statusStr isEqualToString:@"on-hold"])
        statusStr = NSLocalizedString(@"status_list.on-hold", nil);
    else if ([statusStr isEqualToString:@"processing"])
        statusStr = NSLocalizedString(@"status_list.processing", nil);
    else if ([statusStr isEqualToString:@"completed"])
        statusStr = NSLocalizedString(@"status_list.completed", nil);
    else if ([statusStr isEqualToString:@"refunded"])
        statusStr = NSLocalizedString(@"status_list.refunded", nil);
    else if ([statusStr isEqualToString:@"cancelled"])
        statusStr = NSLocalizedString(@"status_list.cancelled", nil);
    
    [self lblBox:NSLocalizedString(@"order_status_label", nil) value:statusStr tag:kStatusTag];
    
    [self lblBox:NSLocalizedString(@"order_email_label", nil) value:[status objectForKey:@"billing_email"]];
    [self lblBox:NSLocalizedString(@"order_phone_label", nil) value:[status objectForKey:@"billing_phone"]];
    [self lblBoxAddress:NSLocalizedString(@"order_billing_address_label", nil) value:[NSString stringWithFormat:@"%@",[status objectForKey:@"billing_address"]]];
    [self lblBoxAddress:NSLocalizedString(@"order_shipping_address_label", nil) value:[NSString stringWithFormat:@"%@",[status objectForKey:@"shipping_address"]]];
    
    NSString *orderNotess = [NSString stringWithFormat:@"%@",[status objectForKey:@"order_note"]];
    if([orderNotess length] > 0)
    {
        [self shortDesc:orderNotess];
    }
    
    [self setCartItemView];
    [self totalBox];
    [self totalPrice];
    
    //add label Update
    [self btnButton:NSLocalizedString(@"orderViewController.btn-update-title", nil) selector:@selector(updateOrder)];
    
    [scroller layoutWithSpeed:VIEW_COMPILE_SPEED completion:nil];
    
    if([[status objectForKey:@"status"] isEqualToString:@"pending"] || [[status objectForKey:@"status"] isEqualToString:@"failed"])
    {
        
        //self.navigationItem.rightBarButtonItem = payBtnItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = orderNotesBtnItems;
    }
}

-(void)lblBoxAddress:(NSString*)lbl value:(NSString*)value{
    
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox halfAddressBox:CGSizeMake(145, 150) lbl:lbl value:value];
    
    [section.boxes addObject:box];
}

-(void)lblBox:(NSString*)lbl value:(NSString*)value{
    
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox halfBox:CGSizeMake(145, 50) lbl:lbl value:value];
    [section.boxes addObject:box];
}

-(void)lblBox:(NSString*)lbl value:(NSString*)value tag:(int)_tag {
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    section.tag = _tag;
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox halfBox:CGSizeMake(145, 50) lbl:lbl value:value tag:_tag];
    [section.boxes addObject:box];
    
    if (_tag == kStatusTag) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(110, 10, 25, 25);
        [btn addTarget:self action:@selector(displayOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
        [box addSubview:btn];
    }
}

- (void) btnButton:(NSString*)title selector:(SEL)selector {
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox boxWithSize:CGSizeMake(290, 25)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, box.size.width, box.size.height);
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [box addSubview:btn];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[AppDelegate imageFromColor:APPLE_BLUE_COLOR] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateHighlighted];
    
    [section.boxes addObject:box];
}

- (void) displayOrderStatus:(UIButton*)sender {
    GeneralPopTableView *genral = [[GeneralPopTableView alloc] init];
    genral.delegate = self;
    
    NSMutableArray *statusArray = [[[[SettingDataClass instance] getSetting] objectForKey:@"status_list"] mutableCopy];
    [statusArray removeObjectAtIndex:0];
    
    [genral initGeneralPopTableView:@"status_label" detailList:nil menuItem:statusArray];
    
    popover = [[FPPopoverController alloc] initWithViewController:genral];
    popover.border = YES;
    popover.contentSize = CGSizeMake(170,240);
    [popover presentPopoverFromView:sender];
}

-(void)didChooseGeneralPopTableView:(NSDictionary*)data {
    [popover dismissPopoverAnimated:YES];
    
    for (MGBox *section in scroller.boxes) {
        if (section.tag == kStatusTag) {
            MGBox *box = [section.boxes objectAtIndex:0];
            UILabel *lbStatus = (UILabel*)[box viewWithTag:kStatusTag];
            
            //change language for status
            NSString *statusStr = [data objectForKey:@"status_slug"];
            if ([statusStr isEqualToString:@"All"])
                statusStr = NSLocalizedString(@"status_list.all", nil);
            else if ([statusStr isEqualToString:@"pending"])
                statusStr = NSLocalizedString(@"status_list.pending", nil);
            else if ([statusStr isEqualToString:@"failed"])
                statusStr = NSLocalizedString(@"status_list.failed", nil);
            else if ([statusStr isEqualToString:@"on-hold"])
                statusStr = NSLocalizedString(@"status_list.on-hold", nil);
            else if ([statusStr isEqualToString:@"processing"])
                statusStr = NSLocalizedString(@"status_list.processing", nil);
            else if ([statusStr isEqualToString:@"completed"])
                statusStr = NSLocalizedString(@"status_list.completed", nil);
            else if ([statusStr isEqualToString:@"refunded"])
                statusStr = NSLocalizedString(@"status_list.refunded", nil);
            else if ([statusStr isEqualToString:@"cancelled"])
                statusStr = NSLocalizedString(@"status_list.cancelled", nil);
            
            lbStatus.text = statusStr;
            break;
        }
    }
}

-(void)setCartItemView{
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    
    NSArray *incart = [[[MyOrderClass instance] getMyOrder] objectForKey:@"items"];
    
    for(int i=0;i<[incart count];i++)
    {
        NSDictionary *product = [incart objectAtIndex:i];
        NSString *productPrice;
        NSString *totalPrice;
        BOOL hasTax;
        if([[order objectForKey:@"tax_total"] floatValue] > 0)
        {
            if([[order objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
            {
                productPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"product_price"] floatValue]];
                
                totalPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"total_price"] floatValue]];
                hasTax = NO;
            }
            else
            {
                productPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"product_price_ex_tax"] floatValue]];
                
                totalPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"total_price_ex_tax"] floatValue]];
                hasTax = YES;
                
            }
        }
        else
        {
            productPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"product_price"] floatValue]];
            totalPrice = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"total_price"] floatValue]];
            hasTax = NO;
        }
        [self
         cartItem:[[product objectForKey:@"product_info"] objectForKey:@"featuredImages"]
         productTitle:[[product objectForKey:@"product_info"] objectForKey:@"productName"]
         currency: [[SettingDataClass instance] getCurrencySymbol]
         price:productPrice
         quantity:[product objectForKey:@"quantity"]
         totalPrice:totalPrice
         has_tax:hasTax
         productID:[product objectForKey:@"product_id"]
         ];
        
        
        
        
    }
    
    NSArray *couponArray = [[[MyOrderClass instance] getMyOrder] objectForKey:@"used_coupon"];
    
    for(int i=0;i<[couponArray count];i++)
    {
        NSString *ser = [NSString stringWithFormat:@"%@",[couponArray objectAtIndex:i]] ;
        
        [self coupon:[NSString stringWithFormat:@"%@",ser]];
    }
}


-(void)totalBox{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    MGLineStyled *cutSubTotal;
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    BOOL hasTax;
    NSString *lineWithLeft;
    NSString *subtotal;
    
    NSString *currency =  [[SettingDataClass instance] getCurrencySymbol];
    
    if([[order objectForKey:@"tax_total"] floatValue] > 0)
    {
        if([[order objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
        {
            
            hasTax = NO;
            lineWithLeft = NSLocalizedString(@"checkout_label_subtotal", nil);
            subtotal = [order objectForKey:@"subtotalWithTax"];
        }
        else
        {
            
            hasTax = YES;
            lineWithLeft = NSLocalizedString(@"checkout_label_subtotal_without_tax", nil);
            subtotal = [order objectForKey:@"subtotalExTax"];
            
        }
    }
    else
    {
        
        hasTax = NO;
        lineWithLeft = NSLocalizedString(@"checkout_label_subtotal", nil);
        subtotal = [order objectForKey:@"subtotalWithTax"];
    }
    
    
    cutSubTotal = [MGLineStyled lineWithLeft:lineWithLeft
                   right:[NSString stringWithFormat:@"%@ %@",currency,[AppDelegate convertToThousandSeparator:[NSString stringWithFormat:@"%f",[subtotal floatValue]]]] size:CGSizeMake(300, 29)];
//                                       right:[NSString stringWithFormat:@"%@ %.2f",currency,[subtotal floatValue]] size:CGSizeMake(300, 29)];
    
    
    cutSubTotal.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:cutSubTotal];
    
    
    MGLineStyled
    *shipping = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_shipping_method_and_cost", nil)]
                 right:[NSString stringWithFormat:@"%@ : %@ %@",[order objectForKey:@"shipping_method"],currency,[AppDelegate convertToThousandSeparator:[NSString stringWithFormat:@"%f",[[order objectForKey:@"shipping_cost"] floatValue]]]] size:CGSizeMake(300, 29)];
//                                     right:[NSString stringWithFormat:@"%@ : %@ %.2f",[order objectForKey:@"shipping_method"],currency,[[order objectForKey:@"shipping_cost"] floatValue]] size:CGSizeMake(300, 29)];
    shipping.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:shipping];
    
    
    if(hasTax == YES)
    {
        float price = [[order objectForKey:@"tax_total"] floatValue];
        MGLineStyled *tax;
        tax = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_tax", nil)]
//                                   right:[NSString stringWithFormat:@"%@ %.2f",currency,price] size:CGSizeMake(300, 29)];
               right:[NSString stringWithFormat:@"%@ %@",currency,[AppDelegate convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]] size:CGSizeMake(300, 29)];
        tax.font = [UIFont fontWithName:PRIMARYFONT size:12];
        [section.topLines addObject:tax];
    }
    
    float price = [[order objectForKey:@"discount_total"] floatValue];
    if(price != 0)
    {
        MGLineStyled *discount;
        discount = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",NSLocalizedString(@"checkout_label_discount", nil)]
//                                        right:[NSString stringWithFormat:@"- %@ %.2f",currency,price] size:CGSizeMake(300, 29)];
                    right:[NSString stringWithFormat:@"- %@ %@",currency,[AppDelegate convertToThousandSeparator:[NSString stringWithFormat:@"%f",price]]] size:CGSizeMake(300, 29)];
        discount.font = [UIFont fontWithName:PRIMARYFONT size:12];
        [section.topLines addObject:discount];
    }
}

-(void)date:(NSString*)date{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    MyCartBox *box;
    
    box = [MyCartBox date:NSLocalizedString(@"order_date_label", nil) date:date];
    [section.topLines addObject:box];
}




-(void)totalPrice{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    MyCartBox *box;
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    
    NSString *currency =  [[SettingDataClass instance] getCurrencySymbol];
    
    if([[order objectForKey:@"tax_total"] floatValue] > 0)
    {
        if([[order objectForKey:@"display-price-during-cart-checkout"] isEqualToString:@"incl"])
        {
            
            box = [MyCartBox totalPrice:NSLocalizedString(@"checkout_label_grand_total", nil) currency:currency totalPrice:[[order objectForKey:@"order_total"] floatValue] include_tax:YES tax:[NSString stringWithFormat:@"%@ %@ %.2f %@",NSLocalizedString(@"checkout_label_grand_total_with_include_tax_below_1", nil),currency,[[order objectForKey:@"tax_total"] floatValue],NSLocalizedString(@"checkout_label_grand_total_with_include_tax_below_2", nil)]];
            
        }
        else
        {
            box = [MyCartBox preTotal:NSLocalizedString(@"checkout_label_grand_total", nil) currency:currency totalPrice:[[order objectForKey:@"order_total"] floatValue]];
        }
    }
    else
    {
        box = [MyCartBox preTotal:NSLocalizedString(@"checkout_label_grand_total", nil) currency:currency totalPrice:[[order objectForKey:@"order_total"] floatValue]];
        
    }
    
    [section.topLines addObject:box];
    
}


-(void)setPaymentMethod{
    
    // NSDictionary *reviewData = [[MyCartClass instance] getServerCart];
    
    //NSArray *paymentMethod = [reviewData objectForKey:@"payment-method"];
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    
    MyCartBox *box = [MyCartBox paymentMethodNoArrow:CGSizeMake(300, 34)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, box.size.width, box.size.height)];
    
    [lbl setNuiClass:@"inventory"];
    
    NSDictionary *order = [[MyOrderClass instance] getMyOrder];
    
    
    lbl.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"order_label_payment_method", nil),[order objectForKey:@"payment_method_title"]];
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:lbl];

    [section.topLines addObject:box];
}

-(void)shortDesc:(NSString*)desc
{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    id body = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:desc]];
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
    line.backgroundColor = [UIColor clearColor];
    line.font = [UIFont fontWithName:PRIMARYFONT size:11];
    [section.topLines addObject:line];
}

-(void)cartItem:(NSString*)featuredImage productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)price quantity:(NSString*)quantity totalPrice:(NSString*)totalPrice has_tax:(BOOL)has_tax productID:(NSString*)productID{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox cartItemServer:featuredImage productTitle:title currency:currency price:price quantity:quantity totalPrice:totalPrice has_tax:has_tax];
    
    [section.topLines addObject:box];
    
}

-(void)coupon:(NSString*)couponCode{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox coupon:NSLocalizedString(@"checkout_label_coupon", nil) couponCode:couponCode];
    
    [section.topLines addObject:box];
    
    UIImageView *deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"image_delete_icon", nil)]];
    deleteIcon.frame = CGRectMake(277, 5, 20, 20);
    deleteIcon.hidden = YES;
    deleteIcon.userInteractionEnabled = YES;
    [section addSubview:deleteIcon];
    
//    UserDataTapGestureRecognizer *singleTap = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCouponExe:)];
//    singleTap.userData = couponCode;
//    [deleteIcon addGestureRecognizer:singleTap];

}

-(void)succsessfulMsg:(NSString*)msg{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    MyCartBox *box = [MyCartBox coupon:msg couponCode:@""];
    
    [section.topLines addObject:box];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    initialContentOffset = scrollViews.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    [[SettingDataClass instance] autoHideGlobal:scrollViews navigationView:self.navigationController contentOffset:initialContentOffset];
}


-(void)refreshOrderPaymentSuccessful{
    NSLog(@"Successful");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(refreshOrderPaymentSuccessfulExe) onTarget:self withObject:nil animated:YES];
    
}

-(void)refreshOrderFailed{
    NSLog(@"Failed");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(refreshOrderFailedExe) onTarget:self withObject:nil animated:YES];
}

- (NSDictionary*) get_single_order:(NSString*)_orderID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *decryptedUsername = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:USERNAME]];
    NSString *decryptedPassword = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:PASSWORD]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-order",[[AppDelegate instance] getDatabaseURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.requestMethod = @"POST";
    [request addPostValue:decryptedUsername forKey:@"username"];
    [request addPostValue:decryptedPassword forKey:@"password"];
    [request addPostValue:_orderID forKey:@"orderID"];
    
    [request startSynchronous];
    
    NSDictionary *orderDict;
    
    NSError *error = [request error];
    if (!error) {
        NSString *responseStr = [request responseString];
        orderDict = [responseStr JSONValue];
    }
    
    return orderDict;
}

-(void)refreshOrderFailedExe{
    NSDictionary *statusTemp = [[MyOrderClass instance] getMyOrder];
    NSDictionary *newData = [self get_single_order:[NSString stringWithFormat:@"%@",[statusTemp objectForKey:@"orderID"]]];
    
    [[MyOrderClass instance] setMyOrder:newData];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self viewCompile];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"order_fail_payment", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                              ,nil];
        [alert show];
        
    });
}


-(void)refreshOrderPaymentSuccessfulExe{
    NSDictionary *statusTemp = [[MyOrderClass instance] getMyOrder];
    NSDictionary *newData = [self get_single_order:[NSString stringWithFormat:@"%@",[statusTemp objectForKey:@"orderID"]]];
    
    [[MyOrderClass instance] setMyOrder:newData];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self viewCompile];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"order_successful_payment", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                              ,nil];
        [alert show];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
