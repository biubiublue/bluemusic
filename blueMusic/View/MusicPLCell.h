//
//  MusicPLCell.h
//  blueMusic
//
//  Created by didi on 2018/7/3.
//  Copyright © 2018年 biubiublue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueMusicPlayListModel;
@interface MusicPLCell : UITableViewCell
-(void)configModel:(BlueMusicPlayListModel*)plModel;
@end
