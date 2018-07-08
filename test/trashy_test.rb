require "test_helper"

class Regular < ActiveRecord::Base
  connection.create_table :regulars, force: true do |t|
    t.datetime :deleted_at
  end

  include Trashy
end

class Boolean < ActiveRecord::Base
  connection.create_table :booleans, force: true do |t|
    t.boolean :deleted, default: false
  end

  include Trashy

  self.trashy_column = :deleted
  self.trashy_boolean = true
end

class TrashyTest < ActiveSupport::TestCase
  test "soft deletes by filtering and setting deleted_at by default" do
    3.times { Regular.create! }

    assert_changes 'Regular.count', from: 3, to: 0 do
      Regular.all.map(&:trash)
    end

    assert_equal 3, Regular.trashed.count
  end

  test "supports boolean fields as the deleted flag" do
    3.times { Boolean.create! }

    assert_changes 'Boolean.count', from: 3, to: 0 do
      Boolean.all.map(&:trash)
    end

    assert_equal 3, Boolean.trashed.count
  end
end
