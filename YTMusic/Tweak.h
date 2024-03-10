//
//  Tweak.h
//  Mitsuha
//
//  Created by zSaaiq on 09/03/24.
//  Copyright © 2024 zSaaiq. All rights reserved.
//

#import <MitsuhaForever/MSHFConfig.h>
#import <AVKit/AVKit.h>

@interface YTImageView : UIImageView
-(void)setImage:(UIImage *)image;
-(void)readjustWaveColor;

@end

@interface YTMusicNowPlayingView : UIView

@property(retain, nonatomic) UIImage *cellContentRepresentation;

@end

@interface YTMNowPlayingModel : NSObject
- (void)player:(id)arg1 stateDidChange:(id)arg2 fromState:(id)arg3;
- (void)updateWithPlayerState:(id)arg1;
-(void)applyColorChange;

@end

@interface CFWColorInfo : NSObject

+ (id)colorInfoWithAnalyzedInfo:(struct AnalyzedInfo)arg1;
@property(nonatomic, getter=isBackgroundDark) _Bool backgroundDark; // @synthesize backgroundDark=_backgroundDark;
@property(retain, nonatomic) UIColor *secondaryColor; // @synthesize secondaryColor=_secondaryColor;
@property(retain, nonatomic) UIColor *primaryColor; // @synthesize primaryColor=_primaryColor;
@property(retain, nonatomic) UIColor *backgroundColor; // @synthesize backgroundColor=_backgroundColor;
- (id)initWithAnalyzedInfo:(struct AnalyzedInfo)arg1;

@end

@interface CFWYTMUsicStateManager : NSObject

+ (id)sharedManager;

@property(readonly, retain, nonatomic) CFWColorInfo *mainColorInfo; // @synthesize mainColorInfo=_mainColorInfo;

@end

@interface CFWPrefsManager : NSObject

+(id)sharedInstance;

@end

@interface YTMusicNowPlayingViewController : UIViewController
@property (retain,nonatomic) MSHFView *mshfview;
@end
