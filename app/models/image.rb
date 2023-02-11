# frozen_string_literal: true

class Image < ActiveRecord::Base
  include Filterable
  include Sortable

  has_one_attached :image_file
end