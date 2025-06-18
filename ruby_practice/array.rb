nums=Array(1..10)
#iteration
nums.each{|n| print "#{n*n} "}
#filter
print "\n"
print nums.select{|n| n.odd?}
puts
print nums.join('-')

print nums.sort()

nums.unshift(10)

print nums.sort()

print (nums.uniq()).sort()

puts Time.now()