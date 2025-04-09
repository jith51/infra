class Dna::EolBulletin <  ActiveRecord::Base
	validates :eol_type, presence: true
	validates :number, presence: true, uniqueness: { scope: :eol_type }
end