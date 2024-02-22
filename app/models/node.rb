class Node < ApplicationRecord
  has_many :birds
  has_many :children, :class_name => "Node", foreign_key: 'parent_id'
  belongs_to :parent, :class_name => "Node", foreign_key: 'parent_id', :optional => true

end
