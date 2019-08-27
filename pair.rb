class Pair
  attr_reader :p1, :p2

  def initialize(pair_one, pair_two)
    @p1 = pair_one
    @p2 = pair_two
  end

  def pair
    [@p1, @p2]
  end
end
