//
//  Switch.h
//  Krank
//
//  Created by Sven Thoennissen on 02.12.15.
//
//

#import "Particle.h"

@class MenuButton;

@interface Switch : Particle

@property (nonatomic, strong) NSString *command;
@property (nonatomic) BOOL sound;
@property (nonatomic, getter=isMenuRepelEnabled) BOOL menuRepelEnabled; // TRUE = switch repels the player a small bit to avoid rapid hits

#if TARGET_OS_TV
@property (nonatomic, strong) MenuButton *button;
#endif

+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos;
+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font;
+ (instancetype)switchWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)aPos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor;
- (instancetype)initWithText:(NSString *)text anchor:(NSInteger)anAnchor command:(NSString *)aCommand position:(CGPoint)pos font:(UIFont *)font imageName:(NSString *)imageName color:(NSString *)aColor;

@end
