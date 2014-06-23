//
//  NotasDAO.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 19/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "NotasDAO.h"
#import "SCSQLite.h"
#import "Nota.h"

@implementation NotasDAO


- (BOOL)salvarAtualizarNota:(Nota *) nota{
    
    NSString *sql;
    if([self existeNota:nota]){
        sql = @"update Nota set codigoLivro='%@', pagina='%@', nota='%@', titulo='%@' where codigoLivro='%@' and pagina='%@'";
        BOOL isSave = [SCSQLite executeSQL:sql, nota.codigolivro, nota.pagina, nota.nota, nota.titulo,nota.codigolivro, nota.pagina];
        return isSave;
    }else{
        sql = @"insert into Nota (codigoLivro, pagina, nota, titulo) values ('%@', '%@', '%@', '%@')";
        BOOL isSave = [SCSQLite executeSQL:sql, nota.codigolivro, nota.pagina, nota.nota, nota.titulo];
        return isSave;
    }
    
}
- (BOOL)existeNota:(Nota *) nota{
    NSArray *results = [SCSQLite selectRowSQL:@"Select * from Nota where codigoLivro = '%@' and pagina = '%@'", nota.codigolivro, nota.pagina];
    return results.count > 0;
}
- (NSMutableArray *) listaNotasPorCodLivro: (NSString *) codigoLivro{
    NSMutableArray *listaNotas = [[NSMutableArray alloc] init];
    
    NSArray *results = [SCSQLite selectRowSQL:@"Select * from Nota where codigoLivro = '%@'", codigoLivro];
    int i = 0;
    while(i < results.count){
        Nota *nota = [[Nota alloc] init];
        NSDictionary *notaDictionary = [results objectAtIndex:i];
    
        
        nota.codigolivro = [notaDictionary objectForKey:@"codigoLivro"];
        nota.pagina = [notaDictionary objectForKey:@"pagina"];
        nota.nota = [notaDictionary objectForKey:@"nota"];
        nota.titulo = [notaDictionary objectForKey:@"titulo"];
        
        [listaNotas addObject:nota];
        
        i++;
    }
    
    return listaNotas;
    
}
- (Nota *) pesquisarNotaPorPagina:(NSString *)pagina eCodigoDoLivro:(NSString *) codLivro{
    NSArray *results = [SCSQLite selectRowSQL:@"Select * from Nota where codigoLivro = '%@' and pagina = '%@'", codLivro, pagina];
    if(results.count > 0){
        Nota *nota = [[Nota alloc] init];
        NSDictionary *notaDictionary = [results objectAtIndex:0];
        
        nota.codigolivro = [notaDictionary objectForKey:@"codigoLivro"];
        nota.pagina = [notaDictionary objectForKey:@"pagina"];
        nota.nota = [notaDictionary objectForKey:@"nota"];
        nota.titulo = [notaDictionary objectForKey:@"titulo"];
        
        return nota;
    }
    return nil;
}
@end
