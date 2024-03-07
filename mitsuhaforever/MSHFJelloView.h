#import <UIKit/UIKit.h>
#import "MSHFJelloLayer.h"
#import "MSHFView.h"

@interface MSHFJelloView : MSHFView

@property (nonatomic, strong) MSHFJelloLayer *waveLayer;
@property (nonatomic, strong) MSHFJelloLayer *subwaveLayer;

-(CGPathRef)createPathWithPoints:(CGPoint *)points pointCount:(NSUInteger)pointCount inRect:(CGRect)rect;

@end
