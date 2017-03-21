//
//  main.m
//  Test
//
//  Created by Igor Podpalchenko on 1/17/17.
//  Copyright © 2017 Igor Podpalchenko. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Second.h"
#import "MyProtocol.h"
#import <objc/runtime.h>
#import <AppKit/AppKit.h>
#import <CoreData/CoreData.h>


#define byte unsigned char

@class Person; // forward class reference

#pragma mark - Use pragma mark to logically organize your code

@interface Car : NSObject

@property (nonatomic) NSString *model;
@property (copy) NSString *model1;
@property (nonatomic, strong) Person *driver;

@end

#pragma mark - They also show up nicely in the properties/methods list in Xcode

@implementation Car: NSObject
@end

@interface Person : NSObject

@property (nonatomic) NSString *name;
@property (weak) Car *car;

@end

@implementation Person

- (NSString *) description {
    return self.name;
}

@end


struct XPoint {
    int x;
    int y;
    char *Name;
};


@interface TestClass : NSObject

- (void)sampleMethod;

- (NSString*) appendString: (NSString*) base Appender: (NSString*) end;

- (char *) prepareCString: (NSString*) str
            WhatToReplace: (NSString*) what
            WithToReplace: (NSString*) with;

- (int *) getRandom;

- (void) printX: (struct XPoint *) point;

- (void) modalHandler: (NSModalResponse*) returnCode
          contextInfo: (void*) contextInfo;


@property (copy) NSString *model;

+ (void)staticMethod;

@end

@implementation TestClass: NSObject

- (id)initWithModel:(NSString *)aModel {
    self = [super init];
    if (self) {
        // Any custom setup work goes here
        _model = [aModel copy];
    }
    return self;
}

- (void)sampleMethod{
    NSLog(@"Hello, World! \n");
}

- (void) modalHandler: (NSModalResponse*) returnCode
          contextInfo: (void*) contextInfo {
    if(*returnCode == NSModalResponseOK){
        NSLog(@"NSModalResponseOK");
    }
}

- (void) printX: (struct XPoint*) point {
    NSLog(@"X:%d Y:%d Name:%s", point->x, point->y, point->Name);
}

- (char *) prepareCString: (NSString*) str
        WhatToReplace: (NSString*) what
        WithToReplace: (NSString*) with
{
    str = [str stringByReplacingOccurrencesOfString:what withString:with];
    
    NSData *asciiData = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *asciiString = [[NSString alloc] initWithData:asciiData encoding:NSASCIIStringEncoding];
    
    unsigned long l = [asciiString length];
    static char buffer[100];
    
    if(![asciiString getCString:buffer maxLength:l+1 encoding:NSASCIIStringEncoding]){
        NSLog(@"Error");
    }
    
    return buffer;
}

- (NSString*) appendString:(NSString*) base Appender: (NSString*) end {
    NSString* temp = [base stringByAppendingString: end ];
    return temp;
}

-(NSString *) getEmployeeNameForID:(int) id withError:(NSError **)errorPtr{
    if(id == 1)
    {
        return @"Employee Test Name";
    }
    else
    {
        NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
        NSString *desc =@"Unable to complete the process";
        NSDictionary *userInfo = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:desc,
                                  @"NSLocalizedDescriptionKey",NULL];
        *errorPtr = [NSError errorWithDomain:domain code:-101
                                    userInfo:userInfo];
        return @"";
    }
}

+ (void) staticMethod {
    
    int a = sizeof(byte);
    
    NSLog(@"Static method \n");
    NSLog(@"Проверка Unicode %d", a);
    
}

/* function to generate and return random numbers */
- (int *) getRandom
{
    static int r[10];
    int i;
    
    /* set the seed */
    srand( (unsigned)time( NULL ) );
    
    for ( i = 0; i < 10; ++i)
    {
        r[i] = rand();
        NSLog( @"r[%d] = %d\n", i, r[i]);
        
    }
    
    return r;
}

@end

void TryMethods() {
    
    TestClass *sampleClass = [[TestClass alloc]init];
    
    [sampleClass sampleMethod];
    [TestClass staticMethod];
    
    NSString* appendedPart = @"End";
    
    NSLog(@"%@\r\n", [sampleClass appendString: @"Beginning " Appender: appendedPart]);
    NSLog(@"%@", appendedPart);
}

typedef void (^callbackWithInteger)(int);

void conditionalCallback(int val, callbackWithInteger value){
    if(val % 2 == 0){
        value(val);
    }
}

