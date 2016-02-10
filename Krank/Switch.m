//
//  Switch.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Switch.h"
#import "Globals.h"
#import "MenuButton.h"


@interface Switch ()
@property (nonatomic) NSInteger anchor;
//@property (nonatomic) CGPoint textPos;
@property (nonatomic, strong) SKNode *titleLabel;
@end


@implementation Switch

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos
{
	return [Switch switchWithText:text anchor:anAnchor command:aCommand position:aPos font:k.largeFont];
}

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font
{
	NSString *imageName = (font == k.largeFont) ? @"menu" : @"menu_small";
	return [Switch switchWithText:text anchor:anAnchor command:aCommand position:aPos font:font imageName:imageName color:@"white" radius:-1];
}

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor radius:(int)aRadius
{
	Switch *part = [[Switch alloc] initWithText:text anchor:anAnchor command:aCommand position:aPos font:font imageName:imageName color:aColor radius:aRadius];
	return part;
}

- (instancetype)initWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor radius:(CGFloat)aRadius
{
	if ((self = [super initWithPos:pos color:aColor imageName:imageName player:IsNotAPlayer])) {
		_command = aCommand;
		_anchor = anAnchor;
		self.imass = 0;
		self.name = text;
		if (aRadius >= 0) self.radius = aRadius;

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

		[self setImageName:nil];

		NSString *fullImageName = [NSString stringWithFormat:@"%@_%@", imageName, aColor];
		UIImage *image = [UIImage imageNamed:fullImageName];

		_button = [MenuButton buttonWithType:UIButtonTypeCustom];
		[_button setImage:image forState:UIControlStateNormal];
		[_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventPrimaryActionTriggered];
		_button.frame = CGRectMake(0, 0, image.size.width + 80, image.size.height + 40);
		_button.center = pos;
		_button.accessibilityLabel = text;

		[k.viewController.menuButtonsView addSubview:_button];
		k.viewController.menuButtonsView.hidden = NO;

#endif

		_titleLabel = [Tools labelWithText:text pos:textPos color:[UIColor whiteColor] anchor:textAnchor font:font];
		_titleLabel.position = textPos; // position without conversion because it's relative to its parent
		[self addChild:_titleLabel];
	}
	return self;
}

- (void)dealloc
{
#if TARGET_OS_TV
	[_button removeFromSuperview];
#endif
	[_titleLabel removeFromParent];
}

- (void)buttonAction:(id)sender
{
	[self collisionAction];
}

- (void)collisionAction
{
	[super collisionAction];
	[k.level command:self.command];

/*	if (self.group != nil)
	{
		[self setImage:[Tools loadImage:@"menu_orange"]];
		
		UIImage *white = [Tools loadImage:@"menu_white"];
		
		for (Particle * particle in k.particles.parts)
		{
			if ([particle isKindOfClass:[Switch class]])
			{
				Switch * sw = (Switch*)particle;
				if (sw != self && [sw.group isEqualToString:self.group])
				{
					[sw setImage:white];
				}
			}
		}
	}
*/
	if (self.sound) {
		[k.sound play:@"part" volume:0.5];
	}
}

@end
