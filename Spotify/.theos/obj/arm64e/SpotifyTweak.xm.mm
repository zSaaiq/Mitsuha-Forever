#line 1 "SpotifyTweak.xm"
#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541

bool MSHFColorFlowSpotifyEnabled = NO;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class CFWPrefsManager; @class SPTVideoDisplayView; @class CFWSpotifyStateManager; @class SPTNowPlayingCoverArtImageView; @class SPTNowPlayingViewController; @class SPTNowPlayingCarouselAreaViewController; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CFWSpotifyStateManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CFWSpotifyStateManager"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CFWPrefsManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CFWPrefsManager"); } return _klass; }
#line 6 "SpotifyTweak.xm"
static void (*_logos_orig$MitsuhaVisuals$SPTNowPlayingCoverArtImageView$setImage$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCoverArtImageView* _LOGOS_SELF_CONST, SEL, UIImage*); static void _logos_method$MitsuhaVisuals$SPTNowPlayingCoverArtImageView$setImage$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCoverArtImageView* _LOGOS_SELF_CONST, SEL, UIImage*); static void (*_logos_orig$MitsuhaVisuals$SPTVideoDisplayView$refreshVideoRect)(_LOGOS_SELF_TYPE_NORMAL SPTVideoDisplayView* _LOGOS_SELF_CONST, SEL); static void _logos_method$MitsuhaVisuals$SPTVideoDisplayView$refreshVideoRect(_LOGOS_SELF_TYPE_NORMAL SPTVideoDisplayView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewWillDisappear$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST, SEL, BOOL); 

MSHFConfig *config = NULL;



static void _logos_method$MitsuhaVisuals$SPTNowPlayingCoverArtImageView$setImage$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCoverArtImageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIImage* image) {
    _logos_orig$MitsuhaVisuals$SPTNowPlayingCoverArtImageView$setImage$(self, _cmd, image);
    [config colorizeView:image];
}




static void _logos_method$MitsuhaVisuals$SPTVideoDisplayView$refreshVideoRect(_LOGOS_SELF_TYPE_NORMAL SPTVideoDisplayView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$MitsuhaVisuals$SPTVideoDisplayView$refreshVideoRect(self, _cmd);

    AVPlayer *displayView = [self player];
    AVAsset *asset = displayView.currentItem.asset;

    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    if (image) [config colorizeView:image];
}





__attribute__((used)) static MSHFView * _logos_property$MitsuhaVisuals$SPTNowPlayingViewController$mshfview(SPTNowPlayingViewController * __unused self, SEL __unused _cmd) { return (MSHFView *)objc_getAssociatedObject(self, (void *)_logos_property$MitsuhaVisuals$SPTNowPlayingViewController$mshfview); }; __attribute__((used)) static void _logos_property$MitsuhaVisuals$SPTNowPlayingViewController$setMshfview(SPTNowPlayingViewController * __unused self, SEL __unused _cmd, MSHFView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_property$MitsuhaVisuals$SPTNowPlayingViewController$mshfview, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewDidLoad(self, _cmd);

    NSLog(@"[Mitsuha]: viewDidLoad");
    
    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mshfview = [config view];
    [self.mshfview setUserInteractionEnabled:NO];

    [self.view insertSubview:self.mshfview atIndex:1];

    self.mshfview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mshfview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mshfview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mshfview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.mshfview.heightAnchor constraintEqualToConstant:self.mshfview.frame.size.height].active = YES;

}

static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    [[config view] start];
    _logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewWillAppear$(self, _cmd, animated);
}

static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewDidAppear$(self, _cmd, animated);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
        
    } completion:nil];
    
    [[config view] resetWaveLayers];

    if (config.colorMode == 1) {
        [config colorizeView:nil];
    }
    
    else if(MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [_logos_static_class_lookup$CFWSpotifyStateManager() sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

static void _logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewWillDisappear$(self, _cmd, animated);
    [[config view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:^(BOOL finished){
    }];
}




static void (*_logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillDisappear$)(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST, SEL, BOOL); 



static CGFloat originalCenterY = 0;

static void _logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillAppear$(self, _cmd, animated);
    
    NSLog(@"[Mitsuha]: originalCenterY: %lf", originalCenterY);
    
    CGPoint center = self.view.coverArtView.center;
    
    self.view.coverArtView.alpha = 0;
    self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
}

static void _logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewDidAppear$(self, _cmd, animated);
    
    NSLog(@"[Mitsuha]: viewDidAppear");
    
    CGPoint center = self.view.coverArtView.center;
    
    if(originalCenterY == 0){
        originalCenterY = center.y;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.coverArtView.alpha = 1.0;
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
    } completion:^(BOOL finished){
        if(self.view.coverArtView.center.y != originalCenterY * 0.8){    
            [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.coverArtView.center = CGPointMake(center.x, originalCenterY * 0.8);
            } completion:nil];
        }
    }];
}

