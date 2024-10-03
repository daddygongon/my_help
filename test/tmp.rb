def full_width_count(str)
  p str
  str.each_char.select do |char|
    p char
  end
end

p full_width_count('name')
p full_width_count('なまえ')
