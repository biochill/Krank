//
//  Chain.h

#import "Particle.h"

@interface Chain : Particle

@property (nonatomic, strong) NSMutableArray *links, *chain;
@property (nonatomic, strong) NSMutableSet *springs;
@property (nonatomic) BOOL isAnchor;
@property (nonatomic) NSInteger maxLinks;
@property (nonatomic, readonly) CGFloat maxSpringLength;

+ (id)addWithPos:(CGPoint)aPos color:(NSString *)aColor;
- (id)initWithPos:(CGPoint)aPos color:(NSString *)aColor;
- (id)initWithPos:(CGPoint)aPos color:(NSString *)aColor imageName:(NSString *)imageName maxLinks:(NSInteger)maxLinksValue;
- (BOOL)hasFreeLink;
- (void)traverseChain:(Chain *)source chains:(NSMutableArray *)chains;
- (void)unlink;
- (BOOL)link:(Chain *)other;
- (void)releaseChain;

@end
