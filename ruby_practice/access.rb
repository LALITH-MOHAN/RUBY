class User
    def initialize(age)
        @age=age
    end
    def show_age(other)
        other.age
    end
    def older_than?(other)
        self.age>other.age
    end
    protected
     def age
        @age
     end
end

u1=User.new(30)
u2=User.new(60)

puts u1.show_age(u2)

puts u2.older_than?(u1)
