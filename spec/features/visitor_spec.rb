require "spec_helper"

feature 'Visiting a page that checks for a feature' do

  let(:feature) { FactoryGirl.create(:green_flag_feature, code: 'test_feature') }

  scenario 'when the feature does not exist' do
    visit '/feature_checks'
    expect(page).to have_text("NOT ENABLED")
  end

  scenario 'when the feature exists, and is closed' do
    feature
    visit '/feature_checks'
    expect(page).to have_text("NOT ENABLED")
  end

  scenario 'when the feature exists, and is closed, but the user is whitelisted' do
    visit '/feature_checks'
    expect(page).to have_text("NOT ENABLED")

    # manually enable the feature for the visitor
    fd = GreenFlag::FeatureDecision.order(:created_at).last
    fd.enabled = true
    fd.save!

    visit '/feature_checks'
    expect(page).to have_text("IS ENABLED")
  end

  scenario 'when the feature exists, and is open' do
    pending "Set up a rule with everyone 100% open"
  end


end