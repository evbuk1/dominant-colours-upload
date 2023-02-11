class Image < ActiveRecord::Base
  include Filterable
  include Sortable
end