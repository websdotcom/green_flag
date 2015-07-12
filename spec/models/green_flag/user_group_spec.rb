require 'spec_helper'

describe GreenFlag::UserGroup do

  let(:visitor) { double(user: nil) }

  # includes noone
  let(:exclusive_user_group) { GreenFlag::UserGroup.new('Foo') { false } }

  # includes everyone
  let(:inclusive_user_group) { GreenFlag::UserGroup.new('Foo') { true } }

  describe '#includes_visitor?' do
    subject { inclusive_user_group.includes_visitor?(visitor) }
    context 'when the visitor has no user' do
      it { should be_false }
    end
    context 'when the visitor has a user' do
      let(:visitor) { double(user: double) }
      it { should be_true }
    end
  end

end