//
//  ConexaoBuscarIndice.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndiceLivroResponse.h"

@interface MontadorDeIncideDoLivro : NSObject<NSXMLParserDelegate>{
    NSMutableString *valorElementoAtual;
    IndiceLivroResponse *indiceLivroResponse;
}

-(IndiceLivroResponse *)montarIndiceDoLivro:(NSString *)localIndiceXML;

@end
