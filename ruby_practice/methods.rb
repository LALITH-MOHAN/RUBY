def greet(name="Guest")
    puts "HELLO,#{name}"
end

greet("LALITH") #with argument
greet #without arguments

def login(name:,password:123) #keyword argument
    puts "NAME:#{name} password:#{password}"
end

login(name:"LALITH",password:122)
login(name:"LALITH")

def sum(*num)
    total=0
    num.each{|n| total+=n}
    total
end

s1=sum(1,2,3,4,5,6)
s2=sum(1,2,3)

puts s1
puts s2