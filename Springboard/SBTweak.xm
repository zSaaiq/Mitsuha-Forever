#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>
#import <notify.h>
#import <dlfcn.h>

static MSHFConfig *SBconfig = NULL;
static MSHFConfig *SBLSconfig = NULL;

%group ColorFlowMitsuhaVisualsNotification

%hook CFWSBMediaController

-(void)setColorInfo:(CFWColorInfo *)colorInfo {
    %orig;

    UIColor *backgroundColor = [colorInfo.primaryColor colorWithAlphaComponent:0.5];

    if (SBconfig.colorMode == 0 || SBconfig.colorMode == 1) {
        [[SBconfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }

    if (SBLSconfig.colorMode == 0 || SBLSconfig.colorMode == 1) {
        [[SBLSconfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

%end

%end

%group MitsuhaVisualsNotification

%hook SBMediaController

-(void)setNowPlayingInfo:(NSDictionary *)arg1 {
    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information && CFDictionaryContainsKey(information, kMRMediaRemoteNowPlayingInfoArtworkData)) {
            UIImage *imageToColor = [UIImage imageWithData:(__bridge NSData*)CFDictionaryGetValue(information, kMRMediaRemoteNowPlayingInfoArtworkData)];

            [SBconfig colorizeView:imageToColor];
            [SBLSconfig colorizeView:imageToColor];
        }
    });
}

%end

%end

#import <objc/runtime.h>

%group ios13SB

%hook CSMediaControlsViewController

%property (retain,nonatomic) MSHFView *mshfView;

-(void)loadView{
    %orig;
    self.view.clipsToBounds = 1;

    MRPlatterViewController *pvc = nil;

    if (@available(iOS 15.0, *)) {
        pvc = object_getIvar(self, class_getInstanceVariable([self class], "_mediaRemoteViewController"));
    }
    else {
        pvc = object_getIvar(self, class_getInstanceVariable([self class], "_platterViewController"));
    }

    if (![SBconfig view]) [SBconfig initializeViewWithFrame:CGRectMake(-4, 0, self.view.frame.size.width - 8, self.view.frame.size.height)];
    self.mshfView = [SBconfig view];

    [pvc.view insertSubview:self.mshfView atIndex:0];

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information && CFDictionaryContainsKey(information, kMRMediaRemoteNowPlayingInfoArtworkData)) {
            [SBconfig colorizeView:[UIImage imageWithData:(__bridge NSData*)CFDictionaryGetValue(information, kMRMediaRemoteNowPlayingInfoArtworkData)]];
        }
    });
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    self.view.superview.layer.cornerRadius = 13;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunguarded-availability-new"
    self.view.superview.layer.cornerCurve = kCACornerCurveContinuous;
    #pragma clang diagnostic pop
    self.view.superview.layer.masksToBounds = TRUE;
}

-(void)viewDidAppear:(BOOL)animated {
    %orig;
    [[SBconfig view] start];
    [SBconfig view].center = CGPointMake([SBconfig view].center.x, SBconfig.waveOffset);
}

-(void)viewDidDisappear:(BOOL)animated{
    %orig;
    [[SBconfig view] stop];
}

- (void)platterViewController:(id)arg1 didReceiveInteractionEvent:(MediaControlsInteractionRecognizer *)arg2 {
    %orig;

    if (arg2.state == UIGestureRecognizerStateEnded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if ([[%c(SBMediaController) sharedInstance] isPlaying]) {
                [[SBconfig view] start];
            }
            else {
                [[SBconfig view] stop];
            }
        });
    }
}
%end

%end

%group ios13SBLS

%hook CSFixedFooterViewController

%property (strong,nonatomic) MSHFView *mshfview;

-(void)loadView{
    %orig;
    SBLSconfig.waveOffsetOffset = self.view.bounds.size.height - 200;

    if (![SBLSconfig view]) [SBLSconfig initializeViewWithFrame:self.view.bounds];
    self.mshfview = [SBLSconfig view];

    [self.view addSubview:self.mshfview];
    [self.view bringSubviewToFront:self.mshfview];

    self.mshfview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mshfview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mshfview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mshfview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.mshfview.heightAnchor constraintEqualToConstant:self.mshfview.frame.size.height].active = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    if([SBLSconfig view] && [[%c(SBMediaController) sharedInstance] isPlaying]) {
        [self.mshfview start];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    if([SBLSconfig view]) {
        [self.mshfview stop];
    }
}

%end

%end

static void screenDisplayStatus(CFNotificationCenterRef center, void* o, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    uint64_t state;
    int token;
    notify_register_check("com.apple.iokit.hid.displayStatus", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    if (![[%c(SBMediaController) sharedInstance] isPlaying]) {
        state = false;
    }
    if (SBLSconfig.enabled) {
        if (state) {
            [[SBLSconfig view] start];
        } else {
            [[SBLSconfig view] stop];
        }
    }
    if (SBconfig.enabled) {
        if (state) {
            [[SBconfig view] start];
        } else {
            [[SBconfig view] stop];
        }
    }
}

static void loadPrefs() {
    [SBLSconfig reload];
    [SBconfig reload];
}


%ctor{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.ryannair05.mitsuhaforever/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);

    SBLSconfig = [MSHFConfig loadConfigForApplication:@"LockScreen"];
    SBconfig = [MSHFConfig loadConfigForApplication:@"Springboard"];

    if (SBLSconfig.enabled || SBconfig.enabled) {
        if ([%c(CFWPrefsManager) class] && MSHookIvar<BOOL>([%c(CFWPrefsManager) sharedInstance], "_lockScreenEnabled")) %init(ColorFlowMitsuhaVisualsNotification);
        else if (access(OrionTweakDylibFile, F_OK) == 0) {
            [[NSNotificationCenter defaultCenter] addObserverForName:@"OrionMusicArtworkChanged" object:nil queue:nil usingBlock:^(NSNotification *n){
                UIColor *backgroundColor = [[[%c(OrionColorizer) sharedInstance] primaryColor] colorWithAlphaComponent:0.5];

                if (SBconfig.colorMode == 0 || SBconfig.colorMode == 1) {
                    [[SBconfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
                }

                if (SBLSconfig.colorMode == 0 || SBLSconfig.colorMode == 1) {
                    [[SBLSconfig view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
                }

            }];
        }
        else %init(MitsuhaVisualsNotification);
    }
    else return;

    if(SBLSconfig.enabled){
		    %init(ios13SBLS)
    }

    if(SBconfig.enabled){
        %init(ios13SB)
        SBconfig.waveOffsetOffset = 500;
    }
}
