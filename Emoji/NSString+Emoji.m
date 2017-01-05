//
//  NSString+Emoji.m
//  EmojiConvert
//
//  Created by zdy on 2017/1/5.
//  Copyright © 2017年 lianlian. All rights reserved.
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)

- (NSString *)stringByConvertEmojiToCheatCodes {
    if (self.length <= 1) {
        return self;
    }
    
    // emoji 现在有 2、4、6、8、字节的，最多处理前4位，
    NSMutableString *hexMutStr = [[NSMutableString alloc] init];
    
    for (int i=0; (i<self.length-1) && (i<3); ) {
        const unichar hs = [self characterAtIndex:i];
        const unichar ls = [self characterAtIndex:i+1];
        
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            
            if (0x1d000 <= uc && uc <= 0x1f9cf) {
                [hexMutStr appendFormat:@"[U+%X]",uc];
                i+=2;
            } else {
                break;
            }
            
        } else if ((0x2100 <= hs && hs <= 0x269f) ||
                   (0x26a0 <= hs && hs <= 0x329f)) {
            [hexMutStr appendFormat:@"[U+%X]",hs];
            i+=2;
        } else {
            break;
        }
    }
    
    return hexMutStr;
}

- (NSString *)stringByConvertCheatCodesToEmoji {
    if (self.length <= 1) {
        return self;
    }
    
    NSString *str = [self stringByReplacingOccurrencesOfString:@"U+" withString:@"0x"];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    
    NSScanner *aScanner = [NSScanner scannerWithString:str];
    unsigned uc;
    [aScanner scanHexInt:&uc];
    
//    NSString *scanString = @"[0x1F600]";
//    NSScanner *bScanner = [NSScanner scannerWithString:scanString];
//    unsigned r;
//    [bScanner scanHexInt:&r];
    
    NSString *emoji = @"";
    // 转换参照地址 http://blog.csdn.net/u014702999/article/details/43055445
    if (0x1d000 <= uc && uc <= 0x1f9cf) {
        unsigned short hex = (unsigned short)(uc - 0x10000);
        unsigned short hs = (hex>>10)|0xD800;
        unsigned short ls = (hex&0x03ff)|0xDC00;
        
        unichar array[2];
        array[0] = hs;
        array[1] = ls;
        emoji = [NSString stringWithCharacters:array length:2];
    }else if ((0x2100 <= uc && uc <= 0x269f) ||
              (0x26a0 <= uc && uc <= 0x329f)) {
        unsigned short ls = (unsigned short)(uc&0xffff);
        emoji = [NSString stringWithCharacters:&ls length:1];
    }
    
    return emoji;
}

- (NSString *)stringByReplacingEmojiUnicodeWithCheatCodes {
    if (self.length <= 1) {
        return self;
    }
    
    NSMutableString *str = [NSMutableString stringWithString:self];
    
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         NSString *unicode = [substring stringByConvertEmojiToCheatCodes];
         [str replaceCharactersInRange:substringRange withString:unicode];
     }];
    
    return str;
}


- (NSString *)stringByReplacingEmojiCheatCodesWithUnicode {
    if (self.length <= 1) {
        return self;
    }
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"\\[U\\+[a-f0-9A-F]+\\]" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    __block NSString *resultText = self;
    __block NSRange matchingRange = NSMakeRange(0, [resultText length]);
    
    for (; matchingRange.location < resultText.length;) {
        [regex enumerateMatchesInString:resultText
                                options:NSMatchingReportCompletion
                                  range:matchingRange
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 if (result && ([result resultType] == NSTextCheckingTypeRegularExpression) && !(flags & NSMatchingInternalError)) {
                                     NSRange range = result.range;
                                     if (range.location != NSNotFound) {
                                         NSString *unicodeStr = [resultText substringWithRange:range];
                                         NSString *emji = [unicodeStr stringByConvertCheatCodesToEmoji];
                                         if (emji.length) {
                                             resultText = [resultText stringByReplacingCharactersInRange:range withString:emji];
                                             matchingRange = NSMakeRange(range.location + emji.length, resultText.length-range.location - emji.length);
                                             *stop = YES;
                                         }
                                     }
                                 } else {
                                     matchingRange = NSMakeRange(resultText.length, 0);
                                 }
                             }];
    }
    
    return resultText;
}
@end
