require 'spec_helper'

describe EmployeeExcelImporter do
  let(:excel_file) { "#{Rails.root}/spec/fixtures/employees_to_import.xlsx" }
  let(:organization) { create(:organization) }
  describe 'get_data' do
    it 'should set attributes correctly' do
      employee_excel_importer = EmployeeExcelImporter.new(organization, excel_file)
      employee_excel_importer.import_data
      employee_excel_importer.employees.length.should == 10
    end

    it 'should create employee related entities' do
      employee_excel_importer = EmployeeExcelImporter.new(organization, excel_file)
      employee_excel_importer.import_data
      Employee.count.should == Individual.count
    end
  end
  describe 'to_json' do
    it 'succeeds' do
      employee_excel_importer = EmployeeExcelImporter.new(organization, excel_file)
      result = employee_excel_importer.json_data
      result[:data].length.should == 1
    end

    context 'pagination' do
      it 'succeeds' do
        employee_excel_importer = EmployeeExcelImporter.new(organization, excel_file,
                                                            current_page=2,
                                                            default_per_page=5)
        result = employee_excel_importer.json_data
        result[:data].length.should == 5

        employee_excel_importer = EmployeeExcelImporter.new(organization, excel_file,
                                                            current_page=2,
                                                            default_per_page=7)
        result = employee_excel_importer.json_data
        result[:data].length.should == 3

        employee_excel_importer = EmployeeExcelImporter.new(organization, excel_file,
                                                            current_page=2,
                                                            default_per_page=9)
        result = employee_excel_importer.json_data
        result[:data].length.should == 1
      end
    end
  end
end