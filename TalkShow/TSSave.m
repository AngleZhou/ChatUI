//
//  TSSave.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSSave.h"

@implementation TSSave

+ (BOOL)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
        return NO;
    }
    return YES;
}

// 得到缓存目录
+ (NSURL *)fileUrlWithFileName:(NSString *)fileName {
    NSString *filePath = [self filePathWithFileName:fileName];
    return [NSURL fileURLWithPath:filePath];
}

+ (NSString *)filePathWithFileName:(NSString *)fileName {
    // 先得到本地document目录
    NSString * documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  firstObject];
    
    
    //audio folder path
    NSString *audioDirectory = [NSString stringWithFormat:@"%@/%@", documentDirectory,@"audio"];
    //check user folder exist or not
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:audioDirectory isDirectory:&isDir];
    if (!exists) {
        /* file note exists, create */
        [self createDirectory:@"audio" atFilePath:documentDirectory];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", audioDirectory, fileName];
    return filePath;
}


// 写入到本地
+ (void)storeToDocumentWithData:(NSData *)data fileName:(NSString *)name
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString * filePath = [self filePathWithFileName:name];
        
        // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件
        if (![manager fileExistsAtPath:filePath]) {
            [manager createFileAtPath:filePath contents:data attributes:nil];
        }
        
    });
    
}

@end