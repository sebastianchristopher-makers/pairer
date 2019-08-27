class Pairer

  def initialize
    @db = PairDB.new('pairer')
    @names = @db.names('Captain Crunch')
    @last_pairs = @db.last_pairs
    @pairs = []
  end

  def pair
    new_pairs
    @db.con.exec 'DELETE FROM last_pairs;'
    @pairs.each { |pair| @db.con.exec "INSERT INTO last_pairs(pair_one, pair_two) VALUES('#{pair.p1}', '#{pair.p2}');" }
    print_pairs
    exit
  end

  private

  def new_pairs
    while true
      @pairs = []
      pairs = @names.shuffle.each_slice(2).to_a
      pairs.each { |a,b| @pairs << Pair.new(a,b) }
      break if no_matches?
    end
  end

  def print_pairs
    puts "Last pairs:"
    @last_pairs.each { |pair| p pair.pair }
    puts "New pairs:"
    @pairs.each { |pair| p pair.pair }
  end

  def no_matches?
    last_pairs = @last_pairs.map { |pair| pair.pair }
    @pairs.each { |pair|
      return false if last_pairs.include?(pair.pair) || last_pairs.include?(pair.pair.reverse)
    }
  end

  def exit
    @db.con.close if @db.con
  end
end