void TryBlocks() {
    
    // http://rypress.com/tutorials/objective-c/blocks
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Blocks/Articles/bxUsing.html
    
    // Define block variable & assign the value
    void (^simpleBlock)(NSString*) = ^(NSString* str) {
        NSLog(@"Appended via blocks: %@", str);
    };
    
    simpleBlock(@"Some text");
    
    // Blocks as anonymous functions
    char *myCharacters[3] = { "TomJohn", "George", "Charles Condomine" };
    
    qsort_b(myCharacters, 3, sizeof(char *), ^(const void *l, const void *r) {
        char *left = *(char **)l;
        char *right = *(char **)r;
        return strncmp(left, right, 1);
    });
    
    for(int i=0;i<3;i++) {
        NSLog(@"%s", myCharacters[i]);
    }
    
    // blocks can access local scope variable [make], but it accesses it via const copy
    //NSString *make = @"Honda";
    
    // __block modifier makes string mutable
    __block NSString *make = @"Honda";
    
    NSString *(^getFullCarName)(NSString *) = ^(NSString *model) {
        return [make stringByAppendingFormat:@" %@", model];
    };
    NSLog(@"%@", getFullCarName(@"Accord"));    // Honda Accord
    
    // Try changing the non-local variable (it won't change the block)
    make = @"Porsche";
    NSLog(@"%@", getFullCarName(@"911 Turbo")); // Honda 911 Turbo
    
    conditionalCallback(1, ^(int val) { NSLog(@"ERROR!"); });
    conditionalCallback(2, ^(int val) { NSLog(@"Callback working well!"); });
    
}

void TrySwap() {
    
    // creating custom class instance
    NSTest *test = [[NSTest alloc] init];
    
    int a = 5, b = 1;
    
    // swapping the values by passing the pointers via & (get address)
    [test Swap: &a second: &b];
    
    NSLog(@"a:%d b:%d", a, b);
}

