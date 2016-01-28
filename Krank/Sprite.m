#import "Sprite.h"
#import "Globals.h"


@implementation Sprite

//- (instancetype)init
//{
//	if ((self = [super init]))
//	{
//	}
//	return self;
//}

- (instancetype)initWithPos:(CGPoint)pos
{
// pos in UIView coordinates
	if ((self = [super init]))
	{
		self.pos = pos;
	}
	return self;
}

- (void)setImageName:(NSString *)imageName
{
	SKTexture *texture = [k.atlas textureNamed:imageName];
	self.texture = texture;
	self.size = [texture size];
	self.name = imageName;
}

- (CGPoint)pos
{
	return [k.world convertFromScenePoint:self.position];
}

- (void)setPos:(CGPoint)pos
{
	self.position = [k.world convertToScenePoint:pos];
}

@end
