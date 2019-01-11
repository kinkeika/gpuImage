//
//  NSString+LXDFile.m
//  UIImageCatagery
//
//  Created by 恒悦科技 on 2018/11/5.
//  Copyright © 2018年 李响. All rights reserved.
//

#import "NSString+LXDFile.h"

@implementation NSString (LXDFile)

#pragma mark - 文件路径创建
-(NSString *)fileWithDocument{
    
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];    
    return [self createFilePath:[docsdir stringByAppendingPathComponent:self]];
}

-(NSString *)fileWithCache{
    
  NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  return  [self createFilePath:[docsdir stringByAppendingPathComponent:self]];
}

#pragma mark - private 私有方法
-(NSString *)createFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {
        
        // 在 Document 目录下创建一个 head 目录
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

@end
