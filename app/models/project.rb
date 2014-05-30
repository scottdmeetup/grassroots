class Project < ActiveRecord::Base
  belongs_to :organization
  #why do I need: 
  #has_many :volunteer_applications
  #has_many :users, through: :volunteer_applications
  #to make my tests to pass for:
  #it { should have_many(:applicants)}
  #it { should have_many(:applicants).through(:volunteer_applications)}

  has_many :volunteer_applications
  has_many :users, through: :volunteer_applications
  has_many :applicants, class_name: 'VolunteerApplication', foreign_key: 'applicant_id'
  has_many :applicants, through: :volunteer_applications
  belongs_to :administrator, class_name: 'Organization', foreign_key: 'user_id'

  def project_admin
    organization.organization_administrator
    User.find(organization.organization_administrator.id)
  end

  def open
    self.state == "open"
  end

  def self.search_by_title_or_description(search_term)
    return [] if search_term.blank?
    if where("title or description LIKE ?", "%#{search_term}%") != []
      where("title or description LIKE ?", "%#{search_term}%")
    elsif where("title LIKE ?", "%#{search_term}%") != []
      where("title LIKE ?", "%#{search_term}%")
    elsif where("description LIKE ?", "%#{search_term}%") != []
      where("description LIKE ?", "%#{search_term}%")
    else
      []
    end
  end
end