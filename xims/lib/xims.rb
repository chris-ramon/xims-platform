module Xims
  # When they don't have permission to do something
  class InvalidAccess < Exception; end

  # When something they want is not found
  class NotFound < Exception; end
end