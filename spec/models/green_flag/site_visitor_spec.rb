require 'spec_helper'

describe GreenFlag::SiteVisitor do

  class User < OpenStruct
    def self.primary_key
      'id'
    end
  end

  let(:site_visitor) { GreenFlag::SiteVisitor.create(visitor_code: 'asdf') }
  let(:older_user) { User.new(created_at: (site_visitor.created_at-1)) }  
  let(:newer_user) { User.new(created_at: (site_visitor.created_at+1)) }  

  describe '#first_visited_at' do
    subject { site_visitor.first_visited_at }

    context 'when the site visitor has no user' do
      it { should eq(site_visitor.created_at) }
    end

    context 'when the site visitor has a newer user' do
      before(:each) do
        site_visitor.user = newer_user
      end
      it { should eq(site_visitor.created_at) }      
    end

    context 'when the site visitor has an older user' do
      before(:each) do
        site_visitor.user = older_user
      end
      it { should eq(older_user.created_at) }      
    end
  end

  describe '.for_user!' do
    let(:user) { double(id: 1) }
    subject { GreenFlag::SiteVisitor.for_user!(user, visitor_to_check) }
    
    context 'when there is no existing SiteVisitor for the user' do
      context 'when the vistor_to_check is nil' do
        let(:visitor_to_check) { nil }

        it 'creates a new SiteVisitor' do
          expect { subject }.to change { GreenFlag::SiteVisitor.count }.by(1)
        end
        it 'assigns the new SiteVisitor to the user' do
          expect(subject.user_id).to eq(user.id)
        end
      end
      context 'when the vistor_to_check is a visitor with no user' do
        let!(:visitor_to_check) { site_visitor }

        it 'does not create a new SiteVisitor' do
          expect { subject }.to_not change { GreenFlag::SiteVisitor.count }
        end
        it 'assigns the new SiteVisitor to the user' do
          expect(subject.user_id).to eq(user.id)
        end
      end
      context 'when the vistor_to_check is a visitor with a different user' do
        let!(:visitor_to_check) { GreenFlag::SiteVisitor.create(visitor_code: 'asdf', user_id: (user.id+1)) }

        it 'creates a new SiteVisitor' do
          expect { subject }.to change { GreenFlag::SiteVisitor.count }.by(1)
        end
        it 'does not change the visitor_to_check' do
          expect(visitor_to_check.user_id).to_not eq(user.id)
        end
      end
    end
    context 'when a SiteVisitor exists for the user' do
      let!(:user_site_visitor) { GreenFlag::SiteVisitor.create(visitor_code: 'asdf2', user_id: user.id) }

      context 'when the vistor_to_check is nil' do
        let(:visitor_to_check) { nil }
        it 'does not create a new SiteVisitor' do
          expect { subject }.to_not change { GreenFlag::SiteVisitor.count }
        end
        it "returns the user's site visitor" do
          expect(subject).to eq(user_site_visitor)
        end
      end
      context 'when the vistor_to_check is a visitor with no user' do
        let!(:visitor_to_check) { site_visitor }
        it "returns the user's site visitor" do
          expect(subject).to eq(user_site_visitor)
        end
      end
      context 'when the vistor_to_check is a visitor with a different user' do
        let!(:visitor_to_check) { GreenFlag::SiteVisitor.create(visitor_code: 'asdf', user_id: (user.id+1)) }

        it 'does not change the visitor_to_check' do
          expect(visitor_to_check.user_id).to_not eq(user.id)
        end
      end
    end
  end

end
