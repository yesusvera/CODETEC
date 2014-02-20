//
//  ParaBaixarResponse.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivroResponse.h"

@interface ParaBaixarResponse : NSObject{
    LivroResponse *livroParaBaixar;
    NSMutableArray *listaDeLivrosParaBaixar;
}

@property(nonatomic, retain) LivroResponse *livroParaBaixar;
@property(nonatomic, retain) NSMutableArray *listaDeLivrosParaBaixar;



@end
