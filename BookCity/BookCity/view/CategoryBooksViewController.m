//
//  CategoryBooks.m
//  BookCity
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "CategoryBooksViewController.h"

#import "BookCell.h"
#import "BookModel.h"
#import "DataManager.h"

#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"

@interface CategoryBooksViewController ()
{
    NSMutableArray *_aryBook;
    __weak NSURLSessionTask* _task;
    MBProgressHUD *progressTest;
}
@end

@implementation CategoryBooksViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",_bookCategoryModel);
    _aryBook = [[DataManager sharedInstance] getBookArybyCategoryname:_bookCategoryModel.name];
    [self registCell];
    
    [self addPullRefresh];
    

    if ([_aryBook count]==0) {
            [self insertRowAtBottom];
    }
    self.navigationItem.title = _bookCategoryModel.name;
}

-(void)registCell
{
    UINib *nib = [UINib nibWithNibName:@"BookCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:BOOKCELLID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addPullRefresh
{
    __weak CategoryBooksViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}


- (void)insertRowAtBottom {
    __weak CategoryBooksViewController *weakSelf = self;
    
    [self getCategoryBooks];
    weakSelf.bookCategoryModel.curIndex++;
    
//    if ([_searchKey length] > 0) {
//        _pageIndex++;
//        [self searchBook:_searchKey];
//        
//        
//    }
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

        [self performSegueWithIdentifier:@"categorybookToDetail" sender:bookmodel];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_aryBook count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        BookCell *cell = (BookCell*)[tableView dequeueReusableCellWithIdentifier:BOOKCELLID forIndexPath:indexPath];
        BookModel *bookmodel = [_aryBook objectAtIndex:indexPath.row];
        
        [cell setBookModel:bookmodel];
        return cell;

}


-(void)getCategoryBooks
{
    if (!_task) {
        [_task cancel];
    }
    
    //实例化一个传入传出参数
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=_bookCategoryModel.strUrl;
    baseparam.paramInt = _bookCategoryModel.curIndex;
    
    //    [baseparam.paramDic setObject:@"id" forKey:@"234"];
    
    __weak CategoryBooksViewController *weakSelf=self;
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
        [progressTest hide:YES];
    };
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_GETCATEGORYBOOKSRESULT];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
    if (progressTest == nil) {
        progressTest = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [progressTest show:YES];
    progressTest.labelText = @"加载中...";
    progressTest.mode = MBProgressHUDModeIndeterminate;//可以显示不同风格的进度；
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
