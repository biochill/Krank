//
//  Anchor.m
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Anchor.h"
#import "Globals.h"
#import "Particles.h"

@interface Anchor ()
{
	CGFloat _anglefac;
//	NSMutableArray *_dots;
}
@property (nonatomic, strong) NSMutableDictionary *actionCounters;
@end

@implementation Anchor

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)aColor maxLinks:(NSInteger)maxLinksValue
{
	Anchor *anchor = [[Anchor alloc] initWithPos:aPos color:aColor maxLinks:maxLinksValue];
	[k.particles addAnchor:anchor];
	return anchor;
}

- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)aColor maxLinks:(NSInteger)maxLinks
{
	if ((self = [super initWithPos:aPos color:aColor imageName:@"dot32_d" maxLinks:maxLinks]))
	{
		_actionCounters = [[NSMutableDictionary alloc] initWithCapacity:10];
		self.imass = 0;
		self.isAnchor = YES;
//		angle = -M_PI/2;
		_anglefac = [k.particles numberOfAnchors] & 1 ? 1 : -1;

		self.zPosition = -30;
		self.physicsBody.fieldBitMask = 0; // does not react to magnets

		NSString *dotImageName = [NSString stringWithFormat:@"dot20_d_%@", aColor];
//		CGSize anchorSize = self.size;

		for (int i = 0; i < self.maxLinks; ++i) {
			Sprite *dot = [[Sprite alloc] init];
			[dot setImageName:dotImageName];
			dot.name = [NSString stringWithFormat:@"%d", i];
//			CGFloat length = anchorSize.width/2 + dot.size.width/2 + 1;
//			CGPoint dir = CGPointWithAngle(i*2*M_PI/maxLinks + angle, length);
//			dot.pos = CGPointAdd(self.pos, dir);
			[self addChild:dot];
		}
	}
	return self;
}

- (void)startActions
{
	for (int i = 0; i < self.maxLinks; ++i) {
		Sprite *dot = (Sprite *)[self childNodeWithName:[NSString stringWithFormat:@"%d", i]];
		CGFloat length = self.size.width/2 + 1 + dot.size.width/2;
		CGFloat angle = -(-M_PI/2 + i*2*M_PI/self.maxLinks);

		// Somehow UIBezierPath does not like an arc from <angle> to <angle+2*M_PI> so we split it in two half arcs.
		UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:length startAngle:angle endAngle:angle + M_PI clockwise:_anglefac > 0];
		[path addArcWithCenter:CGPointZero radius:length startAngle:angle + M_PI endAngle:angle + 2*M_PI clockwise:_anglefac > 0];
		[dot runAction:[SKAction repeatActionForever:[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:15]]];
	}
}

- (Chain *)linkWithKey:(NSString *)key
{
	for (Chain *link in self.links)
	{
		if ([link.description isEqualToString:key]) return link;
	}
	return nil;
}

