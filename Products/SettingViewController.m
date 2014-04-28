//
//  SettingViewController.m
//  ShopManager
//
//  Created by Steven on 4/10/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "SettingViewController.h"
#import "ExploreViewController.h"
#import "CategoryViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = NSLocalizedString(@"settingViewController.title", nil);
    
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *moduleTitle[] = {
        NSLocalizedString(@"settingViewController.products", nil),
        NSLocalizedString(@"settingViewController.categories", nil)
    };
    
    NSString *moduleIndex[] = {
        [NSString stringWithFormat:@"%d",kProduct],
        [NSString stringWithFormat:@"%d",kCategory]
    };
    
    for (int i=0;i < sizeof(moduleTitle)/sizeof(moduleTitle[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:moduleIndex[i],@"index",moduleTitle[i],@"title", nil];
        [mainArray addObject:dict];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"CellIdentify";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    // Configure the cell...

    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"title"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    // Navigation logic may go here, for example:
    if ([[dict objectForKey:@"index"] intValue] == kProduct) {
        ExploreViewController *controller = [[ExploreViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([[dict objectForKeyedSubscript:@"index"] intValue] == kCategory) {
        CategoryViewController *controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
