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
        case L of Head|Tail then
            1 + {Length Tail}
        else
            0
        end
    end

    fun {Take L Count} 
        if 0 >= Count then
            nil
        else
            case L of Head|Tail then
                local
                    NewCount
                in
                    NewCount = Count - 1
                    Head | {Take Tail NewCount}
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
            case L of Head|Tail then
                local
                    NewCount
                in
                    NewCount = Count - 1
                    {Drop Tail NewCount}
                end
            else
                L
            end
        end
    end

    fun {Append L1 L2} 
        case L1 of Head|Tail then
            Head | {Append Tail L2}
        else 
            L2
        end
    end

    
    fun {Member L Element}
        case L of Head|Tail then
            if Element == Head then
                true
            else 
                {Member Tail Element}
            end
        else 
            false
        end
    end

    fun {Position L Element}
        case L of Head|Tail then
            if Element == Head then
                1
            else 
                1 + {Position Tail Element}
            end
        else 
            0
        end
    end
end