void TryEncodings() {
    unichar ellipsis = 0x2026;
    NSString *theString = [NSString stringWithFormat:@"To be continued %C И русский", ellipsis];
    
    NSData *asciiData = [theString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *asciiString = [[NSString alloc] initWithData:asciiData encoding:NSASCIIStringEncoding];
    
    NSLog(@"Original: %@ (length %lu)", theString, (unsigned long)[theString length]);
    NSLog(@"Converted: %@ (length %lu)", asciiString, (unsigned long)[asciiString length]);
    
}

void TryReflection() {
    NSTest* test = [[NSTest alloc] init];
    
    if([test isKindOfClass:[NSString class]])
        NSLog(@"Error");
    
    if([test isKindOfClass:[NSTest class]])
        NSLog(@"Correct");
    
}

void TryPointers() {
    
    const char *cString = "This is regular null terminated C string";
    
    #define LEN(array) (sizeof (array) / sizeof (array)[0])
    #define ulong unsigned long
    
    strdup(cString);
    ulong length = strlen(cString);
    char x[length];
    
    if (strlen(cString) <= LEN(x)) {
        strcpy(x, cString);
    }
    else {
        NSLog(@"Garry we have a problems :(");
        return;
    }
    
    char* pch = strtok (x," ,.-");
    while (pch != NULL)
    {
        // "stream" type screen scanning, I can break the scanning cycle as soon as matching pattern found
        // compare performance of this approach with .NET or Java Explode() or Split()
        // "atomic" operatons of high level languages usually take much more CPU cycles
        printf ("%s\n",pch);
        pch = strtok (NULL, " ,.-");
    }

    
    NSLog(@"SizeOf: %lu", sizeof(cString));
    NSLog(@"strlen(): %lu", strlen(cString));
    
    int  var = 20;   /* actual variable declaration */
    int  *ip;        /* pointer variable declaration */
    
    ip = &var;  /* store address of var in pointer variable*/
    
    NSLog(@"Address of var variable: %p\n", &var  );
    
    /* address stored in pointer variable */
    NSLog(@"Address stored in ip variable: %p\n", ip );
    
    /* access the value using the pointer */
    NSLog(@"Value of *ip variable: %d\n", *ip );
    
    int  *ptr = NULL;
    
    NSLog(@"The value of ptr is : %p\n", ptr  );
}

void TryNumbers() {
    
    // You can't store primitive types in NSArray and Collections
    
    
    /*
    NSNumber *aBool = @NO;
    NSNumber *aChar = @'z';
    NSNumber *anInt = @2147483647;
    NSNumber *aUInt = @4294967295U;
    NSNumber *aLong = @9223372036854775807L;
    NSNumber *aFloat = @26.99F;
    NSNumber *aDouble = @26.99;
    */
    
    //#pragma unused (aBool)
    
    NSNumber *anInt2 = [NSNumber numberWithInt:42];
    float asFloat = [anInt2 floatValue];
    NSLog(@"%.2f", asFloat);
    NSString *asString = [anInt2 stringValue];
    NSLog(@"%@", asString);
}

void TryArrays() {
    // For-in loops ("Fast-enumeration," specific to Objective-C)
    NSArray *models = @[@"Ford", @"Honda", @"Nissan", @"Porsche"];
    for (id model in models) {
        NSLog(@"%@", model);
    }
    
    TestClass *test = [[TestClass alloc] init];
    int *p = [test getRandom];
    
    NSLog(@"Test of &:%p", p);
    
    for(int i=0;i<10;i++) {
        NSLog(@"address:%p val: %d", (p + i), *(p+i));
    }
    

}


void TryStructs() {
    
    typedef struct {
        unsigned char red;
        unsigned char green;
        unsigned char blue;
    } Color;
    
    Color carColor = {255, 160, 0};
    
    NSLog(@"%d", carColor.green);
    
    struct { // unnamed struct
        int x;
        int y;
    } point;
    
    point.x = 1;
    point.y = 2;

    struct XPoint pt;
    
    pt.Name = "struct test";
    pt.x = 911;
    pt.y = 99;
    
    NSLog(@"%s", pt.Name);
    
    TestClass *obj = [[TestClass alloc]init];
    [obj printX: &pt];
}

void TryEnums() {
    typedef enum {
        FORD,
        HONDA,
        NISSAN,
        PORSCHE
    } CarModel;
    
    CarModel myCar = NISSAN;
    switch (myCar) {
        case FORD:
        case PORSCHE:
            NSLog(@"You like Western cars?");
            break;
        case HONDA:
        case NISSAN:
            NSLog(@"You like Japanese cars?");
            break;
        default:
            break;
    }
    
    enum {
        InventoryNotLoadedError,
        InventoryEmptyError,
        InventoryInternalError
    };
    
    
    int i = InventoryEmptyError;
    
    NSLog(@"%d", i);
}

void ForwardDeclWithDoublePointer(char** ptr);

void TryCStuff() {
    
    //http://www.cyberforum.ru/blogs/18334/blog97.html
    
    // Init the string
    char *nStr = "World";
    
    // Cast it to void pointer
    const void *ptr = (void *) nStr;
    
    #define _char(i) ((char*) ptr)[i]
    
    NSLog(@"%c %c %c %c %c", _char(0), _char(1), _char(2), _char(3), _char(4));
    
    
    int year = 1967;          // Define a normal variable
    int *pointer;             // Declare a pointer that points to an int
    pointer = &year;          // Find the memory address of the variable
    NSLog(@"%d", *pointer);   // Dereference the address to get its value
    *pointer = 1990;          // Assign a new value to the memory address
    NSLog(@"%d", year);       // Access the value via the variable
    
    
    // Manualy calling "[test printX: x]"
    // Messaging via pure C
    
    TestClass *test = [TestClass new];
    
    struct XPoint x;
    
    x.Name = "X.NAME";
    x.x = 1;
    x.y = 10;
    
    SEL sel = sel_registerName("printX:");
    
    objc_msgSend(test, sel, &x);
    
    
    // Try playing with double pointer
    char *s = "this is the initial string";
    char *s2 = "this is another string";
    
    char **pr = &s;
    
    //ForwardDeclWithDoublePointer(pr);
    
    NSLog(@"Before: ---> %s", *pr); // print initial string
    
    *pr = s2;
    
    NSLog(@"After: ---> %s", *pr);
    
}

//void ForwardDeclWithDoublePointer(char** ptr) {
//    //NSLog(@"Before: ---> %s", *ptr); // print initial string
//    //static char *s2 = "this is another string";
//    //*ptr = &s2;
//}

void TryConvertion() {
    TestClass *obj = [[TestClass alloc] init];
    
    char *result = [obj prepareCString:@"This is the string" WhatToReplace: @" " WithToReplace: @"\r\n"];
    NSLog(@"%s", result);
}

void TryNSArray() {
    
    NSArray *array = @[@"sting", @"", @1];
    [array enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"className:%@ idx:%ld", [obj className], idx);
    }];
    
    
    NSArray *germanMakes = @[@"Mercedes-Benz", @"BMW", @"Porsche",
                             @"Opel", @"Volkswagen", @"Audi"];
    
    NSPredicate *beforeL = [NSPredicate predicateWithBlock:
                            ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                NSComparisonResult result = [@"R" compare:evaluatedObject];
                                if (result == NSOrderedDescending) {
                                    return YES;
                                } else {
                                    return NO;
                                }
                            }];
    NSArray *makesBeforeR = [germanMakes
                             filteredArrayUsingPredicate:beforeL];
    
    makesBeforeR = [makesBeforeR sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSLog(@"%@", [makesBeforeR componentsJoinedByString: @", "]);
    
    
    NSMutableString *ms = [NSMutableString new];
    
    [germanMakes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx < ([germanMakes count]-1))
            [ms appendFormat:@"%@-", obj];
        else
            [ms appendFormat:@"%@.", obj];
    }];
    
    NSLog(@"%@", ms);
    
    NSArray *jsFrameworks = @[@"jQuery", @"React", @"Angular", @"DoJo", @"Jasmine", @"Bootstrap", @"YUI", @"Google Closure", @"Modernizr"];
    NSArray *phpFrameworks = @[@"Zend", @"Symphony", @"Pear", @"Laravel", @"Yii", @"Bitrix", @"CakePHP"];
    
    NSArray *lastTwo = [jsFrameworks subarrayWithRange:NSMakeRange(4, 2)];
    NSLog(@"%@", lastTwo);
    
    NSArray *allMakes = [jsFrameworks arrayByAddingObjectsFromArray:phpFrameworks];
    NSLog(@"%@", allMakes);
    NSLog(@"%@", [allMakes componentsJoinedByString:@", "]);
    
    NSMutableArray *brokenCars = [NSMutableArray arrayWithObjects:
                                  @"Audi A6", @"BMW Z3",
                                  @"Audi Quattro", @"Audi TT", nil];
    
    // Change second item to Audi Q5
    [brokenCars replaceObjectAtIndex:1 withObject:@"Audi Q5"];

    
    [brokenCars addObject:@"BMW F25"];
    NSLog(@"%@", brokenCars);       // BMW F25 added to end
    [brokenCars removeLastObject];
    NSLog(@"%@", brokenCars);       // BMW F25 removed from end
    
}

