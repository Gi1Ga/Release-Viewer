//
//  DataViewController.m
//  Release Viewer
//
//  Created by Wang, Aaron on 29/03/2017.
//  Copyright © 2017 BHP Billiton. All rights reserved.
//

#import "DataViewController.h"
#import "ViewController.h"
#import "GraphViewController.h"

@interface DataViewController ()

@property (copy,nonatomic) NSArray *displayTypes;
@property (copy,nonatomic) NSString *project;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayTypes=@[@"Data",@"Trend",@"Platform"];
    self.tableView = (id)[self.view viewWithTag:2];
/*    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top=40;
    [self.tableView setContentInset:contentInset];
*/    

 
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DisplayType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text=self.displayTypes[indexPath.row];
    cell.detailTextLabel.text=self.displayTypes[indexPath.row];
    UIImage *image = [UIImage imageNamed:self.displayTypes[indexPath.row]];
    cell.imageView.image = image;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    GraphViewController *gVC=segue.destinationViewController;
    
    NSString *displayType=self.displayTypes[indexPath.row];
    gVC.navigationItem.title=displayType;
    gVC.project=self.navigationItem.title;
}


@end
