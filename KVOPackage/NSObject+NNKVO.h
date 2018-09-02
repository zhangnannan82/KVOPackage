//
//  NSObject+NNKVO.h
//  KVOPackage
//
//  Created by 张楠 on 2018/8/5.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^kvoBlock)(void);
@interface NSObject (NNKVO)

- (void)nnObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(kvoBlock)block;

@end