void TryNSSortDescriptor() {
    
    NSDictionary *car1 = @{
                           @"make": @"Volkswagen",
                           @"model": @"Golf",
                           @"price": [NSDecimalNumber decimalNumberWithString:@"18750.00"]
                           };
    NSDictionary *car2 = @{
                           @"make": @"Volkswagen",
                           @"model": @"Eos",
                           @"price": [NSDecimalNumber decimalNumberWithString:@"35820.00"]
                           };
    NSDictionary *car3 = @{
                           @"make": @"Volkswagen",
                           @"model": @"Jetta A5",
                           @"price": [NSDecimalNumber decimalNumberWithString:@"16675.00"]
                           };
    NSDictionary *car4 = @{
                           @"make": @"Volkswagen",
                           @"model": @"Jetta A4",
                           @"price": [NSDecimalNumber decimalNumberWithString:@"16675.00"]
                           };
    NSMutableArray *cars = [NSMutableArray arrayWithObjects:
                            car1, car2, car3, car4, nil];
    
    NSSortDescriptor *priceDescriptor = [NSSortDescriptor
                                         sortDescriptorWithKey:@"price"
                                         ascending:YES
                                         selector:@selector(compare:)];
    NSSortDescriptor *modelDescriptor = [NSSortDescriptor
                                         sortDescriptorWithKey:@"model"
                                         ascending:YES
                                         selector:@selector(caseInsensitiveCompare:)];
    
    NSArray *descriptors = @[priceDescriptor, modelDescriptor];
    [cars sortUsingDescriptors:descriptors];
    NSLog(@"%@", cars);    // car4, car3, car1, car2
    
}

void TryNSDictionary() {
    
    // Literal syntax
    NSDictionary *inventory = @{
                                @"Mercedes-Benz SLK250" : [NSNumber numberWithInt:13],
                                @"Mercedes-Benz E350" : [NSNumber numberWithInt:22],
                                @"BMW M3 Coupe" : [NSNumber numberWithInt:19],
                                @"BMW X6" : [NSNumber numberWithInt:16],
                                };
    // Values and keys as arguments
    inventory = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:13], @"Mercedes-Benz SLK250",
                 [NSNumber numberWithInt:22], @"Mercedes-Benz E350",
                 [NSNumber numberWithInt:19], @"BMW M3 Coupe",
                 [NSNumber numberWithInt:16], @"BMW X6", nil];
    // Values and keys as arrays
    NSArray *models = @[@"Mercedes-Benz SLK250", @"Mercedes-Benz E350",
                        @"BMW M3 Coupe", @"BMW X6"];
    NSArray *stock = @[[NSNumber numberWithInt:13],
                       [NSNumber numberWithInt:22],
                       [NSNumber numberWithInt:19],
                       [NSNumber numberWithInt:16]];
    inventory = [NSDictionary dictionaryWithObjects:stock forKeys:models];
    NSLog(@"%@", inventory);
    
}