static void _logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL SPTNowPlayingCarouselAreaViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated){
    _logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillDisappear$(self, _cmd, animated);
    
    CGPoint center = self.view.coverArtView.center;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.coverArtView.alpha = 0;
        self.view.coverArtView.center = CGPointMake(center.x, originalCenterY);
    } completion:nil];
}





static __attribute__((constructor)) void _logosLocalCtor_9b8ab1e4(int __unused argc, char __unused **argv, char __unused **envp){
    config = [MSHFConfig loadConfigForApplication:@"Spotify"];
    
    if(config.enabled){
        config.waveOffsetOffset = 520;
        
        if ([_logos_static_class_lookup$CFWPrefsManager() class] && MSHookIvar<BOOL>([_logos_static_class_lookup$CFWPrefsManager() sharedInstance], "_spotifyEnabled") && !config.ignoreColorFlow) {
            MSHFColorFlowSpotifyEnabled = YES;
        }
        {Class _logos_class$MitsuhaVisuals$SPTNowPlayingCoverArtImageView = objc_getClass("SPTNowPlayingCoverArtImageView"); { MSHookMessageEx(_logos_class$MitsuhaVisuals$SPTNowPlayingCoverArtImageView, @selector(setImage:), (IMP)&_logos_method$MitsuhaVisuals$SPTNowPlayingCoverArtImageView$setImage$, (IMP*)&_logos_orig$MitsuhaVisuals$SPTNowPlayingCoverArtImageView$setImage$);}Class _logos_class$MitsuhaVisuals$SPTVideoDisplayView = objc_getClass("SPTVideoDisplayView"); { MSHookMessageEx(_logos_class$MitsuhaVisuals$SPTVideoDisplayView, @selector(refreshVideoRect), (IMP)&_logos_method$MitsuhaVisuals$SPTVideoDisplayView$refreshVideoRect, (IMP*)&_logos_orig$MitsuhaVisuals$SPTVideoDisplayView$refreshVideoRect);}Class _logos_class$MitsuhaVisuals$SPTNowPlayingViewController = objc_getClass("SPTNowPlayingViewController"); { objc_property_attribute_t _attributes[16]; unsigned int attrc = 0; _attributes[attrc++] = (objc_property_attribute_t) { "T", "@\"MSHFView\"" }; _attributes[attrc++] = (objc_property_attribute_t) { "&", "" }; _attributes[attrc++] = (objc_property_attribute_t) { "N", "" }; class_addProperty(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, "mshfview", _attributes, attrc); size_t _nBytes = 1024; char _typeEncoding[_nBytes]; snprintf(_typeEncoding, _nBytes, "%s@:", @encode(MSHFView *)); class_addMethod(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, @selector(mshfview), (IMP)&_logos_property$MitsuhaVisuals$SPTNowPlayingViewController$mshfview, _typeEncoding); snprintf(_typeEncoding, _nBytes, "v@:%s", @encode(MSHFView *)); class_addMethod(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, @selector(setMshfview:), (IMP)&_logos_property$MitsuhaVisuals$SPTNowPlayingViewController$setMshfview, _typeEncoding); } { MSHookMessageEx(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, @selector(viewDidLoad), (IMP)&_logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewDidLoad, (IMP*)&_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewDidLoad);}{ MSHookMessageEx(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, @selector(viewWillAppear:), (IMP)&_logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewWillAppear$, (IMP*)&_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewWillAppear$);}{ MSHookMessageEx(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, @selector(viewDidAppear:), (IMP)&_logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewDidAppear$, (IMP*)&_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewDidAppear$);}{ MSHookMessageEx(_logos_class$MitsuhaVisuals$SPTNowPlayingViewController, @selector(viewWillDisappear:), (IMP)&_logos_method$MitsuhaVisuals$SPTNowPlayingViewController$viewWillDisappear$, (IMP*)&_logos_orig$MitsuhaVisuals$SPTNowPlayingViewController$viewWillDisappear$);}}




        if (config.enableCoverArtBugFix) {Class _logos_class$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController = objc_getClass("SPTNowPlayingCarouselAreaViewController"); { MSHookMessageEx(_logos_class$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController, @selector(viewWillAppear:), (IMP)&_logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillAppear$, (IMP*)&_logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillAppear$);}{ MSHookMessageEx(_logos_class$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController, @selector(viewDidAppear:), (IMP)&_logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewDidAppear$, (IMP*)&_logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewDidAppear$);}{ MSHookMessageEx(_logos_class$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController, @selector(viewWillDisappear:), (IMP)&_logos_method$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillDisappear$, (IMP*)&_logos_orig$MitsuhaSpotifyCoverArtFix$SPTNowPlayingCarouselAreaViewController$viewWillDisappear$);}}  } }
