class Pass::Role < Pass::Base

  LINK_TYPE = "Role"

  self.table_name =  "roles"

  include Pass::Common

  def permissions
    return Pass::Permission.find_all_by_link_type_and_link_id Pass::Role::LINK_TYPE, self.id
  end

end
