#import "World.h"
#import "Globals.h"
#import "KrankViewController.h"

@implementation World

- (id)initWithRect:(CGRect)aRect
{
	if ((self = [super init])) {
		[self recalculateGeometry:aRect];
	}
	return self;
}

- (CGPoint)center
{
	return CGPointMake(CGRectGetMidX(_rect), CGRectGetMidY(_rect));
}

- (void)setBackground:(NSString *)imageName
{
	[self setBackground:imageName alpha:1 wantQuadImage:YES];
}

- (void)setBackground:(NSString *)imageName alpha:(CGFloat)alpha
{
	[self setBackground:imageName alpha:alpha wantQuadImage:YES];
}

- (void)setBackground:(NSString *)background alpha:(CGFloat)alpha wantQuadImage:(BOOL)wantQuadImage
{
	// Images are in JPG format in assets catalog
	NSString *fileName = [background stringByAppendingPathExtension:@"jpg"];
	UIImage *image = [UIImage imageNamed:fileName];
	if (wantQuadImage) {
		image = [Tools makeLandscapeQuadImage:image size:k.viewController.scene.frame.size alpha:alpha];
	}

	[k.viewController.scene setBackgroundImage:image alpha:alpha];
}

- (void)recalculateGeometry:(CGRect)aRect
{
	_rect = aRect;

	_left = _rect.origin.x;
	_top = _rect.origin.y;
	_right = _rect.origin.x + _rect.size.width - 1;
	_bottom = _rect.origin.y + _rect.size.height - 1;

//	_forceFactor = 1.0-clamp((1024-_rect.size.height)/1800.0, -0.15, 0.4);
//	_forceFactor = 1.0-fclamp((_rect.size.height*0.25)/1800.0, 0, 0.4); // should also work with Apple TV = 1920x1080
}

- (CGPoint)convertFromScenePoint:(CGPoint)scenePoint
{
	return [k.viewController.gameView convertPoint:scenePoint fromScene:k.viewController.scene];
}

- (CGPoint)convertToScenePoint:(CGPoint)scenePoint
{
	return [k.viewController.gameView convertPoint:scenePoint toScene:k.viewController.scene];
}

@end
