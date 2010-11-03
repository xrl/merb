if RUBY_PLATFORM == "java"
  require File.dirname(__FILE__) / "jruby_args"
else
  begin
    # 1.8: use ParseTree, which is not supported on 1.9 and Rubinius
    require File.dirname(__FILE__) / "mri_args"
  rescue LoadError
    # use Method#parameters
    raise unless Object.method(:inspect).respond_to? :parameters
    require File.dirname(__FILE__) / "vm_args"
  end
end

class UnboundMethod
  include GetArgs
end

class Method
  include GetArgs
end
