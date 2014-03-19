//
//  GLB.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 18/03/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "GLB.h"

@implementation GLB

+(void) showMessage: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:message delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK" , nil];
    
    [alert show];
    
}

+(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",                                                                                      kCFStringEncodingUTF8 ));
    return encodedString;
}

+(NSString *) downloadSavePathFor:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:filename];
}
@end
