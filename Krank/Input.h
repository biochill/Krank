//
//  Input.h


extern NSString *const InputControllerButtonPressed;


@interface Input : NSObject

@property (nonatomic) CGPoint fingerPos; // position where user tapped (UIView coordinates)
@property (nonatomic) CGPoint targetPos; // equal to fingerPos but possibly with fingerDistance (ie. position of target)

@property (nonatomic) BOOL targetDisplayEnabled;
#if TARGET_OS_TV
#else
@property (nonatomic) BOOL accelerometerEnabled;
@property (nonatomic) BOOL fingerOffsetEnabled;
@property (nonatomic, readonly) CGFloat fingerDistance;
#endif

- (void)showTarget;
- (void)jumpToFingerPos:(CGPoint)fingerPos;
- (void)onFrame:(NSTimeInterval)delta;
- (void)reset;

@end
