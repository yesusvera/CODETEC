//
//  ObterEstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivroResponse.h"

@interface ObterEstanteIbracon : NSObject<NSXMLParserDelegate>{
    NSMutableArray *listaDeLivrosParaBaixar;
    NSMutableArray *listaDeLivrosBaixados;
    NSMutableArray *listaDeLivrosDeDireito;
    NSMutableString *valorNoAtual;
    LivroResponse *livro;
    NSString *erro;
    NSString *msgErro;
}
-(void)conectarObterEstante:(NSString *)_url;
-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString;
@property (nonatomic, retain) NSMutableArray *listaDeLivrosParaBaixar;
@property (nonatomic, retain) NSMutableArray *listaDeLivrosBaixados;
@property (nonatomic, retain) NSMutableArray *listaDeLivrosDeDireito;

@end
