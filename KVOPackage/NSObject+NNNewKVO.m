//
//  NSObject+NNNewKVO.m
//  KVOPackage
//
//  Created by qiaodata on 2018/9/2.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import "NSObject+NNNewKVO.h"
#import <objc/runtime.h>

typedef void(^deallocBlock)(void);
//成员对象
@interface NNKVOController : NSObject

//被监听的对象
@property (nonatomic, strong) NSObject *observerObj;
@property (nonatomic, strong) NSMutableArray <deallocBlock>*blockArr;

@end

@implementation NNKVOController

- (NSMutableArray *)blockArr {
    if (!_blockArr) {
        _blockArr = [NSMutableArray array];
    }
    return _blockArr;
}

- (void)dealloc {
    //对observerObj移除
    NSLog(@"kvoController dealloc");
    [_blockArr enumerateObjectsUsingBlock:^(deallocBlock  _Nonnull block, NSUInteger idx, BOOL * _Nonnull stop) {
        block();
    }];
}

@end

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary <NSString *,kvoBlock> *dict;
@property (nonatomic, strong) NSMutableDictionary <NSString *,NSMutableArray *> *kvoDict;
@property (nonatomic, strong) NNKVOController *kvoController;

@end

@implementation NSObject (NNNewKVO)

- (void)nnObserver:(NSObject *)object keyPath:(NSString *)keyPath block:(kvoBlock)block {
     self.dict[keyPath] = block;
    //self持有了kvoController
    self.kvoController.observerObj = object;
    //__unsafe_unretained不会置为nil，weakSelf释放之后，仍指向之前内容为野指针
    //__weak会置为nil
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.kvoController.blockArr addObject:^{
        [object removeObserver:weakSelf forKeyPath:keyPath];
    }];
    
    [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
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

- (NNKVOController *)kvoController {
    NNKVOController *tmpController = objc_getAssociatedObject(self, @selector(kvoController));
    if (!tmpController) {
        tmpController = [[NNKVOController alloc] init];
        objc_setAssociatedObject(self, @selector(kvoController), tmpController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tmpController;
}

@end
