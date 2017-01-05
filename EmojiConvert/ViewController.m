//
//  ViewController.m
//  EmojiConvert
//
//  Created by zdy on 2017/1/5.
//  Copyright © 2017年 lianlian. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Emoji.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    NSString *emji = @"this is emoji = 🤗";
    NSLog(@"emji = %@",emji);
    
    NSString *unicode = [emji stringByReplacingEmojiUnicodeWithCheatCodes];
    NSLog(@"unicode = %@",unicode);
    
    [emji enumerateSubstringsInRange:NSMakeRange(0, [emji length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         NSString *hexstr = @"";
         for (int i = 0; i < [substring length] / 2 && ([substring length] % 2 == 0) ; i++)
         {
             hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X ",[substring characterAtIndex:i*2],[substring characterAtIndex:i*2+1]];
         }
         
         NSLog(@"(unicode) [%@]",hexstr);
     }];
    
    NSString *toEmoji = [unicode stringByReplacingEmojiCheatCodesWithUnicode];
    NSLog(@"toEmoji = %@",toEmoji);
}
@end
