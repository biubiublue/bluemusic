//
//  PLDetailVC.h
//  blueMusic
//
//  Created by biubiublue on 2018/7/3.
//  Copyright © 2018年 biubiublue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlueMusicPlayListModel;
@interface PLDetailVC : UIViewController
-(void)updateplModel:(BlueMusicPlayListModel*)plmodel;
-(void)trytogetsongs;
@end
