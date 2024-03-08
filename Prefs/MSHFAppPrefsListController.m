#import "MSHFAppPrefsListController.h"
#import <rootless.h>
@implementation MSHFAppPrefsListController

- (NSArray *)specifiers {
    return _specifiers;
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [super setSpecifier:specifier];

    // Extract app name from specifier
    self.appName = [specifier propertyForKey:@"MSHFApp"];
    if (!self.appName) return;

    // Get title from specifier
    NSString *title = [specifier name];

    // Initialize dictionary to store specifiers
    self.savedSpecifiers = [NSMutableDictionary dictionary];

    // Load specifiers from ControlCenter.plist
    NSArray *controlCenterSpecifiers = [self loadSpecifiersFromPlistName:@"ControlCenter" target:self];
    if (controlCenterSpecifiers) {
        _specifiers = [NSMutableArray arrayWithArray:controlCenterSpecifiers];
    }

    // Load specifiers from HomeScreen.plist
    NSArray *homeScreenSpecifiers = [self loadSpecifiersFromPlistName:@"HomeScreen" target:self];
    if (homeScreenSpecifiers) {
        if (!_specifiers) {
            _specifiers = [NSMutableArray arrayWithArray:homeScreenSpecifiers];
        } else {
            [_specifiers addObjectsFromArray:homeScreenSpecifiers];
        }
    }

    // Load specifiers from LockScreen.plist
    NSArray *lockScreenSpecifiers = [self loadSpecifiersFromPlistName:@"LockScreen" target:self];
    if (lockScreenSpecifiers) {
        if (!_specifiers) {
            _specifiers = [NSMutableArray arrayWithArray:lockScreenSpecifiers];
        } else {
            [_specifiers addObjectsFromArray:lockScreenSpecifiers];
        }
    }

    // Load specifiers from Music.plist
    NSArray *musicSpecifiers = [self loadSpecifiersFromPlistName:@"Music" target:self];
    if (musicSpecifiers) {
        if (!_specifiers) {
            _specifiers = [NSMutableArray arrayWithArray:musicSpecifiers];
        } else {
            [_specifiers addObjectsFromArray:musicSpecifiers];
        }
    }

    // Load specifiers from Spotify.plist
    NSArray *spotifySpecifiers = [self loadSpecifiersFromPlistName:@"Spotify" target:self];
    if (spotifySpecifiers) {
        if (!_specifiers) {
            _specifiers = [NSMutableArray arrayWithArray:spotifySpecifiers];
        } else {
            [_specifiers addObjectsFromArray:spotifySpecifiers];
        }
    }

    // Load specifiers from Springboard.plist
    NSArray *springboardSpecifiers = [self loadSpecifiersFromPlistName:@"Springboard" target:self];
    if (springboardSpecifiers) {
        if (!_specifiers) {
            _specifiers = [NSMutableArray arrayWithArray:springboardSpecifiers];
        } else {
            [_specifiers addObjectsFromArray:springboardSpecifiers];
        }
    }

    // Set title
    [self setTitle:title];
}




-(void)removeBarText:(bool)animated {
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarSpacingText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarSpacing"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarRadiusText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"BarRadius"]] animated:animated];
}
-(void)removeLineText:(bool)animated {
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"LineText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"LineThicknessText"]] animated:animated];
    [self removeContiguousSpecifiers:@[self.savedSpecifiers[@"LineThickness"]] animated:animated];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    MSHFConfig *config = [MSHFConfig loadConfigForApplication:self.appName];

    if (config.style != 1) {
        [self removeBarText:NO];
        if (config.style != 2) {
            [self removeLineText:NO];
        }
    } else {
        [self removeLineText:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.table.separatorColor = [UIColor colorWithWhite:0 alpha:0];

    UIWindowScene *keyWindowScene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] allObjects].firstObject;
    UIWindow *keyWindow = keyWindowScene.windows.firstObject;

    if ([keyWindow respondsToSelector:@selector(setTintColor:)]) {
        keyWindow.tintColor = [UIColor colorWithRed:238.0f / 255.0f
                                                green:100.0f / 255.0f
                                                blue:92.0f / 255.0f
                                                alpha:1];
    }

    [UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = [UIColor colorWithRed:238.0f / 255.0f
                                                                                                        green:100.0f / 255.0f
                                                                                                         blue:92.0f / 255.0f
                                                                                                        alpha:1];


    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


- (id)readPreferenceValue:(PSSpecifier*)specifier {
  NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
  NSMutableDictionary *settings = [NSMutableDictionary dictionary];
  [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];

  return ([settings objectForKey:specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *defaultsKey = specifier.properties[@"defaults"];
    NSString *key = specifier.properties[@"key"];

    if (!defaultsKey || !key) {
        NSLog(@"Missing defaults key or specifier key.");
        return;
    }

    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", defaultsKey];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    if (!settings) {
        settings = [NSMutableDictionary dictionary];
    }

    [settings setObject:value forKey:key];
    [settings writeToFile:path atomically:YES];

    NSString *notificationName = specifier.properties[@"PostNotification"];
    if (notificationName) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)notificationName, NULL, NULL, YES);
    }

    NSString *specifierKey = [specifier propertyForKey:@"key"];

    if ([specifierKey containsString:@"Style"]) {
        NSInteger integerValue = [value integerValue];

        if (integerValue == 1) {
            [self insertSpecifier:self.savedSpecifiers[@"BarText"] afterSpecifierID:@"NumberOfPoints" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"BarSpacingText"] afterSpecifierID:@"BarText" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"BarSpacing"] afterSpecifierID:@"BarSpacingText" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"BarRadiusText"] afterSpecifierID:@"BarSpacing" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"BarRadius"] afterSpecifierID:@"BarRadiusText" animated:YES];

            if ([self containsSpecifier:self.savedSpecifiers[@"LineText"]]) {
                [self removeLineText:YES];
            }
        } else if (integerValue == 2) {
            if ([self containsSpecifier:self.savedSpecifiers[@"BarText"]]) {
                [self removeBarText:YES];
            }

            [self insertSpecifier:self.savedSpecifiers[@"LineText"] afterSpecifierID:@"NumberOfPoints" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"LineThicknessText"] afterSpecifierID:@"LineText" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"LineThickness"] afterSpecifierID:@"LineThicknessText" animated:YES];
        } else {
            if ([self containsSpecifier:self.savedSpecifiers[@"BarText"]]) {
                [self removeBarText:YES];
            } else if ([self containsSpecifier:self.savedSpecifiers[@"LineText"]]) {
                [self removeLineText:YES];
            }
        }
    }
}


- (bool)shouldReloadSpecifiersOnResume {
    return NO;
}
@end
