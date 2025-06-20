def slow_task(name)
    sleep(2)
    puts "#{name} finished"
end

threads=[]

['a','b','c'].each{|name| threads<<Thread.new{slow_task(name)}} #with threads it take 2s for all

threads.each(&:join)

['x','y','z'].each{|name| slow_task(name)} #without threads it take 6s