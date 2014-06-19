def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(organization_administrator=nil)
  session[:user_id] = (organization_administrator || Fabricate(:organization_administrator)).id
end

def user_signs_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email", with: "#{user.email}"
  fill_in "Password", with: "#{user.password}"
  click_on('Sign in')
end

def sign_out
  visit log_out_path
end

