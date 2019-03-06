//
//  Anchor.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Chain.h"

@interface Anchor : Chain

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)aColor maxLinks:(NSInteger)maxLinksValue;
+ (NSUInteger)colorsInChain:(NSArray *)aChain;

- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)aColor maxLinks:(NSInteger)maxLinksValue;
- (void)startActions;
- (void)onFrame:(NSTimeInterval)delta;
- (BOOL)checkComplete;
- (BOOL)checkExplode;
- (void)remove;
@end
