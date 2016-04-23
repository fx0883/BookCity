//
//  BookChapterListVC.m
//  BookCity
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BookChapterListVC.h"
#import "BCTBookChapterModel.h"
#import "MBProgressHUD.h"
#import "ChapterDetailViewController.h"

@interface BookChapterListVC () {
    NSMutableArray *_aryBook;
}
@property (nonatomic, strong) MBProgressHUD *progressTest;
@end

@implementation BookChapterListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = _bookModel.title;
    if(_bookModel.aryChapterList == nil) {
        _bookModel.aryChapterList = [NSMutableArray new];
        [self getChapterList];
    }
    
    _aryBook = _bookModel.aryChapterList;
}

- (IBAction)onClickDownloadButton:(id)sender {
    
    [self downloadplist];
}


-(void)downloadplist {
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=_bookModel.bookLink;
    baseparam.paramObject = _bookModel;

    __weak BookChapterListVC *weakSelf=self;
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj) {
        NSLog(@"==================>当前进度%f",_bookModel.finishChapterNumber/((float)[_bookModel.aryChapterList count]));
        NSLog(@"%ld",_bookModel.finishChapterNumber);
        
        if (weakSelf.progressTest) {
            if([weakSelf.bookModel.aryChapterList count] == weakSelf.bookModel.finishChapterNumber) {
                [weakSelf.progressTest hide:YES];
            }
        }
    };
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_DOWNLOADPLIST];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
    [self showLoading];
}

-(void)getChapterList {
    BMBaseParam* baseparam=[BMBaseParam new];
    
    //参数
    baseparam.paramString=_bookModel.bookLink;

    __weak BookChapterListVC *weakSelf=self;
    __weak BMBaseParam *weakBaseParam = baseparam;
    
    baseparam.withresultobjectblock=^(int intError,NSString* strMsg,id obj) {
        if (intError == 0) {
            [_aryBook addObjectsFromArray:weakBaseParam.resultArray];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"获取数据失败");
        }
        
        if (weakSelf.progressTest) {
            [weakSelf.progressTest hide:YES];
        }
    };
    
    NSMutableDictionary* dicParam=[NSMutableDictionary createParamDic];
    [dicParam setActionID:DEF_ACTIONID_BOOKACTION strcmd:DEF_ACTIONIDCMD_GETBOOKCHAPTERLIST];
    [dicParam setParam:baseparam];
    
    [SharedControl excute:dicParam];
    [self showLoading];
}


-(void)showLoading {
    if (self.progressTest == nil) {
        self.progressTest = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self.progressTest show:YES];
    self.progressTest.labelText = @"加载中...";
    self.progressTest.mode = MBProgressHUDModeIndeterminate;//可以显示不同风格的进度；
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowCount=0;

    if (_aryBook) {
        rowCount = [_aryBook count];
    }
    return rowCount;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [_bookModel setCurChapter:indexPath.row];
    ChapterDetailViewController *destination = [segue destinationViewController];
    destination.bookModel = _bookModel;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chapterNameCell" forIndexPath:indexPath];

    BCTBookChapterModel *bookchaptermodel = [_aryBook objectAtIndex:indexPath.row];
    
    cell.textLabel.text = bookchaptermodel.title;
    return cell;
}

@end
