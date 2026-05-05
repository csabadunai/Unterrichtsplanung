class Phase < ApplicationRecord
  belongs_to :lesson
  acts_as_list scope: :lesson
  default_scope { order(position: :asc) }
end
