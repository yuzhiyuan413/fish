# encoding: utf-8
class System::Permission < Pass::Permission
  include RedisCacheHelper
  self.table_name = "permissions"

  #操作code到name的映射
  OPERATE_MAP = { Pass::Permission::ADD_CODE => '添加',
    Pass::Permission::SHOW_CODE => '查看',
    Pass::Permission::DELETE_CODE => '删除' ,
    Pass::Permission::EDIT_CODE => '修改'}

  after_create :init_sort
  after_create :drop_dropdown_items_cache
  after_update :drop_dropdown_items_cache
  after_destroy :drop_dropdown_items_cache

  def include_operate? operate
    return true if id.nil?
    p = Pass::Permission.find id
    return p.include_operate? operate
  end

  def operates_name
    return "所有" if self.all_operate?
    msg = ""
    operates.each do |o|
      msg += "#{OPERATE_MAP[o]} "
    end
    return msg
  end

  def status_name
    return "允许" if status == Pass::Permission::STATUS_YES
    return "禁止" if status == Pass::Permission::STATUS_NO
  end

  def self.find_all_by_link_type_and_link_id link_type, link_id
    where({link_type: link_type, link_id: link_id}).order(:sort)
  end

  #因为sort不能重复， 所以要先赋值为nil再交换, 为了绕过权限检测，提高速度， 所以使用sql更新
  def self.update_sort m_id, n_id
    m = nil
    transaction do
      conn = ActiveRecord::Base.connection
      m = System::Permission.find m_id
      n = System::Permission.find n_id
      m_sort = m.sort
      n_sort = n.sort
      m.update_attribute :sort, nil
      n.update_attribute :sort, nil
      m.update_attribute :sort, n_sort
      n.update_attribute :sort, m_sort
      m.reload
    end
    return m
  end

  def link
    "System::#{self.link_type}".constantize.find(self.link_id)
  end

  private

  def init_sort
    self.sort = self.id
    self.save!
  end
end
