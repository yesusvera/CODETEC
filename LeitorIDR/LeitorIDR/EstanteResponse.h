//
//  EstanteResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 24/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstanteResponse : NSObject{
    NSMutableArray *listaDeLivrosParaBaixar;
    NSMutableArray *listaDeLivrosBaixados;
    NSMutableArray *listaDeLivrosDeDireito;
}
@property (nonatomic, retain) NSMutableArray *listaDeLivrosParaBaixar;
@property (nonatomic, retain) NSMutableArray *listaDeLivrosBaixados;
@property (nonatomic, retain) NSMutableArray *listaDeLivrosDeDireito;
@end
