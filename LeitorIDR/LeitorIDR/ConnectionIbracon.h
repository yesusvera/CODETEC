//
//  ConnectionIbracon.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 02/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrarLivroResponse.h"

@interface ConnectionIbracon : NSObject <NSXMLParserDelegate>{
    RegistrarLivroResponse *registrarLivroResponse;
    NSMutableString *valorElementoAtual;
}


-(void)registrarDispositivo:(NSString *)_url indicadorCarregando:(UIActivityIndicatorView *)indicadorAtividade controller:(UIViewController *)controlador documento:(NSString *) documento senha:(NSString *) senha;

-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;

@end
