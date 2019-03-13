@import Foundation;
@import CoreGraphics;
@import SpriteKit;

@interface Effect : NSObject

- (void)addSparksWithPos:(CGPoint)pos;
- (void)addSparksWithPos:(CGPoint)pos numSparks:(NSInteger)numSparks;
- (void)addSparksWithPos:(CGPoint)pos numSparks:(NSInteger)numSparks startVel:(CGPoint)startVel;
- (void)reset;

- (SKEmitterNode *)dropletEmitterWithSize:(CGSize)size;
- (SKNode *)targetDroplet;
- (SKEmitterNode *)targetSteam;

@end
