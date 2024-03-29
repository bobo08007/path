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

#import "TTGlobalCoreLocale.h"

#import "TTGlobalCore.h"

NSLocale* TTCurrentLocale() {
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
  if (languages.count > 0) {
    NSString* currentLanguage = [languages objectAtIndex:0];
    return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
  } else {
    return [NSLocale currentLocale];
  }
}

NSString* TTLocalizedString(NSString* key, NSString* comment) {
  static NSBundle* bundle = nil;
  if (!bundle) {
    NSString* path = [[[NSBundle mainBundle] resourcePath]
          stringByAppendingPathComponent:@"Three20.bundle"];
    bundle = [[NSBundle bundleWithPath:path] retain];
  }
  
  return [bundle localizedStringForKey:key value:key table:nil];
}

NSString* TTDescriptionForError(NSError* error) {
  TTDINFO(@"ERROR %@", error);
  if ([error.domain isEqualToString:NSURLErrorDomain]) {
    if (error.code == NSURLErrorTimedOut) {
      return TTLocalizedString(@"Connection Timed Out", @"");
    } else if (error.code == NSURLErrorNotConnectedToInternet) {
      return TTLocalizedString(@"No Internet Connection", @"");
    } else {
      return TTLocalizedString(@"Connection Error", @"");
    }
  }
  return TTLocalizedString(@"Error", @"");
}

NSString* TTFormatInteger(NSInteger num) {
  NSNumber* number = [NSNumber numberWithInt:num];
  NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
  [formatter setGroupingSeparator:@","];
  NSString* formatted = [formatter stringForObjectValue:number];
  [formatter release];
  return formatted;
}
