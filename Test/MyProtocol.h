//
//  MyProtocol.h
//  Test
//
//  Created by Igor Podpalchenko on 1/24/17.
//  Copyright © 2017 Igor Podpalchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyProtocol <NSObject>

- (void)signalStop;
- (void)signalLeftTurn;
- (void)signalRightTurn;


@end
