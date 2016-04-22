//
//  MainTableViewController.m
//  BookCity
//
//  Created by 冯璇 on 16/1/1.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "MainTableViewController.h"
#import "BCTBookCategoryModel.h"
#import "BCTDataManager.h"


@interface MainTableViewController ()
{
    NSArray* _aryCategory;
}
@end

@implementation MainTableViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationItem.title = @"BookCity";
    [self loadData];

}

-(void)loadData {
    _aryCategory = [BCTDataManager sharedInstance].bookCategory;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_aryCategory count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    NSString *strKey = [_aryCategory objectAtIndex:indexPath.row];
    BCTBookCategoryModel* bookCategoryModel = [_aryCategory objectAtIndex:indexPath.row];
    UIViewController *destination = [segue destinationViewController];
    
    if ([destination respondsToSelector:@selector(setBookCategoryModel:)]) {
        
        [destination setValue:bookCategoryModel forKey:@"bookCategoryModel"];
        
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCategoryCell" forIndexPath:indexPath];

    BCTBookCategoryModel *bookcategorymodel = [_aryCategory objectAtIndex:indexPath.row];
    
    cell.text = bookcategorymodel.name;
    return cell;
}


@end
