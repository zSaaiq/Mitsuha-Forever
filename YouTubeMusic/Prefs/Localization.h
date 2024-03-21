#import <Foundation/Foundation.h>
#import <rootless.h>

static inline NSBundle *YouTubeMusicMitsuhaForeverBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"YouTubeMusicMitsuhaForever" ofType:@"bundle"];
        if (tweakBundlePath)
            bundle = [NSBundle bundleWithPath:tweakBundlePath];
        else
            bundle = [NSBundle bundleWithPath:ROOT_PATH_NS(@"/Library/Application Support/YouTubeMusicMitsuhaForever.bundle")];
    });
    return bundle;
}

static inline NSString *LOC(NSString *key) {
    return [YouTubeMusicMitsuhaForeverBundle() localizedStringForKey:key value:nil table:nil];
}
