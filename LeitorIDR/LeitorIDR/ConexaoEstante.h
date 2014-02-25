//
//  ObterEstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivroResponse.h"
#import "EstanteResponse.h"

@interface ConexaoEstante : NSObject<NSXMLParserDelegate>{
    EstanteResponse *estanteResponse;
    NSMutableString *valorNoAtual;
    LivroResponse *livro;
    NSString *erro;
    NSString *msgErro;
}
-(void)conectarObterEstante:(NSString *)_url;
-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
-(id)init;
@property (nonatomic, retain) EstanteResponse *estanteResponse;

@end
