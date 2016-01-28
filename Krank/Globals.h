#import "KrankViewController.h"
#import "KrankScene.h"
#import "Particles.h"
#import "Player.h"
#import "Level.h"
#import "World.h"
#import "Lines.h"
#import "Input.h"
#import "Sound.h"
#import "Effect.h"
#import "Cockpit.h"
#import "Config.h"


#define ANCHOR_CENTER	0
#define ANCHOR_LEFT		1
#define ANCHOR_RIGHT	2
#define ANCHOR_TOP		4
#define ANCHOR_BOTTOM	8


#define PHYSICS_FIELD_PLAYER (1<<0)
#define PHYSICS_FIELD_BORDER (1<<1)
#define PHYSICS_FIELD_MAGNET (1<<2)

#define PHYSICS_CONTACT_OBJECTS (1<<0)


void delay(NSTimeInterval delay, dispatch_block_t handler);


@interface KrankGlobals : NSObject <SKSceneDelegate>

@property (nonatomic, strong, readonly) SKTextureAtlas *atlas;
@property (nonatomic, strong, readonly) KrankViewController *viewController;
@property (nonatomic, strong, readonly) Particles *particles;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong, readonly) Input *input;
@property (nonatomic, strong, readonly) Level *level;
@property (nonatomic, strong, readonly) World *world;
@property (nonatomic, strong, readonly) Lines *lines;
@property (nonatomic, strong, readonly) Sound *sound;
@property (nonatomic, strong, readonly) Effect *effects;
@property (nonatomic, strong, readonly) Cockpit *cockpit;
@property (nonatomic, strong, readonly) Config *config;
@property (nonatomic) int score;
//@property (nonatomic) BOOL reset;
@property (nonatomic, readonly) NSInteger maxLevel, numBonusLevels;
@property (nonatomic, readonly) CGFloat displayScaleFactor;

@property (nonatomic, strong, readonly) UIFont *hugeCockpitFont;
@property (nonatomic, strong, readonly) UIFont *largeCockpitFont;
@property (nonatomic, strong, readonly) UIFont *smallCockpitFont;

@property (nonatomic, strong, readonly) UIFont *largeFont;
@property (nonatomic, strong, readonly) UIFont *normalFont;
@property (nonatomic, strong, readonly) UIFont *smallFont;
@property (nonatomic, strong, readonly) UIFont *tinyFont;
@property (nonatomic, strong, readonly) UIFont *helpFont;

+ (KrankGlobals *)setupWithViewController:(KrankViewController *)viewController;

@end

extern KrankGlobals *k;
