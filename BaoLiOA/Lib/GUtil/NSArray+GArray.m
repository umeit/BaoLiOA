//
//  NSArray+CICArray.m
//  CarInfoCapture
//
//  Created by Liu Feng on 13-11-15.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "NSArray+GArray.h"

@implementation NSArray (GArray)

- (NSString *)oneStringFormat:(NSString *)separator
{
    NSMutableString *str = [[NSMutableString alloc] init];
//    for (NSString *s in self) {
//        [str appendString:[NSString stringWithFormat:@"#%@", s]];
//    }
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [str appendString:[NSString stringWithFormat:@"%@", obj]];
        }
        else {
            [str appendString:[NSString stringWithFormat:@"%@%@", separator ,obj]];
        }
    }];
    return str;
}

- (NSString *)jsonStringFormat
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"jsonStr error: %@", error.description);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
