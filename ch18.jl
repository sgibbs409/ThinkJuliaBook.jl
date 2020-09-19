

const suit_names = ["♣", "♢", "♡", "♠"]
const rank_names = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

struct Card
    suit:: Int64
    rank:: Int64
    function Card(suit::Int64, rank::Int64)
        @assert(1 ≤ suit ≤ 4, "suit is not between 1 and 4")
        @assert(1 ≤ rank ≤ 13, "rank is not between 1 and 13")
        new(suit, rank)
    end
end

function Base.show(io::IO, card::Card)
    print(io, rank_names[card.rank], suit_names[card.suit])
end

qd = Card(2, 12)
kh = Card(3,13)

import Base.isless
function isless(c1::Card, c2::Card)
    (c1.suit, c1.rank) < (c2.suit, c2.rank)
end

qd < kh
kh < qd


using Test
@test Card(1, 4) < Card(2, 4)
@test Card(1, 3) < Card(1, 4)
# @test Card(1, 4) < Card(1, 3)


abstract type CardSet<:Any end

struct Deck <: CardSet
    cards :: Array{Card, 1}
end

function Deck()
    deck = Deck(Card[])
    for suit in 1:4
        for rank in 1:13
            push!(deck.cards, Card(suit, rank))
        end
    end
    deck
end

function Base.show(io::IO, deck::Deck)
    for card in deck.cards
        print(io, card, " ")
    end
    println(io)
end

Deck()


function Base.pop!(deck::Deck)
    pop!(deck.cards)
end

function Base.push!(deck::Deck, card::Card)
    push!(deck.cards, card)
    #deck
    nothing
end

using Random

function Random.shuffle!(deck::Deck)
    shuffle!(deck.cards)
    deck
end

d = Deck()

Random.shuffle!(d)
d

function Base.sort!(deck::Deck)
    sort!(deck.cards)  #uses Base.isless(::Card, ::Card)
    deck
end

d
sort!(d)
d



d isa Deck

d isa CardSet

struct Hand <: CardSet
    cards :: Array{Card,1}
    label :: String
end

function Hand(label::String="")
    Hand(Card[], label)
end

hand = Hand("my new hand")

hand

function Base.show(io::IO, cs::CardSet)
    for card in cs.cards
        print(io, card, " ")
    end
end

function Base.pop!(cs::CardSet)
    pop!(cs.cards)
end

function Base.push!(cs::CardSet, card::Card)
    push!(cs.cards, card)
    nothing
end

deck = Deck()
deck

push!(hand, Card(3,3))
push!(hand, Card(3,9))
@show hand
pop!(hand)
pop!(hand)

@show deck;
push!(hand, pop!(deck))
@show hand
@show deck



function move!(cs1::CardSet, cs2::CardSet, n::Int)
    @assert 1 ≤ n ≤ length(cs1.cards)
    for i in 1:n
        card = pop!(cs1)
        push!(cs2, card)
    end
    nothing
end

move!(deck, hand, 12)

@show deck;
@show hand;
