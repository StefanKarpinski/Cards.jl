using Cards
using Test

# write your own tests here
hand = Hand([2♣, 3♣, 6♣, 7♣, 8♣, 9♣, 2♢, 3♢, 4♢, 7♢, 10♢, J♢, A♢, 4♡, 5♡, 6♡, 7♡, Q♡, K♡, A♡, 4♠, 6♠, 9♠, K♠, A♠])

@testset "Card in Hand" begin
    @test 2♣ in hand
    @test !(4♣ in hand)
    @test !(A♣ in hand)
    @test A♠ in hand
end

@testset "Suit intersetion with Hand" begin
    @test ♡ ∩ hand == Hand([4♡, 5♡, 6♡, 7♡, Q♡, K♡, A♡])
    @test ♠ ∩ hand == Hand([4♠, 6♠, 9♠, K♠, A♠])
    @test length(♣ ∩ hand) == 6 
end
