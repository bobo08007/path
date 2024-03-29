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

#import "TTStyle.h"

@class TTLayout;

/**
 * A decorational view that can styled using a TTStyle object.
 */
@interface TTView : UIView <TTStyleDelegate> {
  TTStyle* _style;
  TTLayout* _layout;
}

@property(nonatomic,retain) TTStyle* style;
@property(nonatomic,retain) TTLayout* layout;

- (void)drawContent:(CGRect)rect;

@end
