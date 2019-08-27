require 'pg'
require_relative './lib/pairer'
require_relative './lib/pair'
require_relative './lib/pair_db'

p = Pairer.new
p.run
