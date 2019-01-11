//
//  NSString+LXDFile.h
//  UIImageCatagery
//
//  Created by 恒悦科技 on 2018/11/5.
//  Copyright © 2018年 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LXDFile)

#pragma mark - Get sandbox path
-(NSString *)fileWithDocument;
-(NSString *)fileWithCache;

@end
