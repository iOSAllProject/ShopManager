//
//  ListCameraViewController.m
//  ShopManager
//
//  Created by Steven on 3/23/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "ListCameraViewController.h"
#import "AddNewCameraViewController.h"
#import "DFUViewController.h"

@interface ListCameraViewController ()

@end

@implementation ListCameraViewController
@synthesize mainArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.title = NSLocalizedString(@"cameraViewController.title", nil);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    mainArray = [userDefaults objectForKey:CAMERA_LIST];
    
    if (mainArray == nil)
        mainArray = [NSMutableArray arrayWithCapacity:1];
    
    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"listCameraVC.btn-add-title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addNewCamera)];
    self.navigationItem.rightBarButtonItem = btnAdd;
}

- (void) addNewCamera {
    AddNewCameraViewController *controller = [[AddNewCameraViewController alloc] initWithNibName:@"AddNewCameraViewController" bundle:nil parent:self];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"cameraName"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIButton *btnInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    btnInfo.tag = indexPath.row + 50;
    btnInfo.frame = CGRectMake(250, 10, 30, 30);
    [btnInfo addTarget:self action:@selector(editCamera:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnInfo];
    
    return cell;
}

- (void) editCamera:(UIButton*)sender {
    int index = sender.tag - 50;
    NSMutableDictionary *cameraDict = [mainArray objectAtIndex:index];
    AddNewCameraViewController *controller = [[AddNewCameraViewController alloc] initWithNibName:@"AddNewCameraViewController" bundle:nil parent:self];
    controller.isEdit = YES;
    controller.cameraDict = cameraDict;
    [self.navigationController pushViewController:controller animated:YES];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
//    NSMutableDictionary *cameraDict = [mainArray objectAtIndex:indexPath.row];
    
    // Create the next view controller.
    DFUViewController *controller = [[DFUViewController alloc] initWithNibName:@"DFUViewController_iPhone" bundle:nil];
    controller.cameraArray = mainArray;
    
    // Push the view controller.
    [self.navigationController pushViewController:controller animated:YES];
}

@end
