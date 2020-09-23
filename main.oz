functor

import
    Application(exit:Exit)
    System
    %List at './list.ozf'  
    Mdc
define
    local 
        Lexemes     
    in
        {System.showInfo "------------Task 1a-----------"}
        Lexemes = {Mdc.lex "1 2 + 3 *"}
        {System.show Lexemes}

        {System.showInfo "\n------------Task 1b-----------"}
        {System.show {Mdc.tokenize Lexemes}}
    end
    {Exit 0}
end
