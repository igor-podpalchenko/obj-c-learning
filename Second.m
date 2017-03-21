//
//  Second.m
//  Test
//
//  Created by Igor Podpalchenko on 1/17/17.
//  Copyright © 2017 Igor Podpalchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Second.h"

@implementation NSTest

- (void) Swap: (int *) first second: (int *) second {
    int temp = *first;
    *first = *second;
    *second = temp;
}

- (void) PrintMessageA {
    NSLog(@"PrintMessageA called");
}

- (void) PrintArguments: (NSString*) arg1 Argument2: (NSString*) arg2 {
    NSLog(@" Arg1: %@ Arg2: %@", arg1, arg2);
}
- (NSString*) Concate: (NSString*) arg1 Argument2: (NSString*) arg2 {
    return [NSString stringWithFormat: @"%@%@", arg1, arg2];
}


@end
