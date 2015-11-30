# open('/etc/hosts').each do |x|
#   p x
# end

# open('/etc/hosts') do |f|
#   f.each('\n') do |record|
#     if record =~ /sushant*.com/
#       p record
#     end
#   end
# end

open('/etc/hosts') do |f|
  matches = []
  vhosts = []
  f.readlines.each do |lines|
    matches << lines if lines =~ /.*.com/
  end
  matches.each do |val|
    val.split.each do |x|
      vhosts << x if x =~ /.*.com/
    end
  end
  p vhosts
end
