class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :service
  default_scope {order('id DESC')}


  rails_admin do
    list do
      field :id do
        column_width 50
      end
      field :created_at do
        date_format :short
        column_width 120
      end

      field :title do
        column_width 180
        formatted_value do
          bindings[:view].tag(:img , src: bindings[:object].thumb, width: 20) << " #{value}"
        end
      end
      field :service do
        column_width 100
      end

      field :user do
        column_width 100
      end

      field :message do
        column_width 650
      end

      field :url
      field :web_url
      field :ipad_url
      field :sound
    end
  end

end
