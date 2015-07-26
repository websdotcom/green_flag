feature 'Editing a feature in the admin system' do

  let(:feature) { FactoryGirl.create(:green_flag_feature) }

  scenario 'view edit page' do
    code = feature.code

    visit '/green_flag/admin/features'
    expect(page).to have_text(code)
    click_link code
    expect(page).to have_text(code)    
  end  

end