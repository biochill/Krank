@import SpriteKit;

@class Spring;
@class Magnet;
@class Anchor;
@class Particle;

@interface Particles : NSObject <SKPhysicsContactDelegate>

@property (nonatomic, strong, readonly) NSArray *parts;
@property (nonatomic, readonly) NSUInteger numberOfMagnets;
@property (nonatomic, readonly) NSUInteger numberOfAnchors;

+ (void)stoneCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius;
+ (void)stoneCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius start:(double)start;

+ (void)ballCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius;
+ (void)ballCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius start:(double)start;

+ (void)chainCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius;
+ (void)chainCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num radius:(CGFloat)radius start:(CGFloat)start;
+ (void)chainCircle:(CGPoint)pos color:(NSString *)color num:(NSInteger)num xRadius:(CGFloat)xRadius yRadius:(CGFloat)yRadius start:(CGFloat)start;

- (void)addParticle:(Particle *)aPart;
- (void)addSpring:(Spring *)aSpring;
- (void)addMagnet:(Magnet *)magnet;
- (void)removeMagnet:(Magnet *)magnet;
- (void)removeSpring:(Spring *)spring;
- (void)addAnchor:(Anchor *)anchor;
- (void)removeAnchor:(Anchor *)anchor;

- (void)reset;
- (void)onFrame:(NSTimeInterval)delta;
- (void)drawLines;
- (void)startActions;
- (NSMutableSet *)anchorsForColor:(NSString *)color;

@end
