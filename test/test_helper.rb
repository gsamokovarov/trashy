$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "trashy"

require "byebug"
require "active_record"

ActiveRecord::Base.establish_connection \
  adapter: "sqlite3",
  database: ":memory:"

require "minitest/autorun"
