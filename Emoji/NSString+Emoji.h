//
//  NSString+Emoji.h
//  EmojiConvert
//
//  Created by zdy on 2017/1/5.
//  Copyright © 2017年 lianlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

/* Example:
 "This is a smiley face \U0001F604"
 
 Will be replaced with:
 "This is a smiley face [U+1F604]"
 */
- (NSString *)stringByReplacingEmojiUnicodeWithCheatCodes;

/* Example:
 "This is a smiley face [U+1F604]"
 
 Will be replaced with:
 "This is a smiley face \U0001F604"
 */
- (NSString *)stringByReplacingEmojiCheatCodesWithUnicode;
@end
