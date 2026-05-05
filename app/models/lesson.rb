class Lesson < ApplicationRecord
  has_many :phases, -> { order(:position)}, dependent: :destroy
end
