class Pass::ActionInfo

  attr_accessor :controller, :action, :account_id, :remote_ip, :params, :headers

  def initialize request, params, account_id, secure
    @params = params
    @controller = params[:controller]
    @action = params[:action]
    @account_id = account_id
    if request
      @remote_ip = request.remote_ip
      @headers = request.headers
    end
    @secure = secure
    Thread.current[:action_info] = self
  end

  def account
    return Pass::Account.find(account_id)
  end

  def secure?
    @secure
  end

  #销毁当前的请求信息
  def self.destroy
    Thread.current[:action_info] = nil
  end

  #返回当前的action_info
  def self.current
    return Thread.current[:action_info]
  end

end
