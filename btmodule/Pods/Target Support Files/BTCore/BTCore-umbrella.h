#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BTDebugView.h"
#import "BTHttp.h"
#import "BTPageLoadView.h"
#import "BTViewController.h"

FOUNDATION_EXPORT double BTCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char BTCoreVersionString[];

