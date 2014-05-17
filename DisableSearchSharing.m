/*
The MIT License (MIT)

Copyright (c) 2014 Andrey Fedorov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// VERSION 0.0.1

#import <Foundation/Foundation.h>
#import <stdio.h>
#import <objc/runtime.h>
#import <AppKit/AppKit.h>

@interface DisableSearchSharing : NSObject

@end

static IMP originalSetDataImp = NULL;
static IMP originalGetDataImp = NULL;

@implementation DisableSearchSharing

+ (void)load
{
    Class originalClass = NSClassFromString(@"NSPasteboard");

    Method originalSet = class_getInstanceMethod(originalClass, @selector(setData:forType:));
    originalSetDataImp = method_getImplementation(originalSet);
    Method replacementSet = class_getInstanceMethod([self class], @selector(setData:forType:));
    method_exchangeImplementations(originalSet, replacementSet);

    Method originalGet = class_getInstanceMethod(originalClass, @selector(dataForType:));
    originalGetDataImp = method_getImplementation(originalGet);
    Method replacementGet = class_getInstanceMethod([self class], @selector(dataForType:));
    method_exchangeImplementations(originalGet, replacementGet);
}

- (BOOL)setData:(NSData *)data forType:(NSString *)dataType;
{
    if ([[self name] isEqualToString:NSFindPboard]) return NO;
    return (BOOL)originalSetDataImp(self, @selector(setData:forType:), data, dataType);
}

- (NSData *)dataForType:(NSString *)dataType
{
    if ([[self name] isEqualToString:NSFindPboard]) return nil;
    return originalGetDataImp(self, @selector(dataForType:), dataType);
}

@end
