# encoding: utf-8
require 'digest/sha1'
class System::Account < ActiveRecord::Base
  include RedisCacheHelper
  attr_reader :current_password
  self.table_name = "accounts"
  # attr_accessible :name, :password_confirmation, :password, :role_ids

  PARTNER = 1
  SALE_MANAGER = 2
  ADMIN = 3

  validates_presence_of   :name, :message => "用户名不能为空"
  validates_length_of     :name, :within => 2..40, :message => "用户名的长度必须在2至40之间"
  validates_uniqueness_of :name, :message => "用户名已经存在"
  #validates_format_of :name, :with => /\A\w+\z/, :message => "用户名称包含非法字符", :unless => "name.blank?"
  validates_presence_of :password, :message => "密码不能为空", :on => :save
  validates_confirmation_of :password, :message => "密码不一致"

  #表关系
  has_and_belongs_to_many :roles
  has_many :permissions,  -> { order "sort", as: :link, dependent: :destroy }

  after_create :drop_dropdown_items_cache
  after_update :drop_dropdown_items_cache
  after_destroy :drop_dropdown_items_cache

  #验证账户信息
  def self.check_account username, password
    result = System::Account.find_by_name(username)
    if result
      expected_password = encrypted_password(password)
      if result.password != expected_password
        '密码填写错误!'
      elsif result.status != 1
        '用户状态为不可用，请联系系统管理员!'
      else
        result
      end
    else
      '用户名不存在!'
    end
  end

  def update_attributes attr
    System::Account.transaction do
      attr[:role_ids] = []    if attr[:role_ids].nil?
      #attr[:partner_ids] = [] if attr[:partner_ids].nil?
      if attr[:password].blank? #如果密码不填则不修改密码
        attr.delete(:password)
        attr.delete(:password_confirmation)
      end
      super attr
    end
  end

  def available_functions
    Pass::System.functions.collect{|func| func if func.allow?(self.try(:id)) }.compact
  end

  def password= pwd
    @pwd = pwd
    write_attribute("password", System::Account.encrypted_password(pwd))
  end

  def password_confirmation= pwd
    @password_confirmation =  System::Account.encrypted_password(pwd)
  end

  def current_password= pwd
    @current_password = System::Account.encrypted_password(pwd)
  end

  def update_password params
    pwd = self.password
    self.current_password = params[:current_password]
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    errors.add(:current_password, "当前密码不正确") if pwd != self.current_password
    result = errors.count == 0
    result = self.save if result
    return result
  end

  def self.encrypted_password(password)
    Digest::SHA1.hexdigest("---tiger--#{password}--")
  end

  def test_password
    result = 0
    result += 1 if /[A-Z]+/.match @pwd
    result += 1 if /[a-z]+/.match @pwd
    result += 1 if /[0-9]+/.match @pwd
    result += 1 if /^[0-9A-Za-z]+/.match @pwd
    return result
  end

  private

  def valid_password_length
    errors.add(:password, "密码的长度必须在8至20之间") if @pwd and (@pwd.length > 20 or @pwd.length < 8)
  end

  def valid_password_content
    errors.add(:password, "密码必须包含大写字母小写字母和数字") if @pwd and test_password < 3
  end

  def valid_roles
    errors.add(:role_ids, "必须选一个角色") if roles.length == 0
  end

end
