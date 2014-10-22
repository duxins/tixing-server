module Tixing
  module Entities
    class Pagination < Grape::Entity
      expose :next_page
      expose :prev_page
      expose :total_pages
    end
  end
end