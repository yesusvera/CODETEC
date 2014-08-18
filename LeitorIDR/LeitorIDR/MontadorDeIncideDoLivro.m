//
//  ConexaoBuscarIndice.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "MontadorDeIncideDoLivro.h"
#import "ItemDoIndice.h"

@implementation MontadorDeIncideDoLivro{
    //Níveis de índice, considerei até oito níveis de </itens>, mudar depois para um simples array dinâmico.
    ItemDoIndice *itemNivel1;
    ItemDoIndice *itemNivel2;
    ItemDoIndice *itemNivel3;
    ItemDoIndice *itemNivel4;
    ItemDoIndice *itemNivel5;
    ItemDoIndice *itemNivel6;
    ItemDoIndice *itemNivel7;
    ItemDoIndice *itemNivel8;

    NSInteger nivel;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"indice"]){
        indiceLivroResponse = [[IndiceLivroResponse alloc] init];
        indiceLivroResponse.indice = [[NSMutableArray alloc]init];
        nivel = 1;
    }
    
    if ([elementName isEqualToString:@"item" ]){
        if(nivel==1){
            itemNivel1 = [[ItemDoIndice alloc]init];
            itemNivel1.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==2){
            itemNivel2 = [[ItemDoIndice alloc]init];
            itemNivel2.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==3){
            itemNivel3 = [[ItemDoIndice alloc]init];
            itemNivel3.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==4){
            itemNivel4 = [[ItemDoIndice alloc]init];
            itemNivel4.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==5){
            itemNivel5 = [[ItemDoIndice alloc]init];
            itemNivel5.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==6){
            itemNivel6 = [[ItemDoIndice alloc]init];
            itemNivel6.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==7){
            itemNivel7 = [[ItemDoIndice alloc]init];
            itemNivel7.listaItens = [[NSMutableArray alloc]init];
        }else if(nivel==8){
            itemNivel8 = [[ItemDoIndice alloc]init];
            itemNivel8.listaItens = [[NSMutableArray alloc]init];
        }
    }else if([elementName isEqualToString:@"itens"]){
        nivel++;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(!valorElementoAtual)
    {
        valorElementoAtual = [[NSMutableString alloc]initWithString:string];
    }
    else
    {
        [valorElementoAtual appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"response"] || [elementName isEqualToString:@"livro"] || [elementName isEqualToString:@"indice"] ){
        return;
    }else if([elementName isEqualToString:@"erro"]){
        [indiceLivroResponse setErro:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ];
    }else if([elementName isEqualToString:@"msgErro"]){
        [indiceLivroResponse setMsgErro:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ];
    }else if([elementName isEqualToString:@"item"]){
        if(nivel==1){
            [indiceLivroResponse.indice addObject:itemNivel1];
        }else if(nivel==2){
            [[itemNivel1 listaItens] addObject:itemNivel2];
        }else if(nivel==3){
            [[itemNivel2 listaItens] addObject:itemNivel3];
        }else if(nivel==4){
            [[itemNivel3 listaItens] addObject:itemNivel4];
        }else if(nivel==5){
            [[itemNivel4 listaItens] addObject:itemNivel5];
        }else if(nivel==6){
            [[itemNivel5 listaItens] addObject:itemNivel6];
        }else if(nivel==7){
            [[itemNivel6 listaItens] addObject:itemNivel7];
        }else if(nivel==8){
            [[itemNivel7 listaItens] addObject:itemNivel8];
        }

    }else if([elementName isEqualToString:@"itens"]){
        nivel--;
    }else{
        if(nivel==1){
            [itemNivel1 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==2){
            [itemNivel2 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==3){
            [itemNivel3 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==4){
            [itemNivel4 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==5){
            [itemNivel5 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==6){
            [itemNivel6 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==7){
            [itemNivel7 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }else if(nivel==8){
            [itemNivel8 setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName] ;
        }

    }

    valorElementoAtual = nil;
    
}

-(IndiceLivroResponse *)montarIndiceDoLivro:(NSString *) localIndiceXML{
    
    NSLog(@"%@", localIndiceXML);
    NSString *thumbnailsPath = localIndiceXML;
    NSData *data = [[NSData alloc] initWithContentsOfFile:thumbnailsPath];
    
    NSString *corpoXML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", corpoXML);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSLog(@"%@", parser);
    [parser setDelegate:self];
    
    if(![parser parse]){
        NSLog(@"Erro ao realizar o parse");
    }else{
        NSLog(@"Ok Parse");
        
    }
    
    return indiceLivroResponse;

}


@end
