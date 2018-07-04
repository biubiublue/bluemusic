//
//  MusicListViewController.m
//
//
//  Created by biubiu on 15/11/2.
//  Copyright © 2015年 lining. All rights reserved.
//


#import "Headers.h"
#import "MusicListViewController.h"
#import "BlueMusicPlayListModel.h"
#import "MusicPLCell.h"
#import "PLDetailView.h"
#import "PLDetailVC.h"
#import "songPlayView.h"

@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation MusicListViewController
-(void)showHUDText:(NSString*)text  {
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText=text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin=10.f;
    hud.removeFromSuperViewOnHide=YES;
    hud.mode=MBProgressHUDModeText;
    [hud hide:YES afterDelay:0.3];
    
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark --tableview相关

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicPLCell * cell =[tableView dequeueReusableCellWithIdentifier:@"musiccell" forIndexPath:indexPath];
   
    
    BlueMusicPlayListModel *pp = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicPlayListWithIndex:indexPath.row];
    [cell configModel:pp];
    
    return cell;
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MusicDataHandle shareMusicDataHandleWithFinishBlock:nil].musicPLDataCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    /*
    MusicPlayerViewController *playVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"musicPlayer"];
    
    playVC.index=indexPath.row;
    [self presentViewController:playVC animated:YES completion:nil];
*/
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MusicPlayerViewController *songPVC = [[MusicPlayerViewController alloc]init];
    songPVC.index = indexPath.row;
    [self presentViewController:songPVC animated:YES completion:nil];
  //  [self.navigationController pushViewController:songPVC animated:YES];
    
    NSLog(@"点击播放");
     */
    /*
    PLDetailView *plVC = [[PLDetailView alloc]init];
    plVC.backgroundColor = [UIColor grayColor];
    CGFloat x,y,w,h;
    x = 0;
    y = 100;
    w = CGRectGetWidth(self.view.frame);
    h = CGRectGetHeight(self.view.frame)-y;
    CGRect r_rect = (CGRect){x,y,w,h};
    plVC.frame  = r_rect;
     BlueMusicPlayListModel *pp = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicPlayListWithIndex:indexPath.row];
    plVC.plModel = pp;
    [self.view addSubview:plVC];
    */
    PLDetailVC *plVC = [[PLDetailVC alloc]init];
    BlueMusicPlayListModel *pp = [[MusicDataHandle shareMusicDataHandleWithFinishBlock:nil] musicPlayListWithIndex:indexPath.row];
    plVC.plModel = pp;
    [self.navigationController pushViewController:plVC animated:YES];
}
#pragma mark 直接进入播放页面
-(void)nowPlaying:(UIBarButtonItem*)sender{
    
//    MusicPlayerViewController *songPVC = [[MusicPlayerViewController alloc]init];
//    songPVC.direct = YES;
//    [self presentViewController:songPVC animated:YES completion:nil];
//
    songPlayView *vv = [songPlayView getDefaultMusicPlayView];
 
    [self.view addSubview:vv];
}
#pragma mark --viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"正在播放" style:UIBarButtonItemStylePlain target:self action:@selector(nowPlaying:)];//为导航栏添加右侧按钮
    
    
    [self showProgress];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableview.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-104);
    self.tableview.delegate=self;
    self.tableview.dataSource=self;

    [self.tableview registerClass:[MusicPLCell class] forCellReuseIdentifier:@"musiccell"];
    [self.view addSubview:self.tableview];
    
    //去掉自动预留的64像素高度
    //默认是yes,ios7之后出现，会将UIScrollView及其子类自动向下偏移64单位
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self showProgress];
    typeof(self) weakSelf = self;
    [MusicDataHandle shareMusicDataHandleWithFinishBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [weakSelf.tableview reloadData];
            [self hideProgress];
            //NSLog(@"请求网络数据完毕-[self.tableview reloadData]");
             [weakSelf showHUDText:@"获取音乐成功。" ];
        
        
        });
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end









