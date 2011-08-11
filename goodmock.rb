class GoodMock
  def initialize(clazz)
    @clazz = clazz
    @mocked_methods = {}
  end

  def mock(meth, &block)
    can_call?(meth)
    @mocked_methods[meth.to_sym] = block
  end

  def strict_mock(meth, args = [], &block)
    can_call?(meth)
    same_response?(meth, args, &block)
    @mocked_methods[meth.to_sym] = block
  end
  
  def method_missing(id, *args)
    method = @mocked_methods[id]
    raise BadMockError.new("That method is not here") if method.nil?
    
    method.call(args)
  end

  private
  
  def can_call?(meth)
    unless @clazz.instance_methods.include?(meth.to_s)
      raise BadMockError.new("instances of #{clazz.to_s} don't respond to #{meth.to_s}")
    end
  end

  def same_response?(meth, args, &block)
    fake_output = block.call(args).class
    real_output = @clazz.new.send(meth.to_s, *args).class
    unless fake_output == real_output
      raise BadMockError.new("#{clazz.to_s}.#{meth.to_s} returns a #{real_output.class}, not a #{fake_output.class}")
    end
  end
end

class BadMockError < Exception; end
