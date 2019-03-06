//
//  Chain.m

#import "Chain.h"
#import "Globals.h"
#import "Spring.h"
#import "Anchor.h"


@implementation Chain

+ (id)addWithPos:(CGPoint)aPos color:(NSString *)aColor
{
    Chain *chain = [[Chain alloc] initWithPos:aPos color:aColor];
	[k.particles addParticle:chain];
    return chain;
}

//------------------------------------------------------------------------------------------------------------------------

- (id)initWithPos:(CGPoint)aPos color:(NSString *)aColor imageName:(NSString *)imageName maxLinks:(NSInteger)maxLinksValue
{
	if ((self = [super initWithPos:aPos color:aColor imageName:imageName player:IsNotAPlayer]))
    {
		_isAnchor = NO;
		_maxLinks = maxLinksValue;
		_links = [[NSMutableArray alloc] initWithCapacity:10];
		_chain = [[NSMutableArray alloc] initWithCapacity:10];
		[_chain addObject:self]; // reference loop!
		_springs = [[NSMutableSet alloc] initWithCapacity:10];
	}
	return self;
}

//------------------------------------------------------------------------------------------------------------------------

- (id)initWithPos:(CGPoint)aPos color:(NSString *)aColor
{
	return [self initWithPos:aPos color:aColor imageName:@"dot28_d" maxLinks:2];
}

//------------------------------------------------------------------------------------------------------------------------

- (void)releaseChain
{
	// Call this before releasing self to break the reference loop!
	[_chain removeAllObjects];
	[_links removeAllObjects];
	[_springs removeAllObjects];
}

- (void)dealloc
{
	for (Spring *sp in _springs) {
		[k.particles removeSpring:sp];
	}
}

//------------------------------------------------------------------------------------------------------------------------

- (void)traverseChain:(Chain *)source chains:(NSMutableArray *)chains
{
	[chains addObject:self];
	if (self.isAnchor) return;
	if (_links.count)
    {
		if ([_links objectAtIndex:0] != source)
			[[_links objectAtIndex:0] traverseChain:self chains:chains];
		else if ((_links.count > 1) && ([_links objectAtIndex:1] != source))
			[[_links objectAtIndex:1] traverseChain:self chains:chains];
	}
}

//------------------------------------------------------------------------------------------------------------------------

- (BOOL)hasFreeLink
{
	return (maxl(0, _maxLinks - _links.count) > 0);
}

//------------------------------------------------------------------------------------------------------------------------

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@ id=%d color=%@]", [self class], self.identifier, self.colorName];
}

//------------------------------------------------------------------------------------------------------------------------

- (BOOL)link:(Chain *)other
{
	if (![self hasFreeLink] || ![other hasFreeLink]) return FALSE;
	if ([_chain containsObject:other]) return FALSE;

	NSMutableArray *anchors = [NSMutableArray arrayWithCapacity:10];
	for (Chain *c in _chain) if (c.isAnchor) [anchors addObject:c];

	if ([anchors count] && [other.chain containsObject:anchors[0]])
    {
        return NO;
    }

	[k.sound play:@"link"];

	[_links addObject:other];
	[other.links addObject:self];
    
	if (other.isAnchor)
		[_chain addObject:other];
	else
		[_chain addObjectsFromArray:other.chain];

	for (Chain *cp in _chain)
    {
		if (!cp.isAnchor && cp != self)
        {
            [cp.chain removeAllObjects];
            [cp.chain setArray:_chain];
        }
	}

	Spring *sp = [[Spring alloc] initWithLength:self.maxSpringLength part1:self part2:other oneWay:NO spring:70.0 damp:10.0];
	[k.particles   addSpring:sp];
	[_springs      addObject:sp];
	[other.springs addObject:sp];
        
	[anchors removeAllObjects];
    for (Chain *c in _chain) if (c.isAnchor) [anchors addObject:c];
	if (anchors.count >= 2)
    {
		for (Anchor *a in anchors) 
        {
			if ([a checkExplode]) break;
		}
	}

    return YES;
}

- (CGFloat)maxSpringLength
{
	return 3*self.radius;
}

//------------------------------------------------------------------------------------------------------------------------

- (void)unlink
{
	if (_links.count)
	{
		[k.sound play:@"unlink"];
		
		for (Chain *cp in _chain)
		{
			if (cp != self) 
			{
				[cp.chain removeObject:self];
				[cp.links removeObject:self];
			}
		}
		
		for (Chain *cp in _links)
		{
			[cp.links removeObject:self];
			[cp.chain removeAllObjects];
			
			NSInteger numLinks = cp.links.count;
			[cp.chain addObject:cp];
			if (numLinks) [[cp.links objectAtIndex:0] traverseChain:cp chains:cp.chain];
			
			for (Chain *c in cp.chain)
			{
				if (!cp.isAnchor && c != cp && c != self)
				{
					[c.chain removeAllObjects];
					[c.chain setArray:cp.chain];
				}
			}
		}

		while (_springs.count)
		{
			Spring *sp = [_springs anyObject];
			[_springs removeObject:sp];
			[k.particles removeSpring:sp];
		}

		[_links removeAllObjects];
		[_chain removeAllObjects];

		[_chain addObject:self]; // reference loop!
	}
}

@end
