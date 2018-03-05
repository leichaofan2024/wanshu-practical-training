# a = gets.to_i
# b = gets.to_i
#
#
# if a==b
#   puts a
# else
#   sum = 0
#   (a..b).each do |c|
#     sum += c
#   end
#   puts sum
# end


# e = gets.to_s
# f=e.split("")
# m= f.size
# g=[]
# f.each do |a|
#   b=a.downcase
#   g<<b
# end
# h=g.uniq
# n= h.size
# if m==n
#   puts "true"
# else m>n
#   puts "false"
# end



a = gets.to_s
b = a.split("")
c=[]
b.each do |d|
  c<<d.to_i
end
n = c.size

(0..(n-1)).each do |x|
  m=0
  (0..(n-1)).each do |y|
    if m < n-1
      if c[m] <= c[m+1]
        e = c[m]
        f = c[m+1]
        c[m] = f
        c[m+1] = e
      end
      m += 1
    end
  end
end

sum = c.join.to_i
puts sum 
