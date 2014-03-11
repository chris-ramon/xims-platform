require 'spec_helper'

describe Guardian do
  describe 'can_see?' do
    describe 'a Employee' do
      before do
        abc_organization = create(:organization)
        @chris_as_employee = create(:employee, organization: abc_organization)
        @chris_as_user = create(:user, employee: @chris_as_employee)

        @roger_as_employee = create(:employee, organization: abc_organization)
        @roger_as_user = create(:user, employee: @roger_as_employee)
      end
      describe 'when user belongs to same organization' do
        it 'is true' do
          Guardian.new(@roger_as_user).can_see?(@chris_as_employee).should == true
        end
      end
      describe 'when user DOES NOT belongs to same organization' do
        it 'is false' do
          @chris_as_employee.organization = create(:organization)
          @chris_as_employee.save
          Guardian.new(@roger_as_user).can_see?(@chris_as_employee).should == false
        end
      end
    end
  end

  describe 'can_create?' do
    describe 'a Training on Organization' do
      describe 'when user belongs to the organization passed' do
        it 'is true' do
          abc_organization = create(:organization)
          chris_as_employee = create(:employee, organization: abc_organization)
          chris_as_user = create(:user, employee: chris_as_employee)
          Guardian.new(chris_as_user).can_create?(Training, abc_organization).should == true
        end
      end
      describe 'when user DOES NOT belong to the organization passed' do
        it 'is false' do
          abc_organization = create(:organization)
          chris_as_user = create(:user_with_employee)
          Guardian.new(chris_as_user).can_create?(Training, abc_organization).should == false
        end
      end
    end
  end

  describe 'EnsureMagic!' do
    it 'calls the correct method and not raises exception' do
      user = create(:user)
      employee = create(:employee)
      guardian = Guardian.new(user)
      guardian.expects(:can_see?).returns(true)
      lambda { guardian.ensure_can_see!(employee) }.should_not raise_error
    end
    it 'raise exception' do
      user = create(:user)
      guardian = Guardian.new(user)
      lambda { guardian.ensure_can_remove!(Employee) }.should raise_error
    end
  end
end