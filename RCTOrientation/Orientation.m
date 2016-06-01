//
//  Orientation.m
//

#import "Orientation.h"

@implementation Orientation

@synthesize bridge = _bridge;

static UIInterfaceOrientationMask _orientation = UIInterfaceOrientationMaskAllButUpsideDown;

+ (void)setOrientation: (UIInterfaceOrientationMask)orientation {
  _orientation = orientation;

  UIInterfaceOrientation specificOrientation = [Orientation getOrientationForMask:orientation];

  [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: specificOrientation] forKey:@"orientation"];
  }];
}

+ (UIInterfaceOrientationMask)getOrientation {
  return _orientation;
}

- (instancetype)init
{
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  [_bridge.eventDispatcher sendDeviceEventWithName:@"specificOrientationDidChange"
                                              body:@{@"specificOrientation": [Orientation getSpecificOrientationStr:orientation]}];

  [_bridge.eventDispatcher sendDeviceEventWithName:@"orientationDidChange"
                                              body:@{@"orientation": [Orientation getOrientationStr:orientation]}];
}

+ (UIInterfaceOrientation *)getOrientationForMask: (UIInterfaceOrientationMask)orientationMask {
  UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [self getSpecificOrientationStr:currentOrientation];

  UIInterfaceOrientation specificOrientation;
  switch (orientationMask) {
    case UIInterfaceOrientationMaskPortrait:
      specificOrientation = UIInterfaceOrientationPortrait;
      break;
    case UIInterfaceOrientationMaskLandscapeLeft:
      specificOrientation = UIInterfaceOrientationLandscapeLeft;
      break;
    case UIInterfaceOrientationMaskLandscapeRight:
      specificOrientation = UIInterfaceOrientationLandscapeRight;
      break;
    case UIInterfaceOrientationMaskLandscape:
      if ([orientationStr isEqualToString:@"LANDSCAPE-LEFT"]) {
        specificOrientation = UIInterfaceOrientationLandscapeRight;
      } else {
        specificOrientation = UIInterfaceOrientationLandscapeLeft;
      }
      break;
    case UIInterfaceOrientationMaskPortraitUpsideDown:
      specificOrientation = UIInterfaceOrientationPortraitUpsideDown;
      break;
    case UIInterfaceOrientationMaskAll:
      specificOrientation = UIInterfaceOrientationPortrait;
      break;
    case UIInterfaceOrientationMaskAllButUpsideDown:
      specificOrientation = UIInterfaceOrientationPortrait;
      break;
    default:
      break;
  }
  return specificOrientation;
}

+ (NSString *)getOrientationStr: (UIDeviceOrientation)orientation {
  NSString *orientationStr;
  switch (orientation) {
    case UIDeviceOrientationPortrait:
      orientationStr = @"PORTRAIT";
      break;
    case UIDeviceOrientationLandscapeLeft:
    case UIDeviceOrientationLandscapeRight:
      orientationStr = @"LANDSCAPE";
      break;

    case UIDeviceOrientationPortraitUpsideDown:
      orientationStr = @"PORTRAITUPSIDEDOWN";
      break;

    default:
      orientationStr = @"UNKNOWN";
      break;
  }
  return orientationStr;
}

+ (NSString *)getSpecificOrientationStr: (UIDeviceOrientation)orientation {
  NSString *orientationStr;
  switch (orientation) {
    case UIDeviceOrientationPortrait:
      orientationStr = @"PORTRAIT";
      break;

    case UIDeviceOrientationLandscapeLeft:
      orientationStr = @"LANDSCAPE-LEFT";
      break;

    case UIDeviceOrientationLandscapeRight:
      orientationStr = @"LANDSCAPE-RIGHT";
      break;

    case UIDeviceOrientationPortraitUpsideDown:
      orientationStr = @"PORTRAITUPSIDEDOWN";
      break;

    default:
      orientationStr = @"UNKNOWN";
      break;
  }
  return orientationStr;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getOrientation:(RCTResponseSenderBlock)callback)
{
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [Orientation getOrientationStr:orientation];
  callback(@[[NSNull null], orientationStr]);
}

RCT_EXPORT_METHOD(getSpecificOrientation:(RCTResponseSenderBlock)callback)
{
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [Orientation getSpecificOrientationStr:orientation];
  callback(@[[NSNull null], orientationStr]);
}

RCT_EXPORT_METHOD(lockToPortrait)
{
  #if DEBUG
    NSLog(@"Locked to Portrait");
  #endif
  [Orientation setOrientation:UIInterfaceOrientationMaskPortrait];
}

RCT_EXPORT_METHOD(lockToLandscape)
{
  #if DEBUG
    NSLog(@"Locked to Landscape");
  #endif
  [Orientation setOrientation:UIInterfaceOrientationMaskLandscape];
}

RCT_EXPORT_METHOD(lockToLandscapeRight)
{
  #if DEBUG
    NSLog(@"Locked to Landscape Right");
  #endif
    [Orientation setOrientation:UIInterfaceOrientationMaskLandscapeLeft];
}

RCT_EXPORT_METHOD(lockToLandscapeLeft)
{
  #if DEBUG
    NSLog(@"Locked to Landscape Left");
  #endif
  [Orientation setOrientation:UIInterfaceOrientationMaskLandscapeRight];
}

RCT_EXPORT_METHOD(unlockAllOrientations)
{
  #if DEBUG
    NSLog(@"Unlock All Orientations");
  #endif
  [Orientation setOrientation:UIInterfaceOrientationMaskAllButUpsideDown];
}

- (NSDictionary *)constantsToExport
{
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  NSString *orientationStr = [Orientation getOrientationStr:orientation];
  return @{
    @"initialOrientation": orientationStr
  };
}

@end
