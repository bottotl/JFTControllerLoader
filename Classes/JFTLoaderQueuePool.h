//
//  JFTLoaderQueuePool.h
//  JFTControllerLoader
//
//  Created by 於林涛 on 2020/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFTLoaderQueuePool : NSObject

+ (instancetype)sharedPool;

@property (nonatomic) NSOperationQueue *mainQueue;
@property (nonatomic) NSOperationQueue *asynSerialQueue;
@property (nonatomic) NSOperationQueue *asynCurrentQueue;

@end

NS_ASSUME_NONNULL_END
