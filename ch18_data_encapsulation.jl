


suffixes = Dict()
prefix = []

struct Markov
    order :: Int64
    suffixes :: Dict{Tuple{String, Vararg{String}}, Array{String, 1}}
    prefix :: Array{String, 1}
end

function Markov(order::Int64=2)
    new(order, Dict{Tuple{String, Vararg{String}}, Array{String, 1}}(), Array{String, 1}())
end

function processword(markov::Markov, word::String)
    if length(markov.prefix) < markov.order
        push!(markov.prefix, word)
        return
    end
end


# do blocks: page 226

data = "This here's the wattle,\nthe emblem of our land.\n"

open("output.txt", "w+") do fout
    write(fout, data)
end

f = (fout) -> begin
write(fout, data)
