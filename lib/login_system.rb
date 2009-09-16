module LoginSystem
	protected
	
	def is_logged_in?
		@logged_in_user = User.find(session[:user]) if session[:user]
	end
	
	def logged_in_user
		return @logged_in_user if is_logged_in?
	end
	
	def logged_in_user=(user)
		if !user.nil?
			session[:user] = user.id
			@logged_in_user = user
		end
	end
	
	def self.included(base)
		base.send :helper_method, :is_logged_in?, :logged_in_user
	end
	
	def check_role(role)
		unless is_logged_in? && @logged_in_user.has_role?(role)
			flash[:error] = "You do not have the permission to do that."
			redirect_to :controller => 'account', :action => 'login'
		end
	end
	
	def check_administarator_role
		check_role('Administrator')
	end
	
	def login_required
		unless is_logged_in?
			flash[:error] = "You must be logged in to do that."
			redirect_to :controller => 'account', :action => 'login'
		end
	end
	
	def check_editor_role
		check_role('Editor')
	end
	
	#----------为API添加HTTP验证－－－－－－－－＃
	
	private
	def get_http_auth_data
		username, password = nil, nil
		auth_headers = [ 'X-HTTP_AUTHORIZATION','Authorization', 'HTTP_AUTHORIZATION',
						'REDIRECT_REDIRECT_X_http_AUTHORIZATION']
		auth_header = auth_header.detect { |key| request.env[key] }
		auth_data = request.env[auth_header].to_s.split
		
		if auth_data && auth_data[0] = 'Basic'
			username, password = Base64.decode64(auth_data[1]).split(':')[0..1]
		end
		return [username, password]
	end
	
end
