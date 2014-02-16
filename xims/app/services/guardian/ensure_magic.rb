# Support for ensure_{blah}! methods.
module EnsureMagic
  def method_missing(method, *args, &block)
    if method.to_s =~ /^ensure_(.*)\!$/
      can_method = :"#{Regexp.last_match[1]}?"

      if respond_to?(can_method)
        raise Xims::InvalidAccess.new("#{can_method} failed") unless send(can_method, *args, &block)
        return
      end
    end

    super.method_missing(method, *args, &block)
  end
end