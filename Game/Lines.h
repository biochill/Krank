//
//  Lines.h
//

@import Foundation;
@import SpriteKit;
@import CoreGraphics;

typedef NS_ENUM(NSInteger, LineType) {
	LineTypeWhite,
	LineTypeBlack
};

@interface Lines : SKNode

@property (nonatomic) LineType lineType;

- (void)clear;
- (void)addLineFrom:(CGPoint)p1 to:(CGPoint)p2;

@end
