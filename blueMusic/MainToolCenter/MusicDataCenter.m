//
//  MusicDataCenter.m
//  blueMusic
//
//  Created by lining on 2018/7/5.
//  Copyright © 2018年 biubiublue. All rights reserved.
//

#import "MusicDataCenter.h"
#import "MusicModel.h"
#import "BlueMusicPlayListModel.h"

#define DOCUMENTS_FOLDER_MUSIC @"music" //你定义的audio对应的文件目录
#define DOCUMENTS_FOLDER_VEDIO @"" //你定义的vedio对应的文件目录

static MusicDataCenter *musicDataCenter=nil;

@interface MusicDataCenter()
@property(nonatomic,strong)NSMutableArray *musicModelArray;
@property(nonatomic,strong)NSMutableArray *musicPlayListArray;

@end

@implementation MusicDataCenter
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (musicDataCenter == nil) {
            musicDataCenter = [[MusicDataCenter alloc]init];
            musicDataCenter.musicModelArray =[NSMutableArray array];
            musicDataCenter.musicPlayListArray =[NSMutableArray array];
            [musicDataCenter checkDirectories];
        }
    });
    
    return musicDataCenter;
}

-(void)updatepldata:(NSArray*)plarray
{
    if (plarray.count>0)
    {
        [self.musicPlayListArray addObjectsFromArray:plarray];
    }
    
}

-(void)updateMusicdata:(NSArray*)plarray
{
    if (plarray.count>0)
    {
        [self.musicModelArray removeAllObjects];
        self.musicModelArray = plarray.mutableCopy;
    }
}

-(BlueMusicPlayListModel *)musicPlayListWithIndex:(NSInteger)index
{
    
    if (index<self.musicPlayListArray.count)
    {
        return self.musicPlayListArray[index];
    }
    return nil;
}

-(NSInteger)musicPLDataCount
{
    return self.musicPlayListArray.count;
}

-(NSInteger)musicDataCount
{
    return self.musicModelArray.count;
}

-(MusicModel *)musicWithIndex:(NSInteger)index
{
    if (index<self.musicModelArray.count)
    {
        return self.musicModelArray[index];
    }
    return nil;
    
}

-(NSMutableArray *)currentMusicPlayList
{
    return self.musicModelArray.mutableCopy;
}

-(NSString *)localMusicPathWithName:(NSString*)name
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"/music"];
    
    NSString *s = [NSString stringWithFormat:@"%@/%@",newFilePath,name];
    return s;
}

-(NSString *)localMusicPathFolder
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *createPath = [documentsPath stringByAppendingPathComponent:@"/music"];
    return createPath;
}

//检查music文件夹是否存在，不存在就创建一个
- (void)checkDirectories
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folder = [self localMusicPathFolder];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folder
                                        isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    
    {
        
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folder
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:nil];
        
        if(!bCreateDir)
        {
            
            NSLog(@"Create Muisc Directory Failed.");
            
        }
    }
   
}
@end
