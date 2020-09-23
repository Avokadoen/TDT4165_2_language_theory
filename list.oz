% We create a module. See http://mozart2.org/mozart-v1/doc-1.4.0/tutorial/node7.html#chapter.modules
functor
export
    length:Length
    take:Take
    drop:Drop
    append:Append
    position:Position
    member:Member
define  
    fun {Length L}
        case L of Head|Rest then
            1 + {Length Rest}
        else
            0
        end
    end

    fun {Take L Count} 
        if 0 >= Count then
            nil
        else
            case L of Head|Rest then
                local
                    NewCount
                in
                    NewCount = Count - 1
                    Head | {Take Rest NewCount}
                end
            else
                nil
            end
        end
    end

    fun {Drop L Count} 
        if 0 >= Count then
            L
        else
            case L of Head|Rest then
                local
                    NewCount
                in
                    NewCount = Count - 1
                    {Drop Rest NewCount}
                end
            else
                L
            end
        end
    end

    fun {Append L1 L2} 
        case L1 of Head|Rest then
            Head | {Append Rest L2}
        else 
            L2
        end
    end

    
    fun {Member L Element}
        case L of Head|Rest then
            if Element == Head then
                true
            else 
                {Member Rest Element}
            end
        else 
            false
        end
    end

    fun {Position L Element}
        case L of Head|Rest then
            if Element == Head then
                1
            else 
                1 + {Position Rest Element}
            end
        else 
            0
        end
    end
end