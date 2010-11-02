if RUBY_PLATFORM == "java"
  require File.dirname(__FILE__) / "jruby_args"
elsif RUBY_VERSION < "1.9" and !(defined? RUBY_ENGINE and RUBY_ENGINE == "rbx")
  require File.dirname(__FILE__) / "mri_args"
else
  require File.dirname(__FILE__) / "vm_args"
end

class UnboundMethod
  include GetArgs
end

class Method
  include GetArgs
end
