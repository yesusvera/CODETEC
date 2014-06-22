//
//  LivrosBaixadosDAO.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 19/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "LivrosBaixadosDAO.h"
#import "LivroResponse.h"
#import "SCSQLite.h"

@implementation LivrosBaixadosDAO


- (BOOL)salvarAtualizarLivroBaixado:(LivroResponse *) livroBaixado{
    
    NSString *sql;
    if([self existeLivro:livroBaixado]){
        sql = @"update LivroBaixado set codigoLivro='%@', titulo='%@', versao='%@', codigoLoja='%@', foto='%@', arquivo='%@', arquivomobile='%@', indiceXML='%@', tipoLivro='%@' WHERE codigoLivro='%@'";
        BOOL isSave = [SCSQLite executeSQL:sql, livroBaixado.codigolivro, livroBaixado.titulo, livroBaixado.versao, livroBaixado.codigoloja, livroBaixado.foto, livroBaixado.arquivo, livroBaixado.arquivomobile, livroBaixado.indiceXML, livroBaixado.tipoLivro,livroBaixado.codigolivro];
        return isSave;
        
    }else{
        sql = @"insert into LivroBaixado (codigoLivro, titulo, versao, codigoLoja, foto, arquivo, arquivomobile, indiceXML, tipoLivro) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')";
        BOOL isSave = [SCSQLite executeSQL:sql, livroBaixado.codigolivro, livroBaixado.titulo, livroBaixado.versao, livroBaixado.codigoloja, livroBaixado.foto, livroBaixado.arquivo, livroBaixado.arquivomobile, livroBaixado.indiceXML, livroBaixado.tipoLivro];
        return isSave;
    }
}

- (BOOL)existeLivro:(LivroResponse *) livroBaixado{
    NSArray *results = [SCSQLite selectRowSQL:@"Select * from LivroBaixado where codigoLivro = '%@'", livroBaixado.codigolivro];
    return results.count > 0;
}

- (LivroResponse *) pesquisarLivroPeloCodigo: (NSString *) codigo{
    
    NSArray *results = [SCSQLite selectRowSQL:@"Select * from LivroBaixado where codigoLivro = '%@'", codigo];
    if(results.count > 0){
        NSDictionary *livroDictionary = [results objectAtIndex:0];
        
        LivroResponse *livroBaixado = [LivroResponse alloc];
        livroBaixado.codigolivro = [livroDictionary objectForKey:@"codigoLivro"];
        livroBaixado.titulo = [livroDictionary objectForKey:@"titulo"];
        livroBaixado.versao = [livroDictionary objectForKey:@"versao"];
        livroBaixado.codigoloja = [livroDictionary objectForKey:@"codigoLoja"];
        livroBaixado.foto = [livroDictionary objectForKey:@"foto"];
        livroBaixado.arquivo = [livroDictionary objectForKey:@"arquivo"];
        livroBaixado.arquivomobile = [livroDictionary objectForKey:@"arquivomobile"];
        livroBaixado.indiceXML = [livroDictionary objectForKey:@"indiceXML"];
        livroBaixado.tipoLivro = [livroDictionary objectForKey:@"tipoLivro"];
        
        return livroBaixado;
    }
    return nil;
}

- (NSMutableArray *) listaLivros{
    
    NSMutableArray *listaLivros = [[NSMutableArray alloc] init];
    
    NSArray *results = [SCSQLite selectRowSQL:@"Select * from LivroBaixado"];
    if(results.count > 0){
        LivroResponse *livroBaixado = [[LivroResponse alloc] init];
        
        NSDictionary *livroDictionary = [results objectAtIndex:0];
        livroBaixado.codigolivro = [livroDictionary objectForKey:@"codigoLivro"];
        livroBaixado.titulo = [livroDictionary objectForKey:@"titulo"];
        livroBaixado.versao = [livroDictionary objectForKey:@"versao"];
        livroBaixado.codigoloja = [livroDictionary objectForKey:@"codigoLoja"];
        livroBaixado.foto = [livroDictionary objectForKey:@"foto"];
        livroBaixado.arquivo = [livroDictionary objectForKey:@"arquivo"];
        livroBaixado.arquivomobile = [livroDictionary objectForKey:@"arquivomobile"];
        livroBaixado.indiceXML = [livroDictionary objectForKey:@"indiceXML"];
        livroBaixado.tipoLivro = [livroDictionary objectForKey:@"tipoLivro"];
        
        [listaLivros addObject:livroBaixado];
    }
    
    return listaLivros;
}

@end
