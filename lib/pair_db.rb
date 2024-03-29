class PairDB
  attr_reader :con

  def initialize(db_name)
    @con = PG.connect :dbname => db_name
  end

  def names(*default)
    rs = @con.exec 'SELECT name FROM cohort;'
    rs.each_with_object(Array.new(default)) { |row, names| names << row['name'] }
  end

  def last_pairs
    rs = @con.exec 'SELECT * FROM last_pairs;'
    rs.each_with_object(Array.new) { |row, last_pairs| last_pairs << Pair.new(row['pair_one'], row['pair_two']) }
  end

  def add_pair(pair)
    @con.exec "INSERT INTO last_pairs(pair_one, pair_two) VALUES('#{pair.p1}', '#{pair.p2}');"
  end

  def delete_pairs
    @con.exec 'TRUNCATE last_pairs;'
  end

  def close_con
    @con.close if @con
  end
end
