class Collaboration < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :role, inclusion: { in: %w[viewer editor] }
end
