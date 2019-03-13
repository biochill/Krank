//
// Globals.h
//

//
// Precompiler Flags for Debugging
// ===============================
//
// Set or clear these in Precompiler Flags in Build Settings.
//
// HAVE_FPS : 1 = show fps counter and other info
// HAVE_ALL_LEVELS : 1 = all levels immediately available in level selector
// HAVE_LEVEL_SCREENSHOTS : 1 = automatically create screenshots for levels when selected (and main menu for launch image)
// HAVE_CHEAT : 1 = use shake motion or 3-finger swipe to skip to next level
//

//
// Experimental:
//
// Setting this to 1 will do:
// - load stereo PCM files into 2x mono buffers
// - attempt to place these 2 mono buffers in the panorama according to horizontal location of sound
// However, in practice this does not work well so we just stick with standard stereo files.
// 0 = standard stereo file handling (no panning), 1 = load stereo files as 2x mono and apply panorama positioning
//#define HAVE_STEREO_PANNING 0
//


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
#import "DLog.h"


#define ANCHOR_CENTER	0
#define ANCHOR_LEFT		1
#define ANCHOR_RIGHT	2
#define ANCHOR_TOP		4
#define ANCHOR_BOTTOM	8


#define PHYSICS_FIELD_PLAYER (1<<0)
#define PHYSICS_FIELD_BORDER (1<<1)
#define PHYSICS_FIELD_MAGNET (1<<2)

#define PHYSICS_CONTACT_OBJECTS (1<<0)

@class KrankViewController;



void delay(NSTimeInterval delay, dispatch_block_t _Nonnull handler);


@interface KrankGlobals : NSObject <SKSceneDelegate>

@property (nonatomic, strong, readonly, nonnull) SKTextureAtlas *atlas;
@property (nonatomic, strong, readonly, nonnull) KrankViewController *viewController;
@property (nonatomic, strong, readonly, nonnull) Particles *particles;
@property (nonatomic, strong, nullable) Player *player;
@property (nonatomic, strong, readonly, nonnull) Input *input;
@property (nonatomic, strong, readonly, nonnull) Level *level;
@property (nonatomic, strong, readonly, nonnull) World *world;
@property (nonatomic, strong, readonly, nonnull) Lines *lines;
@property (nonatomic, strong, readonly, nonnull) Sound *sound;
@property (nonatomic, strong, readonly, nonnull) Effect *effects;
@property (nonatomic, strong, readonly, nonnull) Cockpit *cockpit;
@property (nonatomic, strong, readonly, nonnull) Config *config;
@property (nonatomic) int score;
//@property (nonatomic) BOOL reset;
@property (nonatomic, readonly) NSInteger maxLevel, numBonusLevels;
@property (nonatomic, readonly) CGFloat displayScaleFactor;

@property (nonatomic, strong, readonly, nonnull) UIFont *hugeCockpitFont;
@property (nonatomic, strong, readonly, nonnull) UIFont *largeCockpitFont;
@property (nonatomic, strong, readonly, nonnull) UIFont *smallCockpitFont;

@property (nonatomic, strong, readonly, nonnull) UIFont *largeFont;
@property (nonatomic, strong, readonly, nonnull) UIFont *normalFont;
@property (nonatomic, strong, readonly, nonnull) UIFont *smallFont;
@property (nonatomic, strong, readonly, nonnull) UIFont *tinyFont;
@property (nonatomic, strong, readonly, nonnull) UIFont *helpFont;

+ (KrankGlobals * _Nonnull)setupWithViewController:(KrankViewController * _Nonnull)viewController;

@end

extern KrankGlobals * _Nonnull k;
