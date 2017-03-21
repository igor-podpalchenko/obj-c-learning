//
//  Second.h
//  Test
//
//  Created by Igor Podpalchenko on 1/18/17.
//  Copyright © 2017 Igor Podpalchenko. All rights reserved.
//

@interface NSTest : NSObject

- (void) Swap: (int *) first second: (int *) second;

- (void) PrintMessageA;
- (void) PrintArguments: (NSString*) arg1 Argument2: (NSString*) arg2;
- (NSString*) Concate: (NSString*) arg1 Argument2: (NSString*) arg2;

@end


