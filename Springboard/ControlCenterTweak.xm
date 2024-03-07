#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>
#import <dlfcn.h>

static MSHFConfig *mshConfig;

%group SBMediaHook
%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
    %orig;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information && CFDictionaryContainsKey(information, kMRMediaRemoteNowPlayingInfoArtworkData)) {
            [mshConfig colorizeView:[UIImage imageWithData:(__bridge NSData*)CFDictionaryGetValue(information, kMRMediaRemoteNowPlayingInfoArtworkData)]];
        }
    });
}
%end
%end

%group ControlCenter

%hook MRUControlCenterViewController

%property (strong,nonatomic) MSHFView *mshfView;

-(void)loadView{
    %orig;
    if (![mshConfig view]) [mshConfig initializeViewWithFrame:self.view.subviews[2].bounds];
    self.mshfView = [mshConfig view];

    self.mshfView.layer.cornerRadius = 19;

    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunguarded-availability-new"
    self.mshfView.layer.cornerCurve = kCACornerCurveCircular;
    #pragma clang diagnostic pop

    self.mshfView.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMaxYCorner;
    self.mshfView.layer.masksToBounds = TRUE;

    [self.view.subviews[2] addSubview:self.mshfView];
    [self.view.subviews[2] bringSubviewToFront:self.mshfView];

    self.mshfView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mshfView.leadingAnchor constraintEqualToAnchor:self.view.subviews[2].leadingAnchor].active = YES;
    [self.mshfView.trailingAnchor constraintEqualToAnchor:self.view.subviews[2].trailingAnchor].active = YES;
    [self.mshfView.bottomAnchor constraintEqualToAnchor:self.view.subviews[2].bottomAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.mshfView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view.subviews[2] attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-mshConfig.waveOffset].active = YES;
}
- (void)setState:(NSInteger)arg1 {
    %orig;
    if (arg1 == 1) {
        self.mshfView.layer.cornerRadius = 38;
    }
    else {
        self.mshfView.layer.cornerRadius = 19;
    }

}
-(void)viewWillAppear:(BOOL)animated {
    %orig;
    [[self mshfView] start];
}
%end

%hook SBControlCenterController
-(void)_didDismiss {
    %orig;
    [mshConfig.view stop];
}
%end
%end

%ctor{

    mshConfig = [MSHFConfig loadConfigForApplication:@"ControlCenter"];
    
    if (mshConfig && mshConfig.enabled) {
        %init(SBMediaHook);
        %init(ControlCenter);
    }
}
