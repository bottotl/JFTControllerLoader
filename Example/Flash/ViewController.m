//
//  ViewController.m
//  Flash
//
//  Created by 於林涛 on 2020/9/12.
//

#import "ViewController.h"
#import "JFTCommonLoader.h"

@interface ViewController ()
@property (nonatomic) JFTCommonLoader *loader;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    NSLog(@"start perform task");
    BFTask *task1 = [self.loader addRequiredBlock:^{
        [weakSelf work1];
    }];
    
    BFTask *task2 = [self.loader addRequiredBlock:^{
        [weakSelf work2];
    }];
    
    for (int i = 0; i < 100; i++) {
        [self.loader addAsynSerialBlock:^{
            [weakSelf asyncSerialWork:i];
        }];
    }
    
    for (int i = 0; i < 100; i++) {
        [self.loader addAsynCurrentBlock:^{
            [weakSelf asyncCurrentWork:i];
        }];
    }
    
    [[BFTask taskForCompletionOfAllTasks:@[task1, task2]] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        [weakSelf.loader markAsRequiredTaskFinished];
        return t;
    }];
    
    NSLog(@"after perform task");
}

- (JFTCommonLoader *)loader {
    if (!_loader) {
        _loader = [[JFTCommonLoader alloc] init];
    }
    return _loader;
}

- (void)work1 {
    NSLog(@"work1");
}

- (void)work2 {
    NSLog(@"work2");
}

- (void)asyncSerialWork:(NSUInteger)i {
    NSLog(@"[Serial] - %@", @(i));
}

- (void)asyncCurrentWork:(NSUInteger)i {
    NSLog(@"[CurrentWork] - %@", @(i));
}

@end
