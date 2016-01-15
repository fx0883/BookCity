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
#import "BookModel.h"

#import "SVPullToRefresh.h"


@interface SearchTableViewController ()
{
    MBProgressHUD* progressTest;
    __weak NSURLSessionTask* _task;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _aryBook = [NSMutableArray new];
    [self registCell];
    [self addPullRefresh];

}


-(void)addPullRefresh
{
    __weak SearchTableViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}


- (void)insertRowAtBottom {
    __weak SearchTableViewController *weakSelf = self;
    
    
    
    if ([_searchKey length] > 0) {
        _pageIndex++;
        [self searchBook:_searchKey];
        
        
    }
}

-(void)registCell
{
//    self.collectionView?.registerNib(UINib(nibName: "IDeasCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: IDEASCELLIDENTIFY);
   
    UINib *nib = [UINib nibWithNibName:@"BookCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:BOOKCELLID];
}

//点击键盘上的search按钮时调用

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    
    NSString *searchTerm = searchBar.text;
    
    _searchKey = searchTerm;
    _pageIndex = 1;
    
    [self searchBook:_searchKey];
    

    

    [self.searchDisplayController setActive:NO animated:YES];
}

-(void)searchBook:(NSString*)strKey
{
    if (!_task) {
        [_task cancel];
    }
    
    //实例化一个传入传出参数
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=strKey;
    baseparam.paramInt = _pageIndex;
    
//    [baseparam.paramDic setObject:@"id" forKey:@"234"];
    
    __weak SearchTableViewController *weakSelf=self;
    __weak BMBaseParam *weakBaseParam = baseparam;
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj)
    {
        if (intError == 0)
        {
            if (weakBaseParam.paramInt == 1) {
                [_aryBook removeAllObjects];
            }
            [_aryBook addObjectsFromArray:weakBaseParam.resultArray];
            [weakSelf.tableView reloadData];

        }
        else
        {
            NSLog(@"获取数据失败");
        }
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    };
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_GETSEARCHBOOKRESULT];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
//    progressTest = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    progressTest.labelText = @"加载中...";
//    progressTest.mode = MBProgressHUDModeIndeterminate;//可以显示不同风格的进度；
//    
//    _task = (NSURLSessionTask*)baseparam.paramObject;
//    
//    [progressTest setAnimatingWithStateOfTask:_task];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    else if(tableView == self.tableView)
    {
        return [_aryBook count];
    }
    return 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
    UIViewController *destination = [segue destinationViewController];
    
    if ([destination respondsToSelector:@selector(setBookModel:)]) {
        
        [destination setValue:sender forKey:@"bookModel"];
        
    }
    
    //    UIViewController *vc = segue.destinationViewController;
    
    //    [vc.navigationItem setTitle:[NSString stringWithFormat:@"%@的联系人",self.textfieldName.text]];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel* bookmodel = [_aryBook objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"searchBookToChapterList" sender:bookmodel];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    else if(tableView == self.tableView)
    {
    BookCell *cell = (BookCell*)[tableView dequeueReusableCellWithIdentifier:BOOKCELLID forIndexPath:indexPath];
    BookModel *bookmodel = [_aryBook objectAtIndex:indexPath.row];
    
    [cell setBookModel:bookmodel];
    return cell;
    }
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 150;
//}


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
