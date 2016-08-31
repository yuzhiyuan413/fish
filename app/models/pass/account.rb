class Pass::Account < Pass::Base

  include Pass::Common

  LINK_TYPE = "Account"

  self.table_name = "accounts"

  has_and_belongs_to_many :roles, :class_name => "Pass::Role"

  def permissions
    return Pass::Permission.find_all_by_link_type_and_link_id Pass::Account::LINK_TYPE, self.id
  end

end
