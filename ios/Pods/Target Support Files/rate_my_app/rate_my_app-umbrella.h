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

#import "RateMyAppPlugin.h"

FOUNDATION_EXPORT double rate_my_appVersionNumber;
FOUNDATION_EXPORT const unsigned char rate_my_appVersionString[];

