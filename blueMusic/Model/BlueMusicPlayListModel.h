//
//  BlueMusicPlayListModel.h
//  blueMusic
//
//  Created by biubiu on 2018/7/3.
//  Copyright © 2018年 biubiublue. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BlueMusicPlayListModel : JSONModel
@property (strong, nonatomic) NSString<Optional>* cover_img_url;
@property (strong, nonatomic) NSString<Optional>* title;
@property (strong, nonatomic) NSString<Optional>* pl_id;
@property (strong, nonatomic) NSString<Optional>* source_url;

@property (strong, nonatomic) NSString<Optional>* personname;
@property (strong, nonatomic) NSString<Optional>* author;

@property (strong, nonatomic) NSString<Optional>* playnum;
@property (strong, nonatomic) NSString<Optional>* playnumstr;
@end
