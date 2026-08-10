class Physical::LinkType <  ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
end