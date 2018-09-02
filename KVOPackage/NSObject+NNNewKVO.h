//
//  NSObject+NNNewKVO.h
//  KVOPackage
//
//  Created by qiaodata on 2018/9/2.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kvoBlock)(void);
@interface NSObject (NNNewKVO)

- (void)nnObserver:(NSObject *)object keyPath:(NSString *)keyPath block:(kvoBlock)block;

@end
