a=2
b=9.0
puts b.class
puts "ADDITION:#{a+b}"

def subraction(a,b)
    puts "SUB:#{b-a}"
end
=begin
 multi line comment
=end
subraction(a,b) #methods

fruits=['apple','orange','banana']
fruits<<'grape' #push element into array
fruits.each do|fruit| 
    print "#{fruit} "
end

x=2
y=5
puts y || x

puts (1...10).to_a
