def modify(arr)
    arr.push(8)
    arr.delete(2)
    arr[1]=0
end

a=[1,2,3,4]
modify(a) #will affect the original
print a
puts
def reassign(arr)
    arr=[2,2,2,2,2]
    print "INSIDE:#{arr}"
end

reassign(a) #will not affect the original
puts
print a