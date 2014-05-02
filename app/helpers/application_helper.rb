module ApplicationHelper

  def skill_set
    ["Grant Writing", "Web Development", "Graphic Design", "Business Planning", "Accounting"]
  end

  def fix_date_time(dt)
    if logged_in? && !current_user.time_zone.blank?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime("%m/%d/%Y")
  end
end
