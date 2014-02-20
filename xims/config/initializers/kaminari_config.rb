Kaminari.configure do |config|
  if Rails.env.test?
    config.default_per_page = 1
  else
    config.default_per_page = 10
  end
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end
