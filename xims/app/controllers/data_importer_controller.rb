class DataImporterController < ApplicationController
  before_filter :authenticate_user!

  def show
    upload = Upload.where(id: params[:upload_id]).first
    if is_excel_file(upload.original_filename)
      employee_excel_importer = EmployeeExcelImporter.new(user_organization,
          "#{Rails.root}/public#{upload.url}", current_page=params[:page])
      result = employee_excel_importer.json_data
      render json: result
    else
      render json: error_json, status: :unprocessable_entity
    end
  end

  def create
    upload = Upload.where(id: params[:upload_id]).first
    if is_excel_file(upload.original_filename)
      employee_excel_importer = EmployeeExcelImporter.new(user_organization,
          "#{Rails.root}/public#{upload.url}", current_page=params[:page])
      employees = employee_excel_importer.import_data
      render json: {total: employees.length}
    else
      render json: error_json, status: :unprocessable_entity
    end
  end

  private
    def is_excel_file(file_name)
      file_name =~ /\.(xls||xlsx)$/
    end

    def user_organization
      current_user.employee.organization
    end
end