//
//  ChapterDetailViewController.m
//  BookCity
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "ChapterDetailViewController.h"
#import "MBProgressHUD.h"
@interface ChapterDetailViewController ()
{
    __weak NSURLSessionTask* _task;
    MBProgressHUD *progressTest;
}
@end

@implementation ChapterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_bookChapterModel);
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData
{
//    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    [_webView loadRequest:request];//加载
    
    
//    [self.webView loadHTMLString:@"Hello World" baseURL:nil];
    
    //实例化一个传入传出参数
    

    if ([_bookChapterModel.htmlContent length]>0) {
       [self.webView loadHTMLString:_bookChapterModel.htmlContent baseURL:nil];
        return;
    }
    
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=_bookChapterModel.hostUrl;
    baseparam.paramString2=_bookChapterModel.url;
    baseparam.paramObject = _bookChapterModel;
    
    
    //    [baseparam.paramDic setObject:@"id" forKey:@"234"];
    
    __weak ChapterDetailViewController *weakSelf=self;
    __weak BMBaseParam *weakBaseParam = baseparam;
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj)
    {
        if (intError == 0)
        {
//            [_aryBook addObjectsFromArray:weakBaseParam.resultArray];
//            [weakSelf.tableView reloadData];
            
            [self.webView loadHTMLString:weakBaseParam.resultString baseURL:nil];
            
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
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_GETBOOKCHAPTERDETAIL];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
    if (progressTest == nil) {
        progressTest = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    progressTest.labelText = @"加载中...";
    progressTest.mode = MBProgressHUDModeIndeterminate;//可以显示不同风格的进度；
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