- (void)onFrame:(NSTimeInterval)delta
{
	for (NSString *key in _actionCounters.allKeys)
	{
		if ([key isEqualToString:self.colorName]) {
			if (![self checkComplete]) {
				[_actionCounters removeObjectForKey:key];
				continue;
			}
		}
		
		if (![key isEqualToString:self.colorName]) {
			
			Chain *ckey = [self linkWithKey:key];
			
			if (!ckey) {
				[_actionCounters removeObjectForKey:key];
				continue;
			}
			
			int anchorCount = 0;
			for (Chain *c in ckey.chain) if (c.isAnchor) ++anchorCount;
			if (anchorCount < 2) {
				[_actionCounters removeObjectForKey:key];
				continue;
			}
		}

		NSNumber *counter = _actionCounters[key];
		NSTimeInterval counterValue = counter.doubleValue + delta;
		_actionCounters[key] = @(counterValue);

		if (counterValue > 3)
		{
			// Anchors are 3 seconds in good state -> finish them

			NSMutableSet *chains = [NSMutableSet setWithCapacity:10];
			
			if ([key isEqualToString:self.colorName])
			{
				NSMutableSet *allAnchors = [k.particles anchorsForColor:self.colorName];
				for (Anchor *a in allAnchors)
				{
					for (Chain *l in a.links)
					{
						if (![chains containsObject:l.chain])
							[chains addObject:l.chain];
					}
				}
				[allAnchors removeAllObjects];
			}
			else
			{
				Chain *ckey = (Chain *)[self linkWithKey:key];
				if (ckey) [chains addObject:ckey.chain];
			}
			
			for (NSMutableArray *ch in chains)
			{
				// Get the first/only two anchors
				Chain *a0 = nil;
				Chain *a1 = nil;
				for (Chain *c in ch)
				{
					if (c.isAnchor)
					{
						if (!a0)
						{
							a0 = c;
						}
						else if (!a1)
						{
							a1 = c;
							break;
						}
					}
				}
				
				NSAssert(a0 && a1, @"Need two anchors");
				
				CGPoint center = CGPointAddMult(a0.position, CGPointSub(a1.position, a0.position), 0.5);

				// Move chains outward
				for (Chain *c in ch) {
					if (!c.isAnchor) {
						CGPoint vel = CGPointAdd(CGPointAdd(CGPointSub(c.position, center), CGPointSub(c.position, a0.position)), CGPointSub(c.position, a1.position));
						CGPoint impulse = CGPointAddMult(c.vel, CGPointNorm(vel), 500*k.displayScaleFactor);
						[c applyImpulse:impulse];
					}
				}

				// Unlink all chains
				NSArray *unlinkArray = [NSArray arrayWithArray:ch];
				for (Chain *c in unlinkArray)
				{
					if (!c.isAnchor)
					{
						[c unlink];
					}
				}
			}

			// Remove anchors
			if ([key isEqualToString:self.colorName])
			{
				NSMutableSet *allanchors = [k.particles anchorsForColor:self.colorName];
				
				for (Anchor *a in allanchors)
				{
					[a remove];
				}
				
				[allanchors removeAllObjects];
			}

			if (![k.level checkExit])
				[k.sound play:@"anchor_action"];
			
		}
		else if (floor(counterValue) > floor((counterValue-delta)))
		{
			[k.sound play:@"magnet_start"];
		}
	}

	// rotation
//	angle += anglefac*M_PI*delta/8;
//	CGFloat anchorRadius = self.size.width/2 + 1;
//	for (int i = 0; i < self.maxLinks; ++i) {
//		Sprite *dot = _dots[i];
//		CGFloat length = anchorRadius + dot.size.width/2;
//		CGPoint dir = CGPointWithAngle(angle + i*2*M_PI/self.maxLinks, length);
//		dot.pos = CGPointAdd(self.pos, dir);
//		[dot render];
//	}
}

- (BOOL)checkComplete
{
	//
	NSMutableSet *anchors = [k.particles anchorsForColor:self.colorName];
	for (Anchor *a in anchors) {
		if ([a hasFreeLink]) {
			return NO;
		}
	}

	for (Anchor *a in anchors)
	{
		for (Chain *link in a.links)
		{
			if ([Anchor colorsInChain:link.chain] > 1) {
				return NO;
			}
			int anchorCount = 0;
			for (Chain *c in link.chain) if (c.isAnchor) ++anchorCount;
			if (anchorCount < 2) {
				return NO;
			}
		}
	}

	return YES;
}

- (BOOL)checkExplode
{
	if (self.links.count == self.maxLinks)
	{
		if ([self checkComplete])
		{
			[_actionCounters removeAllObjects];
			_actionCounters[self.colorName] = @(0.0);
			return YES;
		}
	}
	
	for (Chain *link in self.links)
	{
		int anchorCount = 0;
		for (Chain *c in link.chain) if (c.isAnchor) ++anchorCount;
		
		if (anchorCount == 2)
		{
			if ([Anchor colorsInChain:link.chain] > 1)
			{
				NSString *linkhash = [link description];
				if (!_actionCounters[linkhash])
				{
					_actionCounters[linkhash] = @(0.0);
					return YES;
				}
			}
		}
	}
	
	return NO;
}

+ (NSUInteger)colorsInChain:(NSArray *)aChain
{
	NSMutableSet *colors = [NSMutableSet setWithCapacity:10];
	for (Chain *c in aChain) [colors addObject:c.colorName]; // only adds to set if not already in set
	return colors.count;
}

- (void)remove
{
	[k.particles removeAnchor:self];
	[k.effects addSparksWithPos:self.position];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"[%@: id=%d color=%@]", [self class], self.identifier, self.colorName];
}

@end