void TryMacros() {
    
    // Builtin
    NSLog(@"File :%s\n", __FILE__ );
    NSLog(@"Date :%s\n", __DATE__ );
    NSLog(@"Time :%s\n", __TIME__ );
    NSLog(@"Line :%d\n", __LINE__ );
    NSLog(@"ANSI :%d\n", __STDC__ );
    NSLog(@"Debug :%d\n", DEBUG );
    
    // Stringize
    #define  message_for(a, b)  \
        NSLog(@#a " and " #b ": We love you!\n")

    message_for(Igor, Lena);
    
    
    int token34 = 65;
    
    // Token pasting
    #define tokenpaster(n) NSLog (@"token" #n " = %d", token##n)
    
    tokenpaster(34);
    
    #if DEBUG == 0
    #define DebugLog(...)
    #elif DEBUG == 1
    #define DebugLog(...) NSLog(__VA_ARGS__)
    #endif
    
    DebugLog(@"Debug log");
}

void TryNSError() {
    
    TestClass *sampleClass = [[TestClass alloc]init];
    NSError *error = nil;
    NSString *name1 = [sampleClass getEmployeeNameForID:1 withError:&error];
    
    if(error)
    {
        NSLog(@"Error finding Name1: %@",error);
    }
    else
    {
        NSLog(@"Name1: %@",name1);
    }
    
    error = nil;
    
    NSString *name2 = [sampleClass getEmployeeNameForID:2 withError:&error];
    
    if(error)
    {
        NSLog(@"Error finding Name2: %@",error);
    }
    else
    {
        NSLog(@"Name2: %@",name2);
    }
    
    NSString *fileToLoad = @"/path/to/non-existent-file.txt";
    
    {
    NSError *error; //
    NSString *content = [NSString stringWithContentsOfFile:fileToLoad
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    if (content == nil) {
        // Method failed
        NSLog(@"Error loading file %@!", fileToLoad);
        NSLog(@"Domain: %@", error.domain);
        NSLog(@"Error Code: %ld", error.code);
        NSLog(@"Description: %@", [error localizedDescription]);
        NSLog(@"Reason: %@", [error localizedFailureReason]);
    } else {
        // Method succeeded
        NSLog(@"Content loaded!");
        NSLog(@"%@", content);
    }
    }

}

void TrySizeof() {
    //#define LEN(array) (sizeof (array) / sizeof (array)[0])
    
    const char *cString = "Null terminated"; // 15 symbols
    char charArray[] = "Char Array"; // 10 symbols
    
    NSLog(@"sizeof(int)=%lu",sizeof(int));
    NSLog(@"sizeof(10)=%lu",sizeof(10));
    NSLog(@"sizeof(const char *)=%lu",sizeof(const char *));
    NSLog(@"sizeof(\"Test C string\")=%lu", sizeof("Test C string"));
    NSLog(@"sizeof(*cString)=%lu",sizeof(cString));
    NSLog(@"sizeof(charArray)=%lu",sizeof(charArray));
    
    char *p = malloc (10 * sizeof(char));
    
    p[0] = 'H';
    p[1] = 'E';
    p[2] = 'L';
    p[3] = 'L';
    p[4] = 'O';
    p[5] = 0;
    p[6] = 'Z';
    p[7] = 'Z';
    p[8] = 'Z';
    
    NSLog(@"%s", p);
    
}

void TryProperties() {
    
    TestClass *obj = [[TestClass alloc] init];
    
    // Way 1 set
    obj.model = @"porsche cayenne";
    NSLog(@"obj.model = %@", obj.model);
    
    // Way 2 set
    [obj setModel:@"porsche panamera"];
    NSLog(@"obj.model = %@", obj.model);

    // Using custom ctor
    obj = [[TestClass alloc] initWithModel:@"Toyota Land Cruser"];
    NSLog(@"obj.model = %@", obj.model);
    
    
    
    Person *john = [[Person alloc] init];
    john.name = @"John";
    
    Car *honda = [[Car alloc] init];
    honda.model = @"Honda Civic";
    honda.driver = john;
    
    NSLog(@"%@ is driving the %@", honda.driver, honda.model);
    
}

void TryImmutable() {
    
    // NSString is immutable
    {
    // Setup two variables to point to the same string
    NSString * str1 = @"Hello World";
    NSString * str2 = str1;
    
    // "Replace" the second string
    str2 = @"Hello ikilimnik";
    
    // And list their current values
    NSLog(@"str1 = %@, str2 = %@", str1, str2);
    }
    
    {
    // Setup two variables to point to the same string
    NSMutableString * str1 = [NSMutableString stringWithString:@"Hello World"];
    NSMutableString * str2 = str1;
    
    // "Replace" the second string
    [str2 setString:@"Hello ikilimnik"];
    
    // And list their current values
    NSLog(@"str1 = %@, str2 = %@", str1, str2);
    }
    
    
    Car *car1;
    Person *driver;
    
    @autoreleasepool {
        
        // NSObject inheritors are mutable
        car1 = [[Car alloc] init];
        car1.model = @"A";
        car1.model1 = @"A";
        
        driver = [[Person alloc] init];
        car1.driver = driver;
        
        driver.car = car1; // This adds two ways reference. But it's marked as week
        
        Car *car2 = car1;
    
        car2.model = @"B"; // <- That will overwrite A
        car2.model1 = @"B"; // <- Does this create a copy in car2 ?
    
        NSLog(@"Car model: %@", car1.model);
        NSLog(@"Car model1 (copy): %@", car1.model1);
        
        car1 = nil;
    }
    
    NSLog(@"Nil is expected: %@", driver.car ? @"Non Nil" : @"Nil");
}

void TryWeekReference() {
    
    NSObject *strongOne = [[NSObject alloc] init];
    NSObject * __weak weakOne = strongOne; //count 1
    //NSObject * __strong weakOne = strongOne;
    
    // Does not work with the string as they are immutable
    //NSString *strongOne = @"val";
    //NSString * __weak weakOne = strongOne; //count 1

    @autoreleasepool {
        
        if (weakOne) {
            NSLog(@"weakOne is not nil."); //count 2
        } else {
            NSLog(@"weakOne is nil.");
        }
        
        strongOne = nil; // count 1
        
        if (weakOne) {
            NSLog(@"weakOne is not nil.");
        } else {
            NSLog(@"weakOne is nil.");
        }
        
    } // count 0, therefore the weakOne become nil
    
    if (weakOne) {
        NSLog(@"weakOne is not nil.");
    } else {
        NSLog(@"weakOne is nil.");
    }
}

void TrySelectors() {
    
    SEL step1 = @selector(PrintMessageA);
    SEL step2 = @selector(PrintArguments:Argument2:);
    SEL step3 = @selector(Concate:Argument2:);
    
    NSTest *obj = [[NSTest alloc] init];
    
    [obj performSelector:step1];
    
    [obj performSelector:step2
            withObject:@"ARGUMENT1"
            withObject:@"ARGUMENT2"
     ];
    
    NSString *result = [obj performSelector:step3
              withObject:@"ARGUMENT1"
              withObject:@"ARGUMENT2"
     ];
    
    NSLog(result);
    
    if([obj respondsToSelector:@selector(NotExist)])
    {
        NSLog(@"ERROR");
    }
    
    
    result = [obj performSelector:@selector(Concate:Argument2:) withObject:@"A" withObject:@"B"];
    
    NSLog(result);
    
}

@interface Window : NSObject<MyProtocol>

- (void)startPedaling;
- (void)removeFrontWheel;
- (void)lockToStructure:(id)theStructure;

@end

@implementation Window

- (void)signalStop {
    NSLog(@"Bending left arm downwards");
}

- (void)signalLeftTurn {
    NSLog(@"Extending left arm outwards");
}
- (void)signalRightTurn {
    NSLog(@"Bending left arm upwards");
}
- (void)startPedaling {
    NSLog(@"Here we go!");
}
- (void)removeFrontWheel {
    NSLog(@"Front wheel is off."
          "Should probably replace that before pedaling...");
}
- (void)lockToStructure:(id)theStructure {
    NSLog(@"Locked to structure. Don't forget the combination!");
}

@end

void TryProtocols() {
    
    id <MyProtocol> obj = [Window new];
    [obj signalLeftTurn];
    
    if ([obj conformsToProtocol:@protocol(MyProtocol)]) {
        [obj signalStop];
        [obj signalLeftTurn];
        [obj signalRightTurn];
    }
}

void GenerateException() {
    NSException *e = [NSException
                      exceptionWithName:@"CustomException"
                      reason:@"Test"
                      userInfo:nil];
    @throw e;
}

void TryExceptions() {
    @try {
        GenerateException();
        NSLog(@"ERROR, should not appear");
    } @catch(NSException *theException) {
        NSLog(@"An exception occurred: %@", theException.name);
        NSLog(@"Here are some details: %@", theException.reason);
        
        if(theException.name == NSInvalidArgumentException) {
            // the way to check exception type
        }
        
    } @finally {
        NSLog(@"Executing finally block");
    }
}

void TryNSAlert() {
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Delete the record?"];
    [alert setInformativeText:@"Deleted records cannot be restored."];
    [alert setAlertStyle:NSAlertStyleWarning];
    
    
//    [alert beginSheetModalForWindow:[alert window] completionHandler:^(NSModalResponse returnCode) {
//        NSLog(@"%@", returnCode);
//    }];
    
//    TestClass *obj = [TestClass new];
//    [alert beginSheetModalForWindow: modalDelegate:obj didEndSelector:@selector(modalHandler:returnCode:contextInfo:) contextInfo:nil];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        // OK clicked, delete the record
        //[self deleteRecord:currentRec];
        NSLog(@"Okay clicked");
    }
    
}

void TryNSString() {
    
    NSString *theString = @"this is the NSString";
    
    NSString *otherString = [theString stringByAppendingString:@" + other"];
    
    NSLog(@"Concate strings: %@", otherString);
    
    theString = @"test";
    otherString = [@"te" stringByAppendingString:@"st"];
    
    if(theString == otherString) {
        NSLog(@"should not happen");
    }
    else
    {
        NSLog(@"strings should be compared by isEqualToString method");
    }
    
    theString = @"Привет";
    unichar ch = [theString characterAtIndex:0];
    NSLog(@"%C", ch); // Not shown in debug, but fine at console.
    
    
    
    NSString *car = @"Porsche Boxster";
    if ([car isEqualToString:@"Porsche Boxster"]) {
        NSLog(@"That car is a Porsche Boxster");
    }
    if ([car hasPrefix:@"Porsche"]) {
        NSLog(@"That car is a Porsche of some sort");
    }
    if ([car hasSuffix:@"Carrera"]) {
        // This won't execute
        NSLog(@"That car is a Carrera");
    }
    
    { // Compare
        NSString *otherCar = @"Ferrari";
        NSComparisonResult result = [car compare:otherCar];
        if (result == NSOrderedAscending) {
            NSLog(@"The letter 'P' comes before 'F'");
        } else if (result == NSOrderedSame) {
            NSLog(@"We're comparing the same string");
        } else if (result == NSOrderedDescending) {
            NSLog(@"The letter 'P' comes after 'F'");
        }
    }
    
    { // Search
        NSString *car = @"Maserati GranCabrio";
        NSRange searchResult = [car rangeOfString:@"Cabrio"];
        if (searchResult.location == NSNotFound) {
            NSLog(@"Search string was not found");
        } else {
            NSLog(@"'Cabrio' starts at index %lu and is %lu characters long",
                  searchResult.location,        // 13
                  searchResult.length);         // 6
        }
    }
    
    {   // Substring
        NSString *car = @"Maserati GranTurismo";
        NSLog(@"%@", [car substringToIndex:8]);               // Maserati
        NSLog(@"%@", [car substringFromIndex:9]);             // GranTurismo
        NSRange range = NSMakeRange(9, 4);
        NSLog(@"%@", [car substringWithRange:range]);         // Gran
    }

    {   // Split
        NSString *models = @"Porsche,Ferrari,Maserati";
        NSArray *modelsAsArray = [models componentsSeparatedByString:@","];
        NSLog(@"%@", modelsAsArray[1]);
    }
    
    {   // Replace
        NSString *elise = @"Lotus Elise";
        NSRange range = NSMakeRange(6, 5);
        NSString *exige = [elise stringByReplacingCharactersInRange:range
                                                         withString:@"Exige"];
        NSLog(@"%@", exige);          // Lotus Exige
        NSString *evora = [exige stringByReplacingOccurrencesOfString:@"Exige"
                                                           withString:@"Evora"];
        NSLog(@"%@", evora);          // Lotus Evora
    }
    
}

void TryNSMutableSting() {
    
    {   // Creation
        NSMutableString *car = [NSMutableString stringWithString:@"Porsche 911"];
        [car setString:@"Porsche Boxster"];
    }
    
    {   // Editing
        NSMutableString *car = [NSMutableString stringWithCapacity:20];
        NSString *model = @"458 Spider";
        
        [car setString:@"Ferrari"];
        [car appendString:model];
        NSLog(@"%@", car);                    // Ferrari458 Spider
        
        [car setString:@"Ferrari"];
        [car appendFormat:@" %@", model];
        NSLog(@"%@", car);                    // Ferrari 458 Spider
        
        [car setString:@"Ferrari Spider"];
        [car insertString:@"458 " atIndex:8];
        NSLog(@"%@", car);                    // Ferrari 458 Spider
    }
    
    {   // Substings editing
        
        NSMutableString *car = [NSMutableString stringWithCapacity:20];
        [car setString:@"Lotus Elise"];
        [car replaceCharactersInRange:NSMakeRange(6, 5)
                           withString:@"Exige"];
        NSLog(@"%@", car);                               // Lotus Exige
        [car deleteCharactersInRange:NSMakeRange(5, 6)];
        NSLog(@"%@", car);                               // Lotus
    }
    
    
}

void TryNSSet() {
    
    // The end element should be nil reference
    NSSet *americanMakes = [NSSet setWithObjects:@"Chrysler", @"Ford", @"General Motors", nil];
    NSLog(@"%@", americanMakes);
    
    // Init based on array
    NSArray *japaneseMakes = @[@"Honda", @"Mazda",
                               @"Mitsubishi", @"Honda"];
    NSSet *uniqueMakes = [NSSet setWithArray:japaneseMakes];
    NSLog(@"%@", uniqueMakes);    // Honda, Mazda, Mitsubishi
    
    for(NSString *str in japaneseMakes) {
        NSLog(@"%@", str);
    }
    
    {   // Block type enumeration
    [japaneseMakes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *s = (NSString *) obj;
        NSRange range = [s rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"h"]];
        if(range.location != NSNotFound) {
            NSLog(@"%@",s);
        }
    }];
    
    }
    
    {   // Using the filtering predicate
        NSMutableSet *toyotaModels = [NSMutableSet setWithObjects:@"Corolla", @"Sienna",
                                      @"Camry", @"Prius",
                                      @"Highlander", @"Sequoia", nil];
        NSPredicate *startsWithC = [NSPredicate predicateWithBlock:
                                    ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                        if ([evaluatedObject hasPrefix:@"C"]) {
                                            return YES;
                                        } else {
                                            return NO;
                                        }
                                    }];
        [toyotaModels filterUsingPredicate:startsWithC];
        NSLog(@"%@", toyotaModels);    // Corolla, Camry
    }
    
    {   // Composition based on a different sets
        NSSet *japaneseMakes = [NSSet setWithObjects:@"Honda", @"Nissan",
                                @"Mitsubishi", @"Toyota", nil];
        NSSet *johnsFavoriteMakes = [NSSet setWithObjects:@"Honda", nil];
        NSSet *marysFavoriteMakes = [NSSet setWithObjects:@"Toyota",
                                     @"Alfa Romeo", nil];
        
        NSMutableSet *result = [NSMutableSet setWithCapacity:5];
        // Union
        [result setSet:johnsFavoriteMakes];
        [result unionSet:marysFavoriteMakes];
        NSLog(@"Either John's or Mary's favorites: %@", result);
        // Intersection
        [result setSet:johnsFavoriteMakes];
        [result intersectSet:japaneseMakes];
        NSLog(@"John's favorite Japanese makes: %@", result);
        // Relative Complement
        [result setSet:japaneseMakes];
        [result minusSet:johnsFavoriteMakes];
        NSLog(@"Japanese makes that are not John's favorites: %@",
              result);
    }
    
    
    {  // Removing set elements during iteration, via the copy
        NSMutableSet *makes = [NSMutableSet setWithObjects:@"Ford", @"Honda",
                               @"Nissan", @"Toyota", nil];
        NSArray *snapshot = [makes allObjects];
        for (NSString *make in snapshot) {
            NSLog(@"%@", make);
            if ([make hasPrefix:@"T"]) {
                [makes removeObject:@"Toyota"];
            }
        }
        NSLog(@"%@", makes);
    }
}

