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

-(void)loadingIndicator {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(150, 70, 24, 24);
    spinner.hidesWhenStopped = YES;
    
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
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
    
    myOrderDict = [NSMutableDictionary dictionaryWithCapacity:1];
    orderArray = [NSMutableArray arrayWithCapacity:1];
    fixedHeight = CGRectGetHeight(scroller.frame);
    currentPage = 1;
    filterSlug = @"All";
    isLoadMore = NO;
    
    [self listOrder];
    
    btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFilter.frame = CGRectMake(self.view.frame.size.width - 69, 8, 100, 30);
//    [btnFilter setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateNormal];

    btnFilter.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [btnFilter setTitle:NSLocalizedString(@"orderViewController.filter_btn_title", nil) forState:UIControlStateNormal];
    [btnFilter addTarget:self
                 action:@selector(filterAction)
       forControlEvents:UIControlEventTouchDown];
    [btnFilter setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -50)];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:btnFilter];

    self.navigationItem.rightBarButtonItem = button;
    
    //add indicator view
    myActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    myActivityView.frame = CGRectMake(self.view.size.width/2-10, self.view.size.height/2-10, 25, 25);
    myActivityView.hidesWhenStopped = YES;
    [self.view addSubview:myActivityView];
    [myActivityView startAnimating];
}

- (void) listOrder {
//    UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
//    [act startAnimating];
//    
//    UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//    loadMoreLbl.hidden = YES;
    
//    [self loadingIndicator];
    
    currentPage = 1;
    
    //get list order
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.get-list-order", NULL);
    dispatch_async(queue, ^(void) {
        processing = YES;

        NSDictionary *tmpOrderDict = [self getListOfMyOrderByFilter:filterSlug page:currentPage numberRow:NUMBER_ROW_PER_LOAD];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [myActivityView stopAnimating];
            
            NSMutableArray *tmpArray = [tmpOrderDict objectForKey:@"all_order"];
            for (int i=0;i < [tmpArray count];i++) {
                NSDictionary *dict = [tmpArray objectAtIndex:i];
                [orderArray addObject:dict];
            }
            
            if ([orderArray count] > 0) {
                [myOrderDict setObject:orderArray forKey:@"all_order"];
                [myOrderDict setObject:filterSlug forKey:@"filter"];
            }
            
            processing = NO;
            [[MyOrderClass instance] setListOfMyOrder:myOrderDict];
        
            [self setOrderView];
            
            if ([tmpArray count] <= NUMBER_ROW_PER_LOAD) {
                isLoadMore = YES;
            }
            else {
                isLoadMore = NO;
//                [self loadMoreOrder]; //display load more box
            }
            
//            UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
//            [act stopAnimating];
//            
//            UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//            loadMoreLbl.hidden = NO;
        });
    });
}

