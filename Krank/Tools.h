#import <Foundation/Foundation.h>

CG_INLINE long minl(long a, long b) { return a < b ? a : b; }
CG_INLINE long maxl(long a, long b) { return a > b ? a : b; }
CG_INLINE long clampl(long v, long l, long h) { return maxl(minl(v, h), l); }
CG_INLINE float fclampf(float v, float l, float h) { return fmaxf(fminf(v, h), l); }
CG_INLINE double fclamp(double v, double l, double h) { return fmax(fmin(v, h), l); }

//-------------------------------------------------------------------------
// CGPoint tools
//-------------------------------------------------------------------------

CG_INLINE NSString *StringFromCGPoint(CGPoint a) { return [NSString stringWithFormat:@"(%.3f, %.3f)", a.x, a.y]; }

CG_INLINE CGPoint CGPointNeg        (CGPoint a)                     { return CGPointMake(-a.x,-a.y); }
CG_INLINE CGPoint CGPointAdd        (CGPoint a, CGPoint b)          { return CGPointMake(a.x+b.x, a.y+b.y); }
CG_INLINE CGPoint CGPointSub        (CGPoint a, CGPoint b)          { return CGPointMake(a.x-b.x, a.y-b.y); }
CG_INLINE CGPoint CGPointScale      (CGPoint a, CGFloat s)          { return CGPointMake(a.x*s, a.y*s); }
CG_INLINE CGPoint CGPointWithAngle  (double a, CGFloat l)           { return CGPointScale(CGPointMake(cos(a), sin(a)), l); }
CG_INLINE CGPoint CGPointOvalWithAngle (double a, CGFloat rx, CGFloat ry) { CGPoint p = CGPointMake(cos(a), sin(a)); return CGPointMake(p.x*rx, p.y*ry); }
CG_INLINE CGFloat CGPointLength     (CGPoint a)                     { return sqrt(a.x*a.x + a.y*a.y); }
CG_INLINE CGFloat CGPointLengthSquare(CGPoint a)                    { return a.x*a.x + a.y*a.y; }
CG_INLINE CGPoint CGPointNorm       (CGPoint v)                     { return CGPointScale(v, 1.0f/CGPointLength(v)); }
CG_INLINE CGPoint CGPointAddMult    (CGPoint a, CGPoint b, CGFloat f) { return CGPointMake(a.x+f*b.x, a.y+f*b.y); }
CG_INLINE CGFloat CGPointDotProduct (CGPoint a, CGPoint b)          { return a.x*b.x + a.y*b.y; }

//------------------------------------------------------------------------------------------------------------------------

@interface Tools : NSObject

+ (SKNode *)addLabelWithText:(NSString *)text pos:(CGPoint)pos color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font;
+ (SKNode *)addLabelWithText:(NSString *)text rect:(CGRect)rect color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font;
+ (SKNode *)labelWithText:(NSString *)text pos:(CGPoint)pos color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font;
+ (SKNode *)labelWithText:(NSString *)text rect:(CGRect)rect color:(UIColor *)color anchor:(NSInteger)anchor font:(UIFont *)font;

//+ (void)drawText_normal:(NSString *)text pos:(CGPoint)pos anchor:(NSInteger)anchor;
//+ (void)drawText_large:(NSString *)text pos:(CGPoint)pos;

+ (UIImage *)makeLandscapeQuadImage:(UIImage *)sourceImage size:(CGSize)size alpha:(CGFloat)alpha;

@end
