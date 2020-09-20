

function subtract(d1::Dict, d2::Dict)
    res = Dict()
    for key in keys(d1)
        if key ∉ keys(d2)
            res[key] = nothing
        end
    end
    res
end


# using Sets instead
"""
    Subtract two sets.
    Result is a Set.
"""
function subtract(s1::Set, s2::Set)
    setdiff(s1, s2)
end



#   ---------- Duplicates ----------

# ... using dictionaries

function hasduplicates(t::Dict)
    d = Dict()
    for x in t
        if x ∈ d
            return true
        end
        d[x] = nothing
    end
    false
end

function usesonly(word, available)
    for letter in word
        if word ∉ available
            return false
        end
    end
    true
end


# ... using sets
function hasduplicates(t)
    length(Set(t)) < length(t)
end

function usesonly_set(word, available)
    Set(word) ⊆ Set(available)
end



# ---------- Math -----------

x = 0:0.1:2π

cos.(x) == 0.5*(ℯ.^(im*x) + ℯ.^(-im*x))


# ----------- Strings --------

function usesonly_regex(word::String, available::String)
    r = Regex("[^$(available)]")
    @show r;
    !occursin(r,word)
end

usesonly_regex("banana", "abn")
usesonly_regex("bananas", "abn")

match(r"[^abn]", "banana")

m = match(r"[^abn]", "bananas")


# ---------------- Matricies  -----------------

z = zeros(Float64, 2,3)

z[1,2] = 2

z[2,3] = 1
z

size(z)

# 1x3 row matrix
s = ones(String, 1, 3)
size(s)

# 3 x _ column matrix
s_col = ["", "", ""]
size(s_col)
s == s_col

# also a column matrix
s_col2 = ["";"";""]
size(s_col2)

s_col == s_col2

s == s_col2



a = [1 2 3; 4 5 6]

@show a
print(a)
size(a)

#slicing

u = z[:,2:end]

#broadcasting
@show im*u
size(im*u)
g = ℯ.^(im*u)
@show g
typeof(g)

typeof(u)




# ----------- Interfaces: p243 -----------------

#parametric type with no fields
struct Fibonacci{T<:Real} end

#outer constructor
Fibonacci(d::DataType) = d<:Real ? Fibonacci{d}() : error("Not Real type!")

# Iterator interface implementation: 2 parts:

# Part 1: called to initialize the iterator
Base.iterate(::Fibonacci{T}) where {T<:Real} = (zero(T), (one(T), one(T)))

# Part 2:
Base.iterate(::Fibonacci{T}, state::Tuple{T,T}) where {T<:Real} = (state[1], (state[2], state[1] + state[2]))

for e in Fibonacci(Int64)
    e > 100 && break
    print(e, " ")
end


#Equivalently:
f = Fibonacci(Int64)

#initialize state sequence
(a, (b,c)) = iterate(f)

#iterate ...
(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

(a, (b,c)) = iterate(f, (b,c))

#= a for loop in julia:

for i in iter
    body
end

    equivalant to:

next = iterate(iter)
while next !== nothing
    (i, state) = next
    body
    next = iterate(iter, state)
end

=#
