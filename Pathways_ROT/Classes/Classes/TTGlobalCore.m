//
// Copyright 2009 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTGlobalCore.h"

#import <objc/runtime.h>

/**
 * This is provided for backwards-compatibility with the TTLOG macro.
 * If this code is still here come February, 2010, feel free to remove it and the
 * corresponding TTLOG/TTWARN macros in the header.
 */
void TTDeprecatedLog(NSString* text, ...) {
  va_list ap;
  va_start(ap, text);
  NSLogv(text, ap);
  va_end(ap);
}

static const void* TTRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

NSMutableArray* TTCreateNonRetainingArray() {
  CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
  callbacks.retain = TTRetainNoOp;
  callbacks.release = TTReleaseNoOp;
  return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

NSMutableDictionary* TTCreateNonRetainingDictionary() {
  CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
  CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
  callbacks.retain = TTRetainNoOp;
  callbacks.release = TTReleaseNoOp;
  return (NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

// Deprecated
BOOL TTIsEmptyArray(id object) {
  return [object isKindOfClass:[NSArray class]] && ![(NSArray*)object count];
}

// Deprecated
BOOL TTIsEmptySet(id object) {
  return [object isKindOfClass:[NSSet class]] && ![(NSSet*)object count];
}

// Deprecated
BOOL TTIsEmptyString(id object) {
  return [object isKindOfClass:[NSString class]] && ![(NSString*)object length];
}

BOOL TTIsArrayWithItems(id object) {
  return [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0;
}

BOOL TTIsSetWithItems(id object) {
  return [object isKindOfClass:[NSSet class]] && [(NSSet*)object count] > 0;
}

BOOL TTIsStringWithAnyText(id object) {
  return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}

void TTSwapMethods(Class cls, SEL originalSel, SEL newSel) {
  Method originalMethod = class_getInstanceMethod(cls, originalSel);
  Method newMethod = class_getInstanceMethod(cls, newSel);
  method_exchangeImplementations(originalMethod, newMethod);
}
