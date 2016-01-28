//
//  Stone.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Particle.h"

@interface Stone : Particle

+ (instancetype)addWithPos:(CGPoint)aPos color:(NSString *)aColor;
- (instancetype)initWithPos:(CGPoint)aPos color:(NSString *)aColor;

@end
