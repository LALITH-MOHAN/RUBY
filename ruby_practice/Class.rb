class User
     @@count=0 #clsss variable
    def initialize(name)
        @@count+=1
        @name=name #instance variable
    end

    def show_name #instance method
        puts "YOUR NAME: #{@name}"
    end
   
    def self.total_count #class method
        @@count
    end

    

end

name1=User.new("lalith")
name2=User.new("niki")

name1.show_name
name2.show_name

puts User.total_count

puts name1.class