//
//  Switch.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Particle.h"

@interface Switch : Particle

@property (nonatomic, strong) NSString *command;
//@property (nonatomic, strong) NSString *group;
@property (nonatomic) BOOL sound;

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos;
+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font;
+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor radius:(int)aRadius;
- (instancetype)initWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor radius:(CGFloat)aRadius;

@end
