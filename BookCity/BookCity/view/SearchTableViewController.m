//
//  SearchTableViewController.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MBProgressHUD.h"

#import "BookCell.h"
#import "BCTBookModel.h"

#import "SVPullToRefresh.h"


@interface SearchTableViewController ()
{
    MBProgressHUD* progressTest;
    NSMutableArray *_aryBook;
    NSInteger _pageIndex;
    NSString *_searchKey;
}
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    _pageIndex = 1;
    _searchKey = @"";
    [super viewDidLoad];

    _aryBook = [NSMutableArray new];
    
    UINib *nib = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:BOOKCELLID];
    
    __weak SearchTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

- (void)insertRowAtBottom {

    if ([_searchKey length] > 0) {
        _pageIndex++;
        [self searchBook:_searchKey];
    }
}


//点击键盘上的search按钮时调用
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *searchTerm = searchBar.text;
    
    _searchKey = searchTerm;
    _pageIndex = 1;
    
    [self searchBook:_searchKey];
    

    [self.searchDisplayController setActive:NO animated:YES];
    
    [_aryBook removeAllObjects];
    [self.tableView reloadData];
}

-(void)searchBook:(NSString*)strKey {
    //实例化一个传入传出参数
    BMBaseParam* baseparam = [BMBaseParam new];
    
    //参数
    baseparam.paramString = strKey;
    baseparam.paramInt = _pageIndex;
    
    __weak SearchTableViewController *weakSelf=self;
    __weak BMBaseParam *weakBaseParam = baseparam;

    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj) {
        if (intError == 0) {
            [_aryBook addObjectsFromArray:weakBaseParam.resultArray];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"获取数据失败");
        }
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    };
    
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_GETSEARCHBOOKRESULT];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    else if(tableView == self.tableView)
    {
        return [_aryBook count];
    }
    return 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *destination = [segue destinationViewController];
    
    if ([destination respondsToSelector:@selector(setBookModel:)]) {
        
        [destination setValue:sender forKey:@"bookModel"];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BCTBookModel* bookmodel = [_aryBook objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"searchBookToChapterList" sender:bookmodel];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    else if(tableView == self.tableView)
    {
    BookCell *cell = (BookCell*)[tableView dequeueReusableCellWithIdentifier:BOOKCELLID forIndexPath:indexPath];
    BCTBookModel *bookmodel = [_aryBook objectAtIndex:indexPath.row];
    
    [cell setBookModel:bookmodel];
    return cell;
    }
    return nil;
}

@end
