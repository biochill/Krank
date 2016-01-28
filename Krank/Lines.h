//
//  Lines.h

enum {
	LineTypeWhite,
	LineTypeBlack
};
typedef NSInteger LineType;

@interface Lines : SKNode

@property (nonatomic) LineType lineType;

- (void)clear;
- (void)addLineFrom:(CGPoint)p1 to:(CGPoint)p2;

@end
