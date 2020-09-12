//
//  JFTCommonLoader.h
//  Flash
//
//  Created by 於林涛 on 2020/9/12.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFTCommonLoader : NSObject

- (BFTask *)addRequiredBlock:(void (^)(void))block;

- (void)markAsRequiredTaskFinished;

- (void)addAsynSerialBlock:(void (^)(void))block;
- (void)addAsynCurrentBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
