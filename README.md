# Cards

[![Build Status](https://travis-ci.org/StefanKarpinski/Cards.jl.svg?branch=master)](https://travis-ci.org/StefanKarpinski/Cards.jl)

[![Coverage Status](https://coveralls.io/repos/StefanKarpinski/Cards.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/StefanKarpinski/Cards.jl?branch=master)

[![codecov.io](http://codecov.io/github/StefanKarpinski/Cards.jl/coverage.svg?branch=master)](http://codecov.io/github/StefanKarpinski/Cards.jl?branch=master)

This package defines three types:

* `Suit`: uses 2 low bits of a `UInt8` to represent four suits of cards: ♣, ♢, ♡, ♠.

* `Card`: uses 6 low bits of a `UInt8` to represent 64 possible card values:
  * 2 bits for the `Suit` (♣, ♢, ♡, ♠)
  * 4 bits for the rank from 0-15, meaning:
    * 0 – low joker
    * 1 – low ace
    * 2-10 – numbered cards
    * 11 – jack
    * 12 – queen
    * 13 – king
    * 14 – high ace
    * 15 – high joker

* `Hand`: uses 64 bits of a `UInt64` to represent all possible hands (sets) of cards.

The design of having both high and low aces and jokers allows hands from many different games to be represented in a single scheme, with consistent rank ordering. If you're representing hands from a game with aces high, use the `A♣`, `A♢`, `A♡`, `A♠` cards; if you're representing hands from a game with aces low, use the `1♣`, `1♢`, `1♡`, `1♠` cards instead.

## Example usage:

```julia
julia> using Cards

julia> hand = rand(Hand)
Hand([2♣, 3♣, 6♣, 7♣, 8♣, 9♣, 2♢, 3♢, 4♢, 7♢, 10♢, J♢, A♢, 4♡, 5♡, 6♡, 7♡, Q♡, K♡, A♡, 4♠, 6♠, 9♠, K♠, A♠])

julia> 2♣ in hand
true

julia> 4♣ in hand
false

julia> A♣ in hand
false

julia> A♠ in hand
true
```
