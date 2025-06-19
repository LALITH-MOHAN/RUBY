module A
    def say
      "from A"
    end
  end
  
  module B
    def say
      "from B"
    end
  end
  
  module C
    def extra
      "Class method from C"
    end
  
    def greet
      "Hello from C"
    end
  end
  
  class Example
    prepend A
    include B
    extend C     # This brings C's instance methods into Example as class methods
  end
  
  ex = Example.new
  puts ex.say           # => "from A"
  puts Example.greet    # => "Hello from C"
  puts Example.extra    # => "Class method from C"
  