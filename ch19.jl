
f = x -> x^2 + 2x - 1


# ---------------
using Plots
plot(f, 0, 10, xlabel="x", ylabel="y")

function myplot(x, y; style=:solid, width=1, color=:black)
    plot(x, y, style=style, width=width, color=color)
end


x = collect(0:10)
y = f.(x)
myplot(x,y)
myplot(x, y, style=:dot, color=:blue)




# ---------- let Blocks --------

x, y, z = -1, -1, -1

@show x y z;

let x = 1, z
    @show x y z;
end

@show x y z;

# ---------- Tasks (aka Coroutines) --------

#=
    A task is a control structure that can pass control cooperatively
    without returning.  A task is implemented as a function having as its first
    argument a Channel object.  A Channel is used to pass values from the
    function to a calee.
=#


"""
    fib(c::Channel)

    Generates a Fibonacci sequence.  Suspended after each call to put!.
"""
function fib(c::Channel)
    a = 0
    b = 1
    put!(c, a)        # suspends, waits for channel to clear
    while true
        put!(c, b)    #suspends
        (a, b) = (b, a+b)
    end
end

fibgen = Channel(fib);
take!(fibgen)
take!(fibgen)
take!(fibgen)
take!(fibgen)
take!(fibgen)
take!(fibgen)
take!(fibgen)
take!(fibgen)

for val in Channel(fib)
    print(val, " ")
    val > 30 && break
end



# ------- Types --------



#=
    A concrete type consisting of just bits is a primitive type.
    Julia allows you to declare your own primitive types.

    The standard types are defined as:

    primitive type Float64 <: AbstractFloat 64 end
    primitive type  Bool <: Integer 8 end
    primitive type Char <: AbstractChar 32 end
    primitive type Int64 <: Signed 64 end
=#

# Create primitive type Byte and constructor
primitive type Byte 8 end
Byte(val::UInt8) = reinterpret(Byte,val)

b = Byte(0x1d);
typeof(b)
@show b;

# c = Byte(0xfff) # ERROR: MethodError: no method matching Byte(::UInt16)


# Parametric types

struct Point{T<:Real}
    x::T
    y::T
    Point{T}(x,y) where {T<:Real} = new(x,y)   # same as default inner constructor
end

"""
    default outer constructor.
    x, y have same type
"""
Point(x::T, y::T) where {T<:Real} = Point{T}(x,y)





p = Point(0.0, 0.0)
q = Point(3, 4)

#=
struct Point{T<:Int64}
    x::T
    y::T
end     #invalid redefinition of constant Point
=#


mp = IntPoint(3, 4)
# Type Unions

#  Efficient code can be generated when a type union has a small number of types
IntOrString = Union{Int64, String}
150 :: IntOrString
"Hello World" :: IntOrString
# 150 :: String      # TypeError

# -------- Methods ----------

# -------- Parametric Methods -------
isintpoint(p::Point{T}) where {T} = (T === Int64)
q
p
isintpoint(q)
isintpoint(p)

# -------- Functors ---------

struct Polynomial{R}
    coeff::Vector{R}
end

# Define a functor on instances of Polynomial
function (p::Polynomial)(x)
    val = p.coeff[end]
    for coeff in p.coeff[end-1:-1:1]
        val = val * x + coeff
    end
    val
end


# p(x) = 100x² + 10x + 1
p = Polynomial([1,10,100])
p(3)



#= -------- Conversion and Promotion ---------- =#

# Conversion
x = 12
typeof(x)

y = convert(UInt8, x)

typeof(y)
y
typeof(x)
x


Point{Int64} isa Type{Point{Int64}}
#Point{Int64} isa Point{Int64}
#typeof(Point{Int64})

Base.convert(::Type{Point{T}}, x::Array{T, 1}) where {T<:Real} = Point(x...)
c = convert(Point{Int64}, [1,2]);
c

# Promotion

promote(1, 2.5, 3)

# specify promotion behavior using promote_rule

# promote_rule(::Type{Float64}, ::Type{Int32}) = Float64
