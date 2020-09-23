% We create a module. See http://mozart2.org/mozart-v1/doc-1.4.0/tutorial/node7.html#chapter.modules
functor
import
    System
export
    lex:Lex
    tokenize:Tokenize
    interpret:Interpret
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
                elseif Head == "p" then
                    Token = command(print)
                elseif Head == "d" then
                    Token = command(duplicate)
                elseif Head == "i" then
                    Token = command(flipSign)
                elseif Head == "^" then
                    Token = command(inverse)
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

    fun {Interpret Tokens} 
        fun {InnerInterpret Tokens Stack}
            case Tokens of operator(O)|TTail then
                case Stack of number(N1)|number(N2)|STail then
                    local 
                        Result 
                    in
                        case O of plus then
                            Result = number(N1 + N2)
                        [] minus then
                            Result = number(N1 - N2)
                        [] multiply then
                            Result = number(N1 * N2)
                        [] divide then 
                            Result =  number(N1 / N2)
                        end % TODO: we can have else with raise here
                        {InnerInterpret TTail Result|STail}
                    end
                else 
                    raise 
                        {VirtualString.toAtom "Invalid format exptected number number operator"}
                    end
                end
            [] command(C)|Tail then
                case C of print then
                    {System.show {List.reverse Stack}}
                    {InnerInterpret Tail Stack}
                [] duplicate then
                    {InnerInterpret Tail Stack.1|Stack}
                [] flipSign then
                    case Stack of Head|STail then
                        {InnerInterpret Tail number(~Head.1)|STail}
                    else 
                        {InnerInterpret Tail nil}
                    end
                [] inverse then
                    case Stack of Head|STail then
                        {InnerInterpret Tail number(1.0/Head.1)|STail}
                    else 
                        {InnerInterpret Tail nil}
                    end
                end 
            [] number(N)|Tail then
                {InnerInterpret Tail number(N)|Stack}
            else 
                {List.reverse Stack}
            end
        end 
    in
       {InnerInterpret Tokens nil}
    end

    fun {Infix Tokens}
        fun {InfixInternal Tokens ExpressionStack}
            case Tokens of number(N))|Tail then
                {InfixInternal Tail {Float.toString N}|ExpressionStack}
            [] operator(O)|Tail then
                local 
                    OChar 
                    Expr
                    Left = ExpressionStack.1
                    Right = ExpressionStack.2.1
                in
                    case O of plus then
                        OChar = '+'
                    [] minus then
                        OChar = '-'
                    [] multiply then
                        OChar = '*'
                    [] divide then 
                        OChar =  '/'
                    end
                    Expr = "("#Left#" "#Ochar#" "#Right#")"
                    {InfixInternal Tail Expr|ExpressionStack.2.2} % TODO: ExpressionStack.2 migth be nil
                end
            [] command(C)|Tail then
                {InfixInternal Tail ExpressionStack}
            end
        end
    in
        {InfixInternal Tokens nil}
    end
end