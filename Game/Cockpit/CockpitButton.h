//
//  CockpitButton.h
//  Krank
//
//  Created by Sven Thoennissen on 26.11.15.
//

#import "FocusButton.h"
#import "DLog.h"

@interface CockpitButton : FocusButton

@property (nonatomic, copy) ActionHandler handler;
@property (nonatomic, strong) NSString *text;

+ (instancetype)buttonWithText:(NSString *)text;

@end
