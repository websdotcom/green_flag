require 'spec_helper'

describe GreenFlag::VisitorGroup do
  before(:each) do 
    GreenFlag::VisitorGroup.clear!
  end

  describe '#define' do
    it 'does not fail' do
      GreenFlag::VisitorGroup.define {}
    end
  end

  describe '#group' do
    subject do 
      GreenFlag::VisitorGroup.group(:foo, 'desc') {}
    end

    it 'creates a VisitorGroup with the given attributes' do
      expect(subject.key).to eq('foo')
      expect(subject.description).to eq('desc')
    end

    it 'raises an error if there is already a group with that key' do
      GreenFlag::VisitorGroup.group(:foo, 'desc') {} 
      expect { subject }.to raise_error GreenFlag::VisitorGroup::MultipleGroupsError
    end
  end

  describe '#user_group' do
    subject do 
      GreenFlag::VisitorGroup.user_group(:foo, 'desc') {}
    end
    it 'creates a UserGroup with the given attributes' do
      expect(subject.key).to eq('foo')
      expect(subject.description).to eq('desc')
      expect(subject).to be_a(GreenFlag::UserGroup)
    end
  end

  describe '#all' do
    subject { GreenFlag::VisitorGroup.all }

    it 'is empty by default' do
      expect(subject).to be_empty
    end
    it 'includes groups defined in .group' do
      g1 = GreenFlag::VisitorGroup.group(:foo)
      g2 = GreenFlag::VisitorGroup.group(:bar)
      expect(subject).to eq([g1, g2])
    end
  end

  describe '#for_key' do
    it 'gets a group by key' do
      g = GreenFlag::VisitorGroup.group(:foo)
      expect(GreenFlag::VisitorGroup.for_key(:foo)).to eq(g)
    end
    it 'gets a group by key string' do
      g = GreenFlag::VisitorGroup.group(:foo)
      expect(GreenFlag::VisitorGroup.for_key('foo')).to eq(g)
    end    
  end

  describe '.includes_visitor?' do
    let(:visitor) { double(:is_visitor? => true) } 
    let(:yes_group) { GreenFlag::VisitorGroup.group(:yes) { |v| v.is_visitor? }  }
    let(:no_group) { GreenFlag::VisitorGroup.group(:no) { |v| !v.is_visitor? }  }

    it 'is true when the block passes' do
      result = yes_group.includes_visitor?(visitor)
      expect(result).to be_true
    end

    it 'is false when the block fails' do
      result = no_group.includes_visitor?(visitor)
      expect(result).to be_false
    end
  end

end