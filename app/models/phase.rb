class Phase < ApplicationRecord
  belongs_to :lesson
  acts_as_list scope: :lesson
  default_scope { order(position: :asc) }

  def materials_list
    materials.to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
  end
end
