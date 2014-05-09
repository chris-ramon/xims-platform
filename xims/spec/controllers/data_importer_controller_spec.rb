require 'spec_helper'

describe DataImporterController do
  let(:chris_as_user) { create(:user) }
  let!(:user) { sign_in chris_as_user }
  let(:uploaded_file) { create(:upload, original_filename: 'a.xlsx',
                               url: "/samples/employees_to_import.xlsx") }
  describe 'show' do
    context 'when logged in' do
      it 'succeeds' do
        xhr :get, :show, upload_id: uploaded_file.id
        parsed = JSON(response.body)
        response.should be_success
        parsed['data'].length.should be > 0
      end
    end
  end

  describe 'create' do
    context 'when logged in' do
      it 'succeeds' do
        xhr :post, :create, upload_id: uploaded_file.id
        parsed = JSON(response.body)
        response.should be_success
        parsed['total'].should be > 0
      end
    end
  end
end