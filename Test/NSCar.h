#import <Foundation/Foundation.h>

@interface NSCar : NSObject

// Accessors
- (BOOL)isRunning;
- (void)setRunning:(BOOL)running;

@property (nonatomic, strong) NSString * model;

- (void)setModel:(NSString *)model;

// Calculated values
- (double)maximumSpeed;
- (double)maximumSpeedUsingLocale:(NSLocale *)locale;

// Action methods
- (void)startEngine;
- (void)driveForDistance:(double)theDistance;
- (void)driveFromOrigin:(id)theOrigin toDestination:(id)theDestination;
- (void)turnByAngle:(double)theAngle;
- (void)turnToAngle:(double)theAngle;

// Error handling methods
- (BOOL)loadPassenger:(id)aPassenger error:(NSError **)error;

// Constructor methods
- (id)initWithModel:(NSString *)aModel;
- (id)initWithModel:(NSString *)aModel mileage:(double)theMileage;

// Comparison methods
- (BOOL)isEqualToCar:(NSCar *)anotherCar;
- (NSCar *)fasterCar:(NSCar *)anotherCar;
- (NSCar *)slowerCar:(NSCar *)anotherCar;

// Factory methods
+ (NSCar *)car;
+ (NSCar *)carWithModel:(NSString *)aModel;
+ (NSCar *)carWithModel:(NSString *)aModel mileage:(double)theMileage;

// Singleton methods
+ (NSCar *)sharedCar;

@end