void TryNSDate() {
    NSDate *now = [NSDate date];
    NSTimeInterval secondsInWeek = 7 * 24 * 60 * 60;
    NSDate *lastWeek = [NSDate dateWithTimeInterval:-secondsInWeek
                                          sinceDate:now];
    NSDate *nextWeek = [NSDate dateWithTimeInterval:secondsInWeek
                                          sinceDate:now];
    NSLog(@"Last Week: %@", lastWeek);
    NSLog(@"Right Now: %@", now);
    NSLog(@"Next Week: %@", nextWeek);
    
    NSComparisonResult result = [now compare:nextWeek];
    if (result == NSOrderedAscending) {
        NSLog(@"now < nextWeek");
    } else if (result == NSOrderedSame) {
        NSLog(@"now == nextWeek");
    } else if (result == NSOrderedDescending) {
        NSLog(@"now > nextWeek");
    }
    NSDate *earlierDate = [now earlierDate:lastWeek];
    NSDate *laterDate = [now laterDate:lastWeek];
    NSLog(@"%@ is earlier than %@", earlierDate, laterDate);
    
    NSDateComponents *november4th2012 = [[NSDateComponents alloc] init];
    [november4th2012 setYear:2012];
    [november4th2012 setMonth:11];
    [november4th2012 setDay:4];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSLog(@"%@", [gregorian dateFromComponents:november4th2012]);
    
    
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    NSLog(@"Day: %ld", [components day]);
    NSLog(@"Month: %ld", [components month]);
    NSLog(@"Year: %ld", [components year]);
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setMonth:1];
    NSDate *oneMonthFromNow = [calendar dateByAddingComponents:comp
                                                        toDate:now
                                                       options:0];
    NSLog(@"%@", oneMonthFromNow);
    
    NSDate* sience = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    
    NSLog(@"%@", sience);
}

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        
        TryMethods();
        TryBlocks();
        TrySwap();
        TryEncodings();
        TryReflection();
        TryPointers();
        TryNumbers();
        TryArrays();
        TryStructs();
        TryConvertion();
        TryMacros();
        TryNSError();
        TrySizeof();
        TryProperties();
        TryImmutable();
        TryWeekReference();
        TrySelectors();
        TryProtocols();
        TryExceptions();
        TryCStuff();
        TryEnums();
        TryNSString();
        TryNSMutableSting();
        TryNSSet();
        TryNSArray();
        TryNSSortDescriptor();
        TryNSDictionary();
        TryNSDate();
        
        //TryNSAlert();
        
    }
    
    return 0;
}

