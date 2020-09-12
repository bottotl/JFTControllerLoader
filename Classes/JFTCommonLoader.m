//
//  JFTCommonLoader.m
//  Flash
//
//  Created by 於林涛 on 2020/9/12.
//
#import "JFTLoaderQueuePool.h"
#import "JFTCommonLoader.h"

@interface JFTCommonLoader ()
@property (nonatomic) JFTLoaderQueuePool *pool;
@end

@implementation JFTCommonLoader

- (instancetype)init {
    if (self = [super init]) {
        _pool = [JFTLoaderQueuePool new];
        _pool.asynCurrentQueue.suspended = YES;
        _pool.asynSerialQueue.suspended = YES;
    }
    return self;
}

- (BFTask *)addRequiredBlock:(void (^)(void))block {
    if (!block) {
        return [BFTask taskWithResult:@(YES)];
    }
    
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    [self.pool.mainQueue addOperationWithBlock:^{
        block();
        [tcs setResult:@(YES)];
    }];
    return tcs.task;
}

- (void)markAsRequiredTaskFinished {
    self.pool.asynSerialQueue.suspended = NO;
    self.pool.asynCurrentQueue.suspended = NO;
}

- (void)addAsynSerialBlock:(void (^)(void))block {
    [self.pool.asynSerialQueue addOperationWithBlock:block];
}

- (void)addAsynCurrentBlock:(void (^)(void))block {
    [self.pool.asynCurrentQueue addOperationWithBlock:block];
}

@end
