# frozen_string_literal: true

class Foo < ApplicationRecord
  belongs_to :assoc

  scope :datetime_between, (lambda do |(start, finish)|
    where(Arel::Table.new(table_name)[:datetime].between(start..finish))
  end)

  def self.string_ends_with(substr)
    where(Arel::Table.new(table_name)[:string].matches("%#{substr}"))
  end

  # computed associations

  def computed_assoc
    assoc
  end
end
