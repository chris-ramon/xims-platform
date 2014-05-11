require 'roo'

class EmployeeExcelImporter
  attr_reader :employees

  def initialize(user, file_path, current_page=1, default_per_page=nil)
    @user = user
    @start_row = 2
    @file_path = file_path
    @default_per_page = default_per_page || Kaminari.config.default_per_page
    if current_page.present?
      @current_page = current_page.to_i
    else
      @current_page = 1
    end
    @employees = []
    @total_items = nil
  end

  def import_data
    s = Roo::Excelx.new(@file_path)
    (@start_row..s.last_row).each do |line|
      id_number = s.cell(line, 'A')
      names = s.cell(line, 'B')
      last_names = s.cell(line, 'C')
      age = s.cell(line, 'D')
      workspace_name = s.cell(line, 'E')
      occupation_name = s.cell(line, 'F')
      company_years_of_experience = s.cell(line, 'G')
      gender = s.cell(line, 'H')
      occupation_turn = s.cell(line, 'I')
      type_of_contract = s.cell(line, 'J')
      occupation_years_of_experience = s.cell(line, 'K')
      company_name = s.cell(line, 'L')


      names = names.split(' ')
      if names.length > 1
        first_name = names[0]
        middle_name = names[1]
      else
        first_name = names[0]
        middle_name = nil
      end

      last_names = last_names.split(' ')
      if last_names.length > 1
        last_name = last_names[0]
        second_last_name = last_names[1]
      else
        last_name = last_names[0]
        second_last_name = nil
      end

      individual = Individual.create(id_number: id_number, first_name: first_name,
                                      middle_name: middle_name,  last_name: last_name,
                                      second_last_name: second_last_name, age: age)

      if "#{company_name}".similar("#{@user.employee.organization.name}") > 75 #TODO: this number should come from app settings
        organization = @user.employee.organization
      else
        organization = Organization.where("lower(name) = ?", "#{company_name}".downcase).first
      end

      workspace = Workspace.where("lower(name) = ?", "#{workspace_name}".downcase).first
      occupation = Workspace.where("lower(name) = ?", "#{occupation_name}".downcase).first

      unless organization.present?
        organization = Organization.create(name: company_name)
      end

      unless workspace.present?
        workspace = Workspace.create(name: workspace_name)
      end

      unless occupation.present?
        occupation = Occupation.create(name: occupation_name)
      end

      Employee.create(organization: organization, individual: individual,
                      workspace: workspace, occupation: occupation)

      unless @user.employee.organization.id == organization.id
        Outsourcing.where(outsourcer_id: @user.employee.organization.id,
                          provider_id: organization.id).first_or_create
      end

      @employees << individual
    end
    @employees
  end
  def json_data
    data = []
    s = Roo::Excelx.new(@file_path)
    @last_row = (s.last_row - @start_row) + 1
    @total_items = s.last_row - 1

    #pagination
    start_row = (@default_per_page * (@current_page - 1)) + 2
    remainder_rows = @last_row % @default_per_page
    is_last_page = ((@last_row.to_f / @default_per_page).ceil == @current_page)
    if remainder_rows > 0 && is_last_page
      end_row = (start_row + remainder_rows) - 1
    else
      end_row = (@default_per_page * @current_page) + 1
    end

    (start_row..end_row).each do |line|
      id_number = s.cell(line, 'A')
      names = s.cell(line, 'B')
      last_names = s.cell(line, 'C')
      age = s.cell(line, 'D')
      workspace = s.cell(line, 'E')
      occupation = s.cell(line, 'F')
      company_years_of_experience = s.cell(line, 'G')
      gender = s.cell(line, 'H')
      occupation_turn = s.cell(line, 'I')
      type_of_contract = s.cell(line, 'J')
      occupation_years_of_experience = s.cell(line, 'K')
      company_name = s.cell(line, 'L')

      data << {id_number: id_number, names: names,
               last_names: last_names, age: age,
               workspace: workspace, occupation: occupation,
               company_years_of_experience: company_years_of_experience,
               gender: gender, occupation_turn: occupation_turn, type_of_contract: type_of_contract,
               occupation_years_of_experience: occupation_years_of_experience, company_name: company_name}
    end
    {data: data, current_page: @current_page, total_items: @total_items}
  end
end