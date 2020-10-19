//
//  JFTLoaderQueuePool.m
//  JFTControllerLoader
//
//  Created by 於林涛 on 2020/9/12.
//

#import "JFTLoaderQueuePool.h"

@implementation JFTLoaderQueuePool

+ (instancetype)sharedPool {
    static dispatch_once_t onceToken;
    static JFTLoaderQueuePool *_sharedPool = nil;
    dispatch_once(&onceToken, ^{
        _sharedPool = [JFTLoaderQueuePool new];
    });
    return _sharedPool;
}

- (instancetype)init {
    if (self = [super init]) {
        _mainQueue = [NSOperationQueue mainQueue];
        _lowPriorityMainQueue = [NSOperationQueue mainQueue];
        _asynSerialQueue = [NSOperationQueue new];
        _asynSerialQueue.maxConcurrentOperationCount = 1;
        _asynCurrentQueue = [NSOperationQueue new];
        _asynCurrentQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    }
    return self;
}

@end
