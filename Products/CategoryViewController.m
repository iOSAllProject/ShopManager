//
//  CategoryViewController.m
//  ShopManager
//
//  Created by Steven on 4/12/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"settingViewController.categories", nil);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *categoryOption = [[[[SettingDataClass instance] getSetting] objectForKey:@"appearance_option"] objectForKey:@"category_browse_option"];
    
    if([categoryOption isEqualToString:@"listall"])
    {
        mainArray = [DataService instance].productCategories;
    }
    else
    {
        mainArray = [DataService instance].productCategoriesCustom;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    NSString *showThumb = [[[[SettingDataClass instance] getSetting] objectForKey:@"appearance_option"] objectForKey:@"category_browse_show_thumb"];
    if([showThumb isEqualToString:@"show"])
    {
        UIImageView *img = [[UIImageView alloc] init];
        img = cell.imageView;
        [cell.imageView setImageWithURL:[NSURL URLWithString:[[ToolClass instance] decodeHTMLCharacterEntities:[[mainArray objectAtIndex:indexPath.row] objectForKey:@"thumb"]]]
                       placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  
                                  img.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(57, 57) source:image];
                                  
                              }];
    }
    
    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[mainArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
