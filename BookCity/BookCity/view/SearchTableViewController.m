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


@interface SearchTableViewController ()
{
    MBProgressHUD* progressTest;
    __weak NSURLSessionTask* _task;
    NSMutableArray *_aryBook;
}
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _aryBook = [NSMutableArray new];
    [self registCell];

        [self searchBook:@"花千骨"];
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
    
    [self searchBook:searchTerm];
    
//    [searchBar resignFirstResponder];
    
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
    
    [baseparam.paramDic setObject:@"id" forKey:@"234"];
    
    __weak SearchTableViewController *weakSelf=self;
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj)
    {
        if (intError == 0)
        {
            //服务器返回数据
//            WeatherResultModel *weatherresultmodel = (WeatherResultModel*)obj;
//            if (weatherresultmodel) {
//                [weakSelf refreshExampleVC:weatherresultmodel];
//            }
            
            [_aryBook addObjectsFromArray:baseparam.resultArray];
            [weakSelf.tableView reloadData];
        }
        else
        {
            NSLog(@"获取数据失败");
        }
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
    return [_aryBook count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCell *cell = (BookCell*)[tableView dequeueReusableCellWithIdentifier:BOOKCELLID forIndexPath:indexPath];
//
//     Configure the cell...
//
    BookModel *bookmodel = [_aryBook objectAtIndex:indexPath.row];
    
    [cell setBookModel:bookmodel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
