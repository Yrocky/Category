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
   
    NSString * cardNum = self;
    if (cardNum && cardNum.length>15)
    {
        int oddsum = 0;     //奇数求和
        int evensum = 0;    //偶数求和
        int allsum = 0;
        int cardNoLength = (int)[cardNum length];
        int lastNum = [[cardNum substringFromIndex:cardNoLength-1] intValue];
        
        cardNum = [cardNum substringToIndex:cardNoLength - 1];
        for (int i = cardNoLength -1 ; i>=1;i--) {
            NSString *tmpString = [cardNum substringWithRange:NSMakeRange(i-1, 1)];
            int tmpVal = [tmpString intValue];
            if (cardNoLength % 2 ==1 ) {
                if((i % 2) == 0){
                    tmpVal *= 2;
                    evensum += (tmpVal / 10 + tmpVal % 10);
                }else{
                    oddsum += tmpVal;
                }
            }else{
                if((i % 2) == 1){
                    tmpVal *= 2;
                    evensum += (tmpVal / 10 + tmpVal % 10);
                }else{
                    oddsum += tmpVal;
                }
            }
        }
        
        allsum = oddsum + evensum;
        allsum += lastNum;
        return (allsum % 10) == 0;
    }
    return NO;
}

@end
