require 'spec_helper'

describe Guardian do
  let(:abc_organization) { create(:organization) }
  let(:other_organization) { create(:organization) }
  let(:chris_as_employee) { create(:employee, organization: abc_organization) }
  let(:chris_as_user) { create(:user, employee: chris_as_employee) }
  let(:roger_as_employee) { create(:employee, organization: abc_organization) }
  let(:roger_as_user) { create(:user, employee: roger_as_employee) }
  let(:luis_as_employee) { create(:employee) }

  describe 'can_see?' do
    describe 'a Employee' do
      describe 'when user belongs to same organization' do
        it 'is true' do
          Guardian.new(roger_as_user).can_see?(chris_as_employee).should be_true
        end
      end
      describe 'when user DOES NOT belongs to same organization' do
        it 'is false' do
          Guardian.new(roger_as_user).can_see?(luis_as_employee).should be_false
        end
      end
    end
  end

  describe 'can_create?' do
    describe 'a Training on Organization' do
      describe 'when user belongs to the organization passed' do
        it 'is true' do
          Guardian.new(chris_as_user).can_create?(Training, abc_organization).should == true
        end
      end
      describe 'when user DOES NOT belong to the organization passed' do
        it 'is false' do
          Guardian.new(chris_as_user).can_create?(Training, other_organization).should == false
        end
      end
    end
  end

  describe 'EnsureMagic!' do
    it 'calls the correct method and not raises exception' do
      guardian = Guardian.new(chris_as_user)
      guardian.expects(:can_see?).returns(true)
      lambda { guardian.ensure_can_see!(roger_as_employee) }.should_not raise_error
    end
    it 'raise exception' do
      guardian = Guardian.new(chris_as_user)
      lambda { guardian.ensure_can_remove!(Employee) }.should raise_error
    end
  end
end