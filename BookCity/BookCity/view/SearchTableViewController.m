//
//  SearchTableViewController.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MBProgressHUD.h"
@interface SearchTableViewController ()
{
    MBProgressHUD* progressTest;
    __weak NSURLSessionTask* _task;
}
@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self searchBook:@"校花"];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
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
