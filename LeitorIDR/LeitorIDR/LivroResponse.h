//
//  LivroResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivroResponse : NSObject{
    NSString *codigoLivro;
    NSString *titulo;
    NSString *versao;
    NSString *codigoLoja;
    NSString *foto;
    NSString *arquivo;
}

@property(nonatomic, retain) NSString *codigoLivro;
@property(nonatomic, retain) NSString *titulo;
@property(nonatomic, retain) NSString *versao;
@property(nonatomic, retain) NSString *codigoLoja;
@property(nonatomic, retain) NSString *foto;
@property(nonatomic, retain) NSString *arquivo;

@end
