functor

import
    Application(exit:Exit)
    System
    %List at './list.ozf'  
    Mdc
define
    % Tested: 
    %   - 1 2 3 +
    %   - 1 2 3 + +
    %   - 1 2 + 3 *
    %   - 1 2 3 p +
    %   - 1 2 3 + d

    local 
        Lexemes Tokens     
    in
        {System.showInfo "------------Task 2a-----------"}
        Lexemes = {Mdc.lex "1 2 3 + d"}
        {System.show Lexemes}

        {System.showInfo "\n------------Task 2b-----------"}
        Tokens = {Mdc.tokenize Lexemes}
        {System.show Tokens}
    end

    {System.showInfo "\n------------Task 2c-----------"}
    {System.show {Mdc.interpret {Mdc.tokenize {Mdc.lex "1 2 3 +"}}}}

    {System.showInfo "\n------------Task 2d-----------"}
    {System.show {Mdc.interpret {Mdc.tokenize {Mdc.lex "1 2 3 p +"}}}}

    {System.showInfo "\n------------Task 2e-----------"}
    {System.show {Mdc.interpret {Mdc.tokenize {Mdc.lex "1 2 3 + d"}}}}

    {System.showInfo "\n------------Task 2f-----------"}
    {System.show {Mdc.interpret {Mdc.tokenize {Mdc.lex "1 i 2 3 + + i"}}}}

    {System.showInfo "\n------------Task 2g-----------"}
    {System.show {Mdc.interpret {Mdc.tokenize {Mdc.lex "2 ^ 2 ^ +"}}}}

    {System.showInfo "\n------------Task 3a-----------"}
    {System.showInfo {Mdc.infix {Mdc.tokenize {Mdc.lex "3 3 +"}}}}

    {System.showInfo "\n------------Task 3b-----------"}
    {System.showInfo {Mdc.infix {Mdc.tokenize {Mdc.lex "3.0 10.0 9.0 * - 0.3 +"}}}}
    
    {Exit 0}
end
