module Cards

export Suit, Card, Hand, ♣, ♢, ♡, ♠, ¬

import Base.Operators: *, ∩, ∪

"""
Encode a suit as a 2-bit value (low bits of a `UInt8`):

- 0 = ♣ (clubs)
- 1 = ♢ (diamonds)
- 2 = ♡ (hearts)
- 3 = ♠ (spades)

The suits have global constant bindings: `♣`, `♢`, `♡`, `♠`.
"""
struct Suit
    i::UInt8
    Suit(s::Integer) = 0 ≤ s ≤ 3 ? new(s) :
        throw(ArgumentError("invalid suit number: $s"))
end

char(s::Suit) = Char(0x2663-s.i)
Base.string(s::Suit) = string(char(s))
Base.show(io::IO, s::Suit) = print(io, char(s))

const ♣ = Suit(0)
const ♢ = Suit(1)
const ♡ = Suit(2)
const ♠ = Suit(3)

const suits = [♣, ♢, ♡, ♠]

"""
Encode a playing card as a 6-bit integer (low bits of a `UInt8`):

- low bits represent rank from 0 to 15
- high bits represent suit (♣, ♢, ♡ or ♠)

Ranks are assigned as follows:

- numbered cards (2 to 10) have rank equal to their number
- jacks, queens and kings have ranks 11, 12 and 13
- there are low and high aces with ranks 1 and 14
- there are low and high jokers with ranks 0 and 15

This allows any of the standard orderings of cards ranks to be
achieved simply by choosing which aces or which jokers to use.
There are a total of 64 possible card values with this scheme,
represented by `UInt8` values `0x00` through `0x3f`.
"""
struct Card
    value::UInt8
end

function Card(r::Integer, s::Suit)
    0 ≤ r ≤ 15 || throw(ArgumentError("invalid card rank: $r"))
    return Card((s.i << 4) | (r % UInt8))
end

suit(c::Card) = Suit((0x30 & c.value) >>> 4)
rank(c::Card) = (c.value & 0x0f) % Int8

function Base.show(io::IO, c::Card)
    r = rank(c)
    if 1 ≤ r ≤ 14
        r == 10 && print(io, '1')
        print(io, "1234567890JQKA"[r])
    else
        print(io, '\U1f0cf')
    end
    print(io, suit(c))
end

*(r::Integer, s::Suit) = Card(r, s)

for s in "♣♢♡♠", (r,f) in zip(11:14, "JQKA")
    ss = Symbol(s)
    sc = Symbol("$f$s")
    @eval begin
        const $sc = Card($r,$ss)
        export $sc
    end
end

struct Hand <: AbstractSet{Card}
    cards::UInt64
    Hand(cards::UInt64) = new(cards)
end

index(c::Card) = one(UInt64) << c.value

"""
Represent a hand (set) of cards using a `UInt64` bit set.
"""
function Hand(cards)
    hand = Hand(zero(UInt64))
    for card in cards
        card isa Card || throw(ArgumentError("not a card: $repr(card)"))
        hand = Hand(hand.cards | index(card))
    end
    return hand
end

Base.length(h::Hand) = count_ones(h.cards)
Base.in(c::Card, h::Hand) = (index(c) & h.cards) != 0

function Base.show(io::IO, hand::Hand)
    print(io, "Hand([")
    n = 63 - leading_zeros(hand.cards)
    for value = 0:n
        card = Card(value)
        if card in hand
            print(io, card)
            value < n && print(io, ", ")
        end
    end
    print(io, "])")
end

∪(a::Hand, b::Hand) = Hand(a.cards | b.cards)
∩(a::Hand, b::Hand) = Hand(a.cards & b.cards)

const deck = Hand(Card(r,s) for s in suits for r = 2:14)

@eval ¬(h::Hand) = Hand($(deck.cards) & ~h.cards)
@eval Base.rand(::Type{Hand}) = Hand($(deck.cards) & rand(UInt64))

end # module
