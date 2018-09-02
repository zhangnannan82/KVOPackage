//
//  NSObject+NNKVO.m
//  KVOPackage
//
//  Created by 张楠 on 2018/8/5.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import "NSObject+NNKVO.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary <NSString *,kvoBlock> *dict;
@property (nonatomic, strong) NSMutableDictionary <NSString *,NSMutableArray *> *kvoDict;

@end

@implementation NSObject (NNKVO)

- (void)nnObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(kvoBlock)block {
    observer.dict[keyPath] = block;
    
    //person dealloc的时机：1--成员变量，和nextviewController一起
    //2--封装时不太好监听nextviewController的释放，但是可以监听他的成员对象的dealloc方法
    
    
    //一个keyPath对应多个observer
    //一个observer对应多个keyPath
    NSMutableArray *array = self.kvoDict[keyPath];
    if (!array) {
        array = [NSMutableArray array];
        self.kvoDict[keyPath] = array;
    }
    [array addObject:observer];
    
    //若是KVO调用，则self.kvoDict、self.dict一定存在的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(nnDealloc)), class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc")));
    });
    
    //self是person
    //observer是nextViewcontroller,self释放时nextViewcontroller没有释放
    //需要person释放时释放掉观察者
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    //dealloc时。执行self removeObserver
    //通过runtime交换方法
    
}

- (void)nnDealloc {
    NSLog(@"nnDealloc");
    //替换的根类的方法，必须做相应判断，否则会无休止替换，并且会崩溃
    if ([self isKVO]) {
        [self.kvoDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *arr = self.kvoDict[key];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self removeObserver:obj forKeyPath:key];
            }];
        }];
    }
    [self nnDealloc];
}

- (BOOL)isKVO {
    if (objc_getAssociatedObject(self, @selector(kvoDict))) {
        return YES;
    }
    return NO;
}

//observer中调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //执行block
    //需要将keypath和blcok保存起来，在此处调用
    kvoBlock block = self.dict[keyPath];
    if (block) {
        block();
    }
}

//get方法
- (NSMutableDictionary *)dict {
    //NSString没有错误检查机制
    //selector有
    NSMutableDictionary *tmpDic = objc_getAssociatedObject(self, @selector(dict));
    if (!tmpDic) {
        tmpDic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(dict), tmpDic, OBJC_ASSOCIATION_RETAIN);
    }
    return tmpDic;
}

- (NSMutableDictionary<NSString *,NSMutableArray *> *)kvoDict {
    NSMutableDictionary *tmpDic = objc_getAssociatedObject(self, @selector(kvoDict));
    if (!tmpDic) {
        tmpDic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(kvoDict), tmpDic, OBJC_ASSOCIATION_RETAIN);
    }
    return tmpDic;
}

@end
