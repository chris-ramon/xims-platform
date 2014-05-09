require 'spec_helper'
require 'fileutils'


describe UploadsController do
  let(:abc_organization) { create(:organization) }
  let(:chris_as_employee) { create(:employee,
                                   organization: abc_organization) }
  let(:chris_as_user) { create(:user, employee: chris_as_employee) }
  let!(:user) { sign_in chris_as_user }
  let(:uploads_dir) { "#{Rails.root}/public/uploads" }
  let(:xlsx_file) do
    ActionDispatch::Http::UploadedFile.new(
        {filename: 'employees_to_import.xlsx',
         tempfile: File.new("#{Rails.root}/spec/fixtures/employees_to_import.xlsx")})
  end
  let(:uploaded_file) { create(:upload, original_filename: 'a.xlsx',
                               url: "/samples/employees_to_import.xlsx") }

  describe 'index' do
    context 'when logged in and allowed' do
      it 'succeeds' do
        uploaded_file
        xhr :get, :index
        parsed = JSON(response.body)
        response.should be_success
      parsed['files'].length.should == 1
      end
    end
  end

  describe 'create' do
    after do
      # deleting the files uploaded
      Upload.all.each {|upload| FileUtils.rm_rf("#{uploads_dir}/#{upload.id}")}
    end

    context 'when logged in and allowed' do
      it 'succeeds' do
        xhr :post, :create, file: xlsx_file
        response.should be_success
      end
    end
  end

  describe 'show' do
    context 'when logged in' do
      it 'succeeds' do
        xhr :get, :show, upload_id: uploaded_file.id
        response.should be_success
      end
    end
  end
end