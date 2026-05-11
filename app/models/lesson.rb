class Lesson < ApplicationRecord
  belongs_to :subject
  has_many :phases, -> { order(:position)}, dependent: :destroy

  def materials_summary
    phases.flat_map(&:materials_list).uniq.sort_by(&:downcase)
  end
end
