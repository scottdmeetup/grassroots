require 'spec_helper'

describe Contract do
  it {should belong_to(:volunteer)}
  it {should belong_to(:contractor)}
  it {should belong_to(:project)}

=begin
      huggey_bear = Fabricate(:organization)
      amnesty = Fabricate(:organization)

      alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
      cat = Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")
      bob = Fabricate(:user, first_name: "Bob", user_group: "volunteer")

      huggey_bear.update_columns(user_id: alice.id)      
      amnesty.update_columns(user_id: cat.id)

      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) 
      logo = Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: true)
      contract2 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: false, project_id: logo.id, work_submitted: false, complete: true)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id)
      contract3.contract_dropped
=end
end