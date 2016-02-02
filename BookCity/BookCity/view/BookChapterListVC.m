//
//  BookChapterListVC.m
//  BookCity
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BookChapterListVC.h"
#import "BookChapterModel.h"
#import "MBProgressHUD.h"

@interface BookChapterListVC ()
{
    NSMutableArray *_aryBook;
    __weak NSURLSessionTask* _task;
    MBProgressHUD *progressTest;
}
@end

@implementation BookChapterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",_bookModel);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
    self.navigationItem.title = _bookModel.title;
    if(_bookModel.aryChapterList == nil)
    {
        _bookModel.aryChapterList = [NSMutableArray new];
        [self getChapterList];
    }
    _aryBook = _bookModel.aryChapterList;
}
- (IBAction)onClickDownloadButton:(id)sender {
    
   // [_bookModel saveImgSrc];
    [self downloadplist];
}


-(void)downloadplist
{
    if (!_task) {
        [_task cancel];
    }
    
    //实例化一个传入传出参数
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=_bookModel.bookLink;
    baseparam.paramObject = _bookModel;
    
    //    [baseparam.paramDic setObject:@"id" forKey:@"234"];
    
    __weak BookChapterListVC *weakSelf=self;
    __weak BMBaseParam *weakBaseParam = baseparam;
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj)
    {
        if (intError == 0)
        {
            
            
            
            
        }
        else
        {
            
        }
        
        NSLog(@"==================>当前进度%f",_bookModel.finishChapterNumber/((float)[_bookModel.aryChapterList count]));
        NSLog(@"%ld",_bookModel.finishChapterNumber);
        
        if (progressTest) {
            if([_bookModel.aryChapterList count]==_bookModel.finishChapterNumber)
            {
                [progressTest hide:YES];
            }
 
        }
        
    };
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_DOWNLOADPLIST];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
    if (progressTest == nil) {
        progressTest = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [progressTest show:YES];
    progressTest.labelText = @"下载中...";
    progressTest.mode = MBProgressHUDModeIndeterminate;//可以显示不同风格的进度；
}

-(void)getChapterList
{
    if (!_task) {
        [_task cancel];
    }
    
    //实例化一个传入传出参数
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=_bookModel.bookLink;

    
    //    [baseparam.paramDic setObject:@"id" forKey:@"234"];
    
    __weak BookChapterListVC *weakSelf=self;
    __weak BMBaseParam *weakBaseParam = baseparam;
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj)
    {
        if (intError == 0)
        {
            [_aryBook addObjectsFromArray:weakBaseParam.resultArray];
            [weakSelf.tableView reloadData];
            
            
            
        }
        else
        {
            NSLog(@"获取数据失败");
        }
        
        if (progressTest) {
            [progressTest hide:YES];
        }

    };
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_GETBOOKCHAPTERLIST];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
    if (progressTest == nil) {
        progressTest = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
        progressTest.labelText = @"加载中...";
        progressTest.mode = MBProgressHUDModeIndeterminate;//可以显示不同风格的进度；
    //
//        _task = (NSURLSessionTask*)baseparam.paramObject;
    
//        [progressTest setAnimatingWithStateOfTask:_task];
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
    
    NSInteger rowCount=0;

    if (_aryBook) {
        rowCount = [_aryBook count];
    }

    
    return rowCount;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    //    NSString *strKey = [_aryCategory objectAtIndex:indexPath.row];
//    BookChapterModel* bookChapterModel = [_aryBook objectAtIndex:indexPath.row];
    
    [_bookModel setCurChapter:indexPath.row];
    UIViewController *destination = [segue destinationViewController];
    
    if ([destination respondsToSelector:@selector(setBookChapterModel:)]) {
        
//        [destination setValue:bookChapterModel forKey:@"bookChapterModel"];
        
        [destination setValue:_bookModel forKey:@"bookModel"];
        
    }
    

    
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chapterNameCell" forIndexPath:indexPath];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    //
    //    }
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    BookChapterModel *bookchaptermodel = [_aryBook objectAtIndex:indexPath.row];
    
    cell.text = bookchaptermodel.title;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
