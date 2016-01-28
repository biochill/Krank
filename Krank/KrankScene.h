//
//  KrankScene.h
//  Krank
//
//  Created by Sven Thoennissen on 19.01.16.
//
//

#import <SpriteKit/SpriteKit.h>

@interface KrankScene : SKScene

@property (nonatomic, strong) SKNode *background;
@property (nonatomic, strong, readonly) SKNode *level;
@property (nonatomic, strong, readonly) SKNode *player;

- (void)setBackground:(NSString *)background alpha:(CGFloat)alpha;
- (void)reset;

@end
