# frozen_string_literal: true

# Classe de base des powertypes
class Powertype < ActiveRecord::Base
  acts_as_tree
end
