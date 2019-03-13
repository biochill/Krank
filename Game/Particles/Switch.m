//
//  Switch.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Switch.h"
#import "Globals.h"


@interface Switch ()
@property (nonatomic) NSInteger anchor;
@property (nonatomic, strong) SKNode *titleLabel;
@property (nonatomic, strong) SKFieldNode *repelField;
@property (nonatomic) NSTimeInterval lastCollisionTime;
@end


@implementation Switch

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos
{
	return [Switch switchWithText:text anchor:anAnchor command:aCommand position:aPos font:k.largeFont];
}

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font
{
	NSString *imageName = (font == k.largeFont) ? @"menu" : @"menu_small";
	Switch *part = [[Switch alloc] initWithText:text anchor:anAnchor command:aCommand position:aPos font:font imageName:imageName color:@"white"];
	return part;
}

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor
{
	Switch *part = [[Switch alloc] initWithText:text anchor:anAnchor command:aCommand position:aPos font:font imageName:imageName color:aColor];
//	part.menuRepelEnabled = YES;
	return part;
}

- (instancetype)initWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor
{
	if ((self = [super initWithPos:pos color:aColor imageName:imageName player:IsNotAPlayer])) {
		_command = aCommand;
		_anchor = anAnchor;
		_lastCollisionTime = 0;
		self.imass = 0;
		self.name = text;
		self.userInteractionEnabled = YES;

		// Inverted anchor for text
		NSInteger textAnchor = ANCHOR_CENTER;
		switch (_anchor) {
			case ANCHOR_LEFT:   textAnchor = ANCHOR_RIGHT; break;
			case ANCHOR_RIGHT:  textAnchor = ANCHOR_LEFT; break;
			case ANCHOR_TOP:    textAnchor = ANCHOR_BOTTOM; break;
			case ANCHOR_BOTTOM: textAnchor = ANCHOR_TOP; break;
		}

		CGPoint textPos = CGPointZero; //self.pos;
		CGFloat r = self.radius;
		//DLog(@"adjusting text for switch '%s' by (%f,%f)", [textView.text UTF8String], dx, dy);
		switch (_anchor) {
			case ANCHOR_RIGHT:
				textPos.x += r*1.25;
				break;
			case ANCHOR_LEFT:
				textPos.x -= r*1.25;
				break;
			case ANCHOR_TOP:
				textPos.y += r;
				break;
			case ANCHOR_BOTTOM:
				textPos.y -= r;
				break;
			case ANCHOR_CENTER:
				break;
		}

#if TARGET_OS_TV
		self.focusBehavior = SKNodeFocusBehaviorFocusable;
#endif

		_titleLabel = [Tools labelWithText:text pos:textPos color:[UIColor whiteColor] anchor:textAnchor font:font];
		_titleLabel.position = textPos; // position without conversion because it's relative to its parent
		[self addChild:_titleLabel];
	}
	return self;
}

- (void)dealloc
{
	[_titleLabel removeFromParent];
}

#if TARGET_OS_TV
- (UIFocusSoundIdentifier)soundIdentifierForFocusUpdateInContext:(UIFocusUpdateContext *)context
{
	return k.sound.soundFXEnabled ? SoundFocusIdentifierMenuPart : UIFocusSoundIdentifierNone;
}
#endif

- (void)collisionAction
{
	[super collisionAction];

#if TARGET_OS_TV

	[k.level command:self.command];

	if (self.isSoundEnabled) {
		[k.sound play:@"wall" volume:1.0];
	}

#else

	// Prevent rapid collisions in menus
	NSTimeInterval now = [NSDate date].timeIntervalSinceReferenceDate;
	if (now - self.lastCollisionTime > 0.7) {
		self.lastCollisionTime = now;
		[k.level command:self.command];
	}

	if (self.isSoundEnabled) {
		[k.sound play:@"part" volume:1.0];
	}

#endif
}

- (void)setMenuRepelEnabled:(BOOL)menuRepelEnabled
{
	if (menuRepelEnabled) {

		[self.repelField removeFromParent];

		SKFieldNode *field = [SKFieldNode radialGravityField];
		field.categoryBitMask = PHYSICS_FIELD_PLAYER;
		field.falloff = 2;
		field.strength = -1.2;
		field.name = @"Repel";
		[self addChild:field];

		self.repelField = field;

	} else {

		[self.repelField removeFromParent];
		self.repelField = nil;
	}
}

- (BOOL)isMenuRepelEnabled
{
	return self.repelField != nil;
}

#if TARGET_OS_TV

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
	KrankScene *scene = (KrankScene *)self.scene;

	if (context.nextFocusedItem == self) {

		scene.focusedSwitch = self;

		[coordinator addCoordinatedFocusingAnimations:^(id<UIFocusAnimationContext>  _Nonnull animationContext) {
			[scene animateFocusToPosition:self.position radius:self.radius selected:NO duration:animationContext.duration animateOut:NO];
		} completion:NULL];

	} else {

		if (scene.focusedSwitch == self) {
			scene.focusedSwitch = nil;
		}

	}
}

#endif

@end
