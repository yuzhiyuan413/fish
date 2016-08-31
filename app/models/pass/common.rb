module Pass::Common

  def allow?(controller, operate)
    permissions.each do |permission|
      result = permission.pass controller, operate
      next if result == Pass::Permission::DO_NOT_KNOW
      return true if result == Pass::Permission::ALLOW
      return false if result == Pass::Permission::NOT_ALLOW
    end
    return false
  end

end
