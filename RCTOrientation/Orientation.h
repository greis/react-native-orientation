//
//  Orientation.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTBridge.h"
#import "React/RCTEventDispatcher.h"

@interface Orientation : NSObject <RCTBridgeModule>
+ (void)setOrientation: (UIInterfaceOrientationMask)orientation;
+ (UIInterfaceOrientationMask)getOrientation;
@end
