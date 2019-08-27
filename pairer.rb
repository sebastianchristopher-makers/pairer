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
    rs = @con.exec 'SELECT pair FROM last_pairs;'
    rs.each { |row| @last_pairs << row['pair'] }
    @pairs = []
  end

  def pair
    new_pairs
    @con.exec 'CREATE TEMPORARY TABLE tmp_pairs() INHERITS(last_pairs);'
    @pairs.each { |pair| @con.exec "INSERT INTO tmp_pairs(pair) VALUES('#{pair}')"}
    @con.exec 'DELETE FROM last_pairs;'
    @pairs.each { |pair| @con.exec "INSERT INTO last_pairs(pair) VALUES('#{pair}')"}

    puts "Last pairs:"
    @last_pairs.each { |pair| puts pair }
    puts "New pairs:"
    @pairs.each { |pair| puts pair }
  end

  def no_matches?
    @pairs.each { |pair| return false if @last_pairs.include?(pair) }
  end

  def new_pairs
    while true
      @pairs = []
      pairs = @names.shuffle.each_slice(2).to_a
      pairs.each { |a,b| @pairs << "#{a}, #{b}" }
      break if no_matches?
    end
  end

  def exit
    con.close if con
  end
end
