//
//  MyOrderViewController.m
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/18/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import "MyOrderViewController.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

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
    [self.view setNuiClass:@"ViewInit"];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = NSLocalizedString(@"orderViewController.title", nil) ;
	// Do any additional setup after loading the view.
    
    scroller = [MGScrollView scroller];
    
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
        
    scroller.bottomPadding = 8;
    
    scroller.delegate = self;
    scroller.alwaysBounceVertical = YES;
    
    [self.view addSubview:scroller];
    
    [self listOrder];
    
    btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFilter.frame = CGRectMake(self.view.frame.size.width - 69, 8, 100, 30);
    [btnFilter setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateNormal];

    btnFilter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [btnFilter setTitle:NSLocalizedString(@"orderViewController.filter_btn_title", nil) forState:UIControlStateNormal];
    [btnFilter addTarget:self
                 action:@selector(filterAction)
       forControlEvents:UIControlEventTouchDown];
    [btnFilter setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
    
    [btnFilter setNuiClass:@"UiBarButtonItem"];
//    [filter.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:btnFilter];
    
    
//    btnFilter = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"orderViewController.filter_btn_title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(filterAction)];

    self.navigationItem.rightBarButtonItem = button;
}

- (void) listOrder {
    //get list order
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.get-list-order", NULL);
    dispatch_async(queue, ^(void) {
        [self getListOfMyOrderByFilter:@"All"];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self setOrderView];
        });
    });
}

- (NSDictionary*) getListOfMyOrderByFilter:(NSString*)_filterType{
    NSDictionary *myOrderDict;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-all-order",[[AppDelegate instance] getDatabaseURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.requestMethod = @"POST";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *decryptedUsername = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:USERNAME]];
    NSString *decryptedPassword = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:PASSWORD]];
    NSString *filterType = _filterType;
    
//    request.username = decryptedUsername;
//    request.password = decryptedPassword;
    
    [request addPostValue:decryptedUsername forKey:@"username"];
    [request addPostValue:decryptedPassword forKey:@"password"];
    [request addPostValue:filterType forKey:@"filter"];
    
    [request startSynchronous];
    
    NSError *error;
    
    if (!error) {
        NSString *responseStr = [request responseString];
        myOrderDict = [responseStr JSONValue];
        
        [[MyOrderClass instance] setListOfMyOrder:myOrderDict];
    }
    
    return myOrderDict;
}


-(void)filterAction{
    GeneralPopTableView *genral = [[GeneralPopTableView alloc] init];
    genral.delegate = self;
    
    [genral initGeneralPopTableView:@"status_label" detailList:nil menuItem:[[[SettingDataClass instance] getSetting] objectForKey:@"status_list"]];
    
    popover = [[FPPopoverController alloc] initWithViewController:genral];
    popover.border = YES;
    popover.contentSize = CGSizeMake(170,240);
    [popover.view setNuiClass:@"DropDownView"];
    [popover presentPopoverFromView:btnFilter];
}

-(void)didChooseGeneralPopTableView:(NSDictionary *)chooseData
{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.delegate = self;
//    [HUD showWhileExecuting:@selector(didChooseGeneralPopTableViewExe:) onTarget:self withObject:chooseData animated:YES];
    
    [popover dismissPopoverAnimated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.select-filter", NULL);
    dispatch_async(queue, ^(void) {
        NSDictionary *getListOfMyOrder = [self getListOfMyOrderByFilter:[chooseData objectForKey:@"status_label"]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[MyOrderClass instance] setListOfMyOrder:getListOfMyOrder];
            [self setOrderView];
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

-(void)setOrderView{
    
    [scroller.boxes removeAllObjects];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.my-order", NULL);
    dispatch_async(queue, ^(void) {
        
        NSDictionary *getMyListOfOrder = [[MyOrderClass instance] getListOfMyOrder];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            NSArray *lists = [getMyListOfOrder objectForKey:@"my_order"];
            NSArray *lists = [getMyListOfOrder objectForKey:@"all_order"];
            if([lists count] == 0)
            {
                [self noOrderBox];
            }
            else
            {
                for(int i=0;i<[lists count];i++)
                {
                    NSDictionary *list = [lists objectAtIndex:i];
                    [self order_box:[list objectForKey:@"orderID"] status:[list objectForKey:@"status"] orderDate:[list objectForKey:@"orderDate"] price:[NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[AppDelegate convertToThousandSeparator:[list objectForKey:@"order_total"]]] orderInfo:list];
                }
            }
            
            [scroller layoutWithSpeed:0.3 completion:nil];
        });
    });
}


-(void)order_box:(NSString*)orderNo status:(NSString*)status orderDate:(NSString*)orderDate price:(NSString*)totalPrice orderInfo:(NSDictionary*)orderInfo{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(300-27, 30, 18, 18);
    
    MGLineStyled *header = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"#%@ - %@",orderNo,status] right:img size:CGSizeMake(300, 40)];
    header.font = [UIFont fontWithName:BOLDFONT size:14];
    header.leftPadding = header.rightPadding = 16;
    [section.topLines addObject:header];
    
    MGLineStyled *body1 = [MGLineStyled lineWithLeft:[NSString stringWithFormat:@"%@",orderDate] right:totalPrice size:CGSizeMake(300, 40)];
    body1.font = [UIFont fontWithName:PRIMARYFONT size:12];
    body1.leftPadding = header.rightPadding = 16;
    [section.topLines addObject:body1];
    
    
    section.onTap = ^{
        [[MyOrderClass instance] setMyOrder:orderInfo];
//
//        //[[MainViewClass instance] openOrderViewController];
        OrderViewController *order = [[OrderViewController alloc] init];
        order.parent = self;
        [order noCloseBtn];
        [self.navigationController pushViewController:order animated:YES];
        
    };
    
}


-(void)noOrderBox
{
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    
    id body = NSLocalizedString(@"orderViewController.no_order_title", nil);
    
    // stuff
    MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
                                                 padding:UIEdgeInsetsMake(10, 10, 10, 10)];
    line.backgroundColor = [UIColor clearColor];
    line.borderStyle &= ~MGBorderEtchedBottom;
    [section.topLines addObject:line];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    initialContentOffset = scrollViews.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    
    [[SettingDataClass instance] autoHideGlobal:scrollViews navigationView:self.navigationController contentOffset:initialContentOffset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
