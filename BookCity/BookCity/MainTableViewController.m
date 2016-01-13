//
//  MainTableViewController.m
//  BookCity
//
//  Created by 冯璇 on 16/1/1.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "MainTableViewController.h"
#import "BookCategoryModel.h"
#import "DataManager.h"


@interface MainTableViewController ()
{
    NSArray* _aryCategory;
}
@end

@implementation MainTableViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationItem.title = @"BookCity";
    [self loadData];
//    [self registCell];
}

-(void)loadData
{
    _aryCategory = [DataManager sharedInstance].bookCategory;
    
    
    
    
}

-(void)registCell
{
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"categoryCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_aryCategory count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    NSString *strKey = [_aryCategory objectAtIndex:indexPath.row];
    BookCategoryModel* bookCategoryModel = [_aryCategory objectAtIndex:indexPath.row];
    UIViewController *destination = [segue destinationViewController];
    
    if ([destination respondsToSelector:@selector(setBookCategoryModel:)]) {
        
        [destination setValue:bookCategoryModel forKey:@"bookCategoryModel"];
        
    }
    
    //    UIViewController *vc = segue.destinationViewController;
    
//    [vc.navigationItem setTitle:[NSString stringWithFormat:@"%@的联系人",self.textfieldName.text]];
    
    
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//        NSString *strKey = [[_dicCategory allKeys] objectAtIndex:indexPath.row];
//        BookCategoryModel* bookCategoryModel = _dicCategory[strKey];
////        [self performSegueWithIdentifier:@"categoryBooksSegue" sender:bookCategoryModel];
//}

//-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    eatDetailVC *detailView = [[eatDetailVC alloc]init];
////    [self.navigationController pushViewController:detailView animated:NO];
//    
////    NSString *strKey = [[_dicCategory allKeys] objectAtIndex:indexPath.row];
////    BookCategoryModel* bookCategoryModel = _dicCategory[strKey];
////    [self performSegueWithIdentifier:@"categoryBooksSegue" sender:bookCategoryModel];
//    return indexPath;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCategoryCell" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
//
//    }
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    BookCategoryModel *bookcategorymodel = [_aryCategory objectAtIndex:indexPath.row];
    
    cell.text = bookcategorymodel.name;
    return cell;
}
//categoryBooksSegue

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
