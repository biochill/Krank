//
//  Level+Levels.h
//  Krank
//
//  Created by Sven Thoennissen on 24.11.15.
//
//

#import "Globals.h"
#import "KrankViewController.h"
#import "Sprite.h"
#import "Chain.h"
#import "Magnet.h"
#import "Anchor.h"
#import "Config.h"
#import "Switch.h"
#import "Stone.h"

@interface Level (level001)
- (void)setup_level001;
@end

@interface Level (level002)
- (void)setup_level002;
@end

@interface Level (level003)
- (void)setup_level003;
@end

@interface Level (level004)
- (void)setup_level004;
@end

@interface Level (level005)
- (void)setup_level005;
@end

@interface Level (level006)
- (void)setup_level006;
@end

@interface Level (level007)
- (void)setup_level007;
@end

@interface Level (level008)
- (void)setup_level008;
@end

@interface Level (level009)
- (void)setup_level009;
@end

@interface Level (level010)
- (void)setup_level010;
@end

@interface Level (level011)
- (void)setup_level011;
@end

@interface Level (level012)
- (void)setup_level012;
@end

@interface Level (level013)
- (void)setup_level013;
@end

@interface Level (level014)
- (void)setup_level014;
@end

@interface Level (level015)
- (void)setup_level015;
@end

@interface Level (level016)
- (void)setup_level016;
@end

@interface Level (level017)
- (void)setup_level017;
@end

@interface Level (level018)
- (void)setup_level018;
@end

@interface Level (level019)
- (void)setup_level019;
@end

@interface Level (level020)
- (void)setup_level020;
@end

@interface Level (level021)
- (void)setup_level021;
@end

@interface Level (level022)
- (void)setup_level022;
@end

@interface Level (level023)
- (void)setup_level023;
@end

@interface Level (level024)
- (void)setup_level024;
@end

@interface Level (level025)
- (void)setup_level025;
@end

@interface Level (level026)
- (void)setup_level026;
@end

@interface Level (level027)
- (void)setup_level027;
@end

@interface Level (level028)
- (void)setup_level028;
@end

@interface Level (level029)
- (void)setup_level029;
@end

@interface Level (level030)
- (void)setup_level030;
@end

@interface Level (menu_sound)
- (void)setup_menu_sound;
@end

@interface Level (Menu)
- (void)setup_menu;
@end

@interface Level (menu_credits)
- (void)setup_menu_credits;
- (void)drawCreditsEntry:(NSString *)text pos:(CGPoint)pos;
- (void)drawCreditsSection:(NSString*)text pos:(CGPoint)pos;
@end

@interface Level (menu_help)
- (void)addBackButton:(CGPoint)position;
- (void)addBackButton:(CGPoint)position anchor:(NSInteger)anchor;
- (void)setup_menu_help;
- (void)setup_menu_help_overview;
- (void)setup_menu_help_goal;
- (void)setup_menu_help_misc;
@end

@interface Level (menu_levels)
- (void)setup_menu_levels;
@end

@interface Level (menu_levels2)
- (void)setup_menu_levels2;
@end

@interface Level (menu_levels3)
- (void)setup_menu_levels3;
@end

@interface Level (menu_options)
- (void)setup_menu_options;
@end

@interface Level (menu_play)
- (void)setup_menu_play;
@end

@interface Level (menu_scores)
- (void)setup_menu_scores;
@end

@interface Level (menu_scores1)
- (void)setup_menu_scores1;
@end

@interface Level (menu_scores2)
- (void)setup_menu_scores2;
@end

@interface Level (menu_scores3)
- (void)setup_menu_scores3;
@end
