//
//  NSString+Luhn.m
//  HLLClock
//
//  Created by admin on 15/12/3.
//  Copyright © 2015年 HLL. All rights reserved.
//

#import "NSString+Luhn.h"

@implementation NSString (Luhn)

- (BOOL) checkoutBankCodeUseLuhn{
   
	if(!self){
	return NO;
	} 
    // 先取出来校验位，最后一位
    NSInteger length = self.length;
    NSString * luhnString = [self substringFromIndex:length - 1];
    NSInteger luhnInt = [luhnString integerValue];
    
    // 然后从右往左，基数位乘以2，超过10的数字相加替换原数字，ex，12 --> 1 + 2 = 3, 10 --> 1 + 0 = 1
    NSMutableArray * odds = [NSMutableArray array];// 奇数位的字符
    NSInteger oddSumInt = 0;// 奇数位的和
    NSInteger evenSumInt = 0;// 偶数位的和
    NSInteger index = 1;
    while (length > 0) {
        char codeChar = [self characterAtIndex:length - 1];
        if (index % 2) {// 取出来奇数位的字符
            [odds addObject:[NSString stringWithFormat:@"%c",codeChar]];
            int oddCodeInt = [[NSString stringWithFormat:@"%c",codeChar] intValue];
            oddSumInt += oddCodeInt * 2 % 10 + oddCodeInt * 2 / 10;
        }else{
            int evenCodeInt = [[NSString stringWithFormat:@"%c",codeChar] intValue];
            evenSumInt += evenCodeInt;
        }
        length -= 1;
        index += 1;
    };
    return (oddSumInt + evenSumInt + luhnInt) % 10;
}

@end
