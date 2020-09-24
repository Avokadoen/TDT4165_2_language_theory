% We create a module. See http://mozart2.org/mozart-v1/doc-1.4.0/tutorial/node7.html#chapter.modules
functor
import
    System
export
    lex:Lex
    tokenize:Tokenize
    interpret:Interpret
    infix:Infix
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
                    % Exception when we read an unknown character 
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
        % When we interpret, we build a stack that stores previous numbers
        fun {InnerInterpret Tokens Stack}
            % If we get a operator token
            case Tokens of operator(O)|TTail then
                % We expect there to be alteast two numbers in the stack
                case Stack of number(N1)|number(N2)|STail then
                    local 
                        Result 
                    in
                        % We then match the operator and perform said operation
                        case O of plus then
                            Result = number(N1 + N2)
                        [] minus then
                            Result = number(N1 - N2)
                        [] multiply then
                            Result = number(N1 * N2)
                        [] divide then 
                            Result = number(N1 / N2)
                        end % TODO: we can have else with raise here

                        {InnerInterpret TTail Result|STail}
                    end
                else 
                    % If we reach an operator and we do not have two numbers on the stack, we raise as this is an invalid state
                    raise 
                        {VirtualString.toAtom "Invalid format exptected number number operator"}
                    end
                end
            [] command(C)|Tail then
                case C of print then
                    {System.show {List.reverse Stack}}
                    {InnerInterpret Tail Stack}
                [] duplicate then
                    case Stack of Head|STail then
                        % On duplicate, we insert the head of the stack onto the stack
                        {InnerInterpret Tail Stack.1|Stack}
                    else 
                        {InnerInterpret Tail nil}
                    end
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
                % If we get a number token, we insert it onto the stack
                {InnerInterpret Tail number(N)|Stack}
            else 
                % When we are done reading tokens, we reverse the stack to extract result
                {List.reverse Stack}
            end
        end 
    in
       {InnerInterpret Tokens nil}
    end

    % TODO: omit parentheses when they are not needed
    fun {Infix Tokens}
        fun {InfixInternal Tokens ExpressionStack}
            case Tokens of number(N)|Tail then
                {InfixInternal Tail {Float.toString N}|ExpressionStack}
            [] operator(O)|Tail then
                local 
                    OChar 
                    Expr
                    Left = ExpressionStack.2.1
                    Right = ExpressionStack.1
                in
                    % Map operator token to char sign
                    case O of plus then
                        OChar = "+"
                    [] minus then
                        OChar = "-"
                    [] multiply then
                        OChar = "*"
                    [] divide then 
                        OChar = "/"
                    else 
                        raise 
                            {VirtualString.toAtom "Unrecognized operator "#OChar}
                        end
                    end
                    Expr = "("#Left#" "#OChar#" "#Right#")" 
                    % TODO: ExpressionStack.2 migth be nil
                    {InfixInternal Tail Expr|ExpressionStack.2.2} 
                end
            [] command(C)|Tail then
                % TODO: Implement commands?
                {InfixInternal Tail ExpressionStack}
            else  
                ExpressionStack
            end
        end
    in
        % Get the built expression from the stack
        {InfixInternal Tokens nil}.1
    end
end