- (void) listMoreOrder {
//    UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
//    [act startAnimating];
//
//    UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//    loadMoreLbl.hidden = YES;

//    [self loadingIndicator];
    
    //get list order
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.get-list-order", NULL);
    dispatch_async(queue, ^(void) {
        processing = YES;
        
        NSDictionary *tmpOrderDict = [self getListOfMyOrderByFilter:filterSlug page:currentPage numberRow:NUMBER_ROW_PER_LOAD];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [spinner removeFromSuperview];
            
            NSMutableArray *tmpArray = [tmpOrderDict objectForKey:@"all_order"];
            for (int i=0;i < [tmpArray count];i++) {
                NSDictionary *dict = [tmpArray objectAtIndex:i];
                [orderArray addObject:dict];
            }
            
            if ([orderArray count] > 0) {
                [myOrderDict setObject:orderArray forKey:@"all_order"];
                [myOrderDict setObject:filterSlug forKey:@"filter"];
            }
            
            [[MyOrderClass instance] setListOfMyOrder:myOrderDict];
            
            [self setOrderView];
            
            if ([tmpArray count] <= NUMBER_ROW_PER_LOAD) {
                isLoadMore = YES;
            }
            else {
                isLoadMore = NO;
//                [self loadMoreOrder]; //display load more box
            }
            
            processing = NO;
            
//            UIActivityIndicatorView *act = [[MiscInstances instance] getLoadMoreActivityView];
//            [act stopAnimating];
//            
//            UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//            loadMoreLbl.hidden = NO;
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

- (NSDictionary*) getListOfMyOrderByFilter:(NSString*)_filterType page:(int)_page numberRow:(int)_numberRow {
    NSMutableDictionary *tmpOrderDict;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-all-order-paging",[[AppDelegate instance] getDatabaseURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.requestMethod = @"POST";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *decryptedUsername = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:USERNAME]];
    NSString *decryptedPassword = [[AppDelegate instance] getDecryptedData:[userDefaults objectForKey:PASSWORD]];
    NSString *filterType = _filterType;
    
    [request addPostValue:decryptedUsername forKey:@"username"];
    [request addPostValue:decryptedPassword forKey:@"password"];
    [request addPostValue:filterType forKey:@"filter"];
    [request addPostValue:[NSNumber numberWithInt:_page] forKey:@"page"];
    [request addPostValue:[NSNumber numberWithInt:_numberRow] forKey:@"itemperpage"];
    
    [request startSynchronous];
    
    NSError *error;
    
    if (!error) {
        NSString *responseStr = [request responseString];
        
        tmpOrderDict = [responseStr JSONValue];
    }
    
    return tmpOrderDict;
}

-(void)loadMoreOrder {
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    PhotoBox *box = [PhotoBox loadMore:CGSizeMake(300, 30)];
    
    box.onTap = ^{
//        if(currentPage == totalPage)
        if (!isLoadMore)
        {
            NSLog(@"Maximun page is reached");
        }
        else
        {
            currentPage += 1;
            [self listMoreOrder];
        }
    };
    
    [section.topLines addObject:box];
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
    
    [orderArray removeAllObjects];
    [scroller setContentSize:CGSizeMake(310, 548)];
    
    currentPage = 1;
    
    filterSlug = [chooseData objectForKey:@"status_slug"];
    
    NSString *statusStr = [[chooseData objectForKey:@"status_slug"] mutableCopy];
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
    [btnFilter setTitle:statusStr forState:UIControlStateNormal];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.select-filter", NULL);
    dispatch_async(queue, ^(void) {
        NSDictionary *tmpOrderDict = [self getListOfMyOrderByFilter:filterSlug page:currentPage numberRow:NUMBER_ROW_PER_LOAD];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [spinner removeFromSuperview];
            
            NSMutableArray *tmpArray = [tmpOrderDict objectForKey:@"all_order"];
            for (int i=0;i < [tmpArray count];i++) {
                NSDictionary *dict = [tmpArray objectAtIndex:i];
                [orderArray addObject:dict];
            }
            
            if ([orderArray count] > 0) {
                [myOrderDict setObject:orderArray forKey:@"all_order"];
                [myOrderDict setObject:filterSlug forKey:@"filter"];
            }
            
            processing = NO;
            [[MyOrderClass instance] setListOfMyOrder:myOrderDict];
            
            [self setOrderView];
            
            if ([tmpArray count] <= NUMBER_ROW_PER_LOAD) {
                isLoadMore = YES;
                //                [self loadMoreOrder]; //display load more box
            }
            else {
                isLoadMore = NO;
            }
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

-(void)setOrderView{
    
    [scroller.boxes removeAllObjects];
    
//    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.my-order", NULL);
//    dispatch_async(queue, ^(void) {
    
        NSDictionary *getMyListOfOrder = [[MyOrderClass instance] getListOfMyOrder];
        
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
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
            
            [scroller layoutWithSpeed:VIEW_COMPILE_SPEED completion:nil];
//        });
//    });
}


-(void)order_box:(NSString*)orderNo status:(NSString*)status orderDate:(NSString*)orderDate price:(NSString*)totalPrice orderInfo:(NSDictionary*)orderInfo{
    
    if ([status isEqualToString:@"All"])
        status = NSLocalizedString(@"status_list.all", nil);
    else if ([status isEqualToString:@"pending"])
        status = NSLocalizedString(@"status_list.pending", nil);
    else if ([status isEqualToString:@"failed"])
        status = NSLocalizedString(@"status_list.failed", nil);
    else if ([status isEqualToString:@"on-hold"])
        status = NSLocalizedString(@"status_list.on-hold", nil);
    else if ([status isEqualToString:@"processing"])
        status = NSLocalizedString(@"status_list.processing", nil);
    else if ([status isEqualToString:@"completed"])
        status = NSLocalizedString(@"status_list.completed", nil);
    else if ([status isEqualToString:@"refunded"])
        status = NSLocalizedString(@"status_list.refunded", nil);
    else if ([status isEqualToString:@"cancelled"])
        status = NSLocalizedString(@"status_list.cancelled", nil);
    
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

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
//{
//    initialContentOffset = scrollViews.contentOffset;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
//{
//    
//    [[SettingDataClass instance] autoHideGlobal:scrollViews navigationView:self.navigationController contentOffset:initialContentOffset];
//}

//UIScrollViewDelegate Method
- (CGFloat)tableScrollOffset {
    
    CGFloat offset = 0.0f;
    
    if ([scroller contentSize].height < CGRectGetHeight([scroller frame])) {
        
        offset = -[scroller contentOffset].y;
        
    } else {
        
        offset = ([scroller contentSize].height - [scroller contentOffset].y) - CGRectGetHeight([scroller frame]);
    }
    
    return offset;
}

- (BOOL)detectEndofScroll{
    
    BOOL scrollResult;
    CGPoint offset = scroller.contentOffset;
    CGRect bounds = scroller.bounds;
    CGSize size =scroller.contentSize;
    UIEdgeInsets inset = scroller.contentInset;
    float yaxis = offset.y + bounds.size.height - inset.bottom;
    float h = size.height+50;
    if(yaxis > h) {
        scrollResult = YES;
    }else{
        scrollResult = NO;
    }
    
    return scrollResult;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
    didReadyLoadMore = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
//    
//    CGFloat offset = [self tableScrollOffset];
//    
//    if (offset >= 0.0f) {
//        
//        NSLog(@"Load More");
//        UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//        loadMoreLbl.text = NSLocalizedString(@"browse_view_load_more", nil);
//    }
//    else if (offset <= 0 && offset >= -fixedHeight) {
//        if([self detectEndofScroll])
//        {
//            
//            NSLog(@"Release to refresh");
//            UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//            loadMoreLbl.text = NSLocalizedString(@"browse_view_release_to_refresh", nil);
//        }
//        else
//        {
//            NSLog(@"Pull to refresh");
//            UILabel *loadMoreLbl = [[MiscInstances instance] getLoadMoreUILabel];
//            loadMoreLbl.text = NSLocalizedString(@"browse_view_pull_to_refresh", nil);
//        }
//    }
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height && !didReadyLoadMore)
    {
        didReadyLoadMore = YES;
        if(processing == NO)
        {
            if (!isLoadMore)
            {
                NSLog(@"Maximun page is reached");
            }
            else
            {
                currentPage += 1;
                [self listMoreOrder];
            }
        }
        else
        {
            NSLog(@"Still processing");
            
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
//
//    if ([self detectEndofScroll]){
//        
//        NSLog(@"Now go to another page");
//        
//        if(processing == NO)
//        {
//            if (!isLoadMore)
//            {
//                NSLog(@"Maximun page is reached");
//            }
//            else
//            {
//                currentPage += 1;
//                [self listMoreOrder];
//            }
//        }
//        else
//        {
//            NSLog(@"Still processing");
//            
//        }
//    }
}

@end
