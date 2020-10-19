//
//  JFTCommonLoader.m
//  Flash
//
//  Created by 於林涛 on 2020/9/12.
//
#import "JFTLoaderQueuePool.h"
#import "JFTCommonLoader.h"

void myRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

@interface JFTCommonLoader ()
@property (nonatomic) JFTLoaderQueuePool *pool;
@property (nonatomic) CFRunLoopObserverRef runloopObserver;
- (void)startProcessLowPrioritTask;
- (void)endProcessLowPrioritTask;
@end

@implementation JFTCommonLoader

- (instancetype)init {
    if (self = [super init]) {
        _pool = [JFTLoaderQueuePool new];
        _pool.asynCurrentQueue.suspended = YES;
        _pool.asynSerialQueue.suspended = YES;
        _pool.lowPriorityMainQueue.suspended = YES;
    }
    return self;
}

- (BFTask *)addRequiredBlock:(void (^)(void))block {
    if (!block) {
        return [BFTask taskWithResult:@(YES)];
    }
    __auto_type iBlock = ^(void) {
        CFTimeInterval startTime = CACurrentMediaTime();
        if (block) {
            block();
        }
        NSLog(@"cost %@ms", @((CACurrentMediaTime() - startTime) * 1000) );
    };
    BFTaskCompletionSource *tcs = [BFTaskCompletionSource taskCompletionSource];
    [self.pool.mainQueue addOperationWithBlock:^{
        iBlock();
        [tcs setResult:@(YES)];
    }];
    return tcs.task;
}

- (void)markAsRequiredTaskFinished {
    [self addRunLoopObserver];
    self.pool.asynSerialQueue.suspended = NO;
    self.pool.asynCurrentQueue.suspended = NO;
}

- (void)addAsynSerialBlock:(void (^)(void))block {
    __auto_type iBlock = ^(void) {
        CFTimeInterval startTime = CACurrentMediaTime();
        if (block) {
            block();
        }
        NSLog(@"cost %@ms", @((CACurrentMediaTime() - startTime) * 1000) );
    };
    [self.pool.asynSerialQueue addOperationWithBlock:iBlock];
}

- (void)addAsynCurrentBlock:(void (^)(void))block {
    __auto_type iBlock = ^(void) {
        CFTimeInterval startTime = CACurrentMediaTime();
        if (block) {
            block();
        }
        NSLog(@"cost %@ms", @((CACurrentMediaTime() - startTime) * 1000) );
    };
    [self.pool.asynCurrentQueue addOperationWithBlock:iBlock];
}

- (void)addLowPrioritBlock:(void(^)(void))block {
    __auto_type iBlock = ^(void) {
        CFTimeInterval startTime = CACurrentMediaTime();
        if (block) {
            block();
        }
        NSLog(@"cost %@ms", @((CACurrentMediaTime() - startTime) * 1000) );
    };
    [self.pool.lowPriorityMainQueue addOperationWithBlock:iBlock];
}

- (void)startProcessLowPrioritTask {
    self.pool.lowPriorityMainQueue.suspended = NO;
}

- (void)endProcessLowPrioritTask {
    self.pool.lowPriorityMainQueue.suspended = YES;
}

- (void)addRunLoopObserver {
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    // the first observer
    CFRunLoopObserverContext context = {0, (__bridge void *) self, NULL, NULL, NULL};
    CFRunLoopObserverRef beginObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting | kCFRunLoopAfterWaiting, YES, LONG_MIN, &myRunLoopBeginCallback, &context);
    CFRetain(beginObserver);
    
    _runloopObserver = beginObserver;

    CFRunLoopRef runloop = [mainLoop getCFRunLoop];
    CFRunLoopAddObserver(runloop, beginObserver, kCFRunLoopCommonModes);
}

- (void)dealloc {
    CFRelease(_runloopObserver);
}

@end

void myRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    JFTCommonLoader *loader = (__bridge JFTCommonLoader *)info;
    if (activity == kCFRunLoopBeforeWaiting) {
        printf("==== kCFRunLoopBeforeWaiting\n");
        [loader startProcessLowPrioritTask];
    } else if (activity == kCFRunLoopAfterWaiting) {
        printf("kCFRunLoopAfterWaiting\n");
        [loader endProcessLowPrioritTask];
    } else {
        printf("******\n");
    }
}
