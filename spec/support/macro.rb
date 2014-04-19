def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(organization_administrator=nil)
  session[:user_id] = (organization_administrator || Fabricate(:organization_administrator)).id
end