% We create a module. See http://mozart2.org/mozart-v1/doc-1.4.0/tutorial/node7.html#chapter.modules
functor
import
    List at './list.ozf'
export
    lex:Lex
    tokenize:Tokenize
define  
    fun {Lex Str}
        {String.tokens Str 32}
    end

    fun {Tokenize Lexemes}
        case Lexemes of Head|Tail then
            local 
                Token 
            in
                if {Or {String.isInt Head} {String.isFloat Head}} then
                    Token = number({String.toFloat Head})
                elseif Head == "+" then
                    Token = operator(plus)
                elseif Head == "-" then
                    Token = operator(minus)
                elseif Head == "*" then
                    Token = operator(multiply)
                elseif Head == "/" then
                    Token = operator(divide)
                else 
                    raise 
                        {VirtualString.toAtom "Unrecognized character"#Head}
                    end
                end 
                Token | {Tokenize Tail}
            end
        else
            nil
        end
    end
end