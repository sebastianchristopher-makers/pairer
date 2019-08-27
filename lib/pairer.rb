require 'pg'
require_relative './pair'

class Pairer
  attr_reader :pairs

  def initialize
    @con = PG.connect :dbname => 'student'
    @names = ['Captain Crunch']
    rs = @con.exec 'SELECT name FROM t;'
    rs.each { |row| @names << row['name'] }
    @last_pairs = []
    rs = @con.exec 'SELECT * FROM last_pairs;'
    rs.each { |row| @last_pairs << Pair.new(row['pair_one'], row['pair_two']) }
    @pairs = []
  end

  def pair
    new_pairs
    @con.exec 'CREATE TEMPORARY TABLE tmp_pairs() INHERITS(last_pairs);'
    @pairs.each { |pair| @con.exec "INSERT INTO tmp_pairs(pair_one, pair_two) VALUES('#{pair.p1}', '#{pair.p2}');" }
    @con.exec 'DELETE FROM last_pairs;'
    @pairs.each { |pair| @con.exec "INSERT INTO last_pairs(pair_one, pair_two) VALUES('#{pair.p1}', '#{pair.p2}');" }

    puts "Last pairs:"
    @last_pairs.each { |pair| p pair.pair }
    puts "New pairs:"
    @pairs.each { |pair| p pair.pair }
  end

  def no_matches?
    last_pairs = @last_pairs.map { |pair| pair.pair }
    @pairs.each { |pair| return false if last_pairs.include?(pair.pair) || last_pairs.include?(pair.pair.reverse) }
  end

  def new_pairs
    while true
      @pairs = []
      pairs = @names.shuffle.each_slice(2).to_a
      pairs.each { |a,b| @pairs << Pair.new(a,b) }
      break if no_matches?
    end
  end

  def exit
    @con.close if @con
  end
end

p = Pairer.new
p.pair
p.exit
