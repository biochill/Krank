@import SpriteKit;


@interface Sprite : SKSpriteNode

@property (nonatomic) CGPoint pos; // converts between SKScene and UIView coordinates

- (instancetype)initWithPos:(CGPoint)pos; // UIView coords
- (void)setImageName:(NSString *)imageName;

@end
