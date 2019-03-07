#import <Foundation/Foundation.h>
#import "Tools.h"


@interface World : NSObject

@property (nonatomic, readonly) CGRect rect; // UIView coordinates
@property (nonatomic, readonly) CGFloat left, top, right, bottom; // UIView coordinates
@property (nonatomic, readonly) CGPoint center; // UIView coordinates

//@property (nonatomic, readonly) double forceFactor;

- (id)initWithRect:(CGRect)aRect;
- (void)setBackground:(NSString *)imageName;
- (void)setBackground:(NSString *)imageName alpha:(CGFloat)alpha;
- (void)setBackground:(NSString *)imageName alpha:(CGFloat)alpha wantQuadImage:(BOOL)wantQuadImage;
- (CGPoint)convertFromScenePoint:(CGPoint)scenePoint;
- (CGPoint)convertToScenePoint:(CGPoint)scenePoint;

@end
