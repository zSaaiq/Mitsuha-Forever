#import <Foundation/Foundation.h>

@protocol MSHFAudioDelegate <NSObject>

- (void)updateBuffer:(float *)bufferData withLength:(int)length;

@end