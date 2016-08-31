# encoding: utf-8
class System::Role < ActiveRecord::Base
  include RedisCacheHelper
  self.table_name = :roles
  #表关系
  has_and_belongs_to_many :accounts
  has_many :permissions, -> {order "sort", as: :link, dependent: :destroy }

  # attr_accessible :name, :description
  validates_presence_of   :name, :message => "角色名不能为空"
  validates_length_of     :name, :within => 2..40, :message => "角色名的长度必须在2至40之间"
  validates_uniqueness_of :name, :message => "角色名已经存在"

  after_create :drop_dropdown_items_cache
  after_update :drop_dropdown_items_cache
  after_destroy :drop_dropdown_items_cache

end
