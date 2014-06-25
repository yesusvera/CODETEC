//
//  GLB.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 18/03/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLB : NSObject
+(void) showMessage: (NSString *) message;
+(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
+(NSString *) downloadSavePathFor:(NSString *) filename;
+ (BOOL)validateCPFWithNSString:(NSString *)cpf;
@end
