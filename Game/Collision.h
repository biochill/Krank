//
//  Collision.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import <Foundation/Foundation.h>
#import "Particle.h"
#error
@interface Collision : NSObject

@property (nonatomic, readonly) Particle *p;
@property (nonatomic, readonly) CGPoint n;
@property (nonatomic, readonly) CGFloat f;

- (id)initWithParticle:(Particle *)part normal:(CGPoint)normal factor:(CGFloat)factor;

@end
