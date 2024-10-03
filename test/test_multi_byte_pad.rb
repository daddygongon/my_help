# <2024/10/03 thu>
# formatted padding for mixed bytes str

def full_width_count(str)
  str.each_char.map do |c|
    c.bytesize == 1 ? 1 : 2
  end.reduce(0, &:+)
end

def display_formatted(item, content, length=10)
  pad_length = length - full_width_count(item)
  pad = " " * pad_length
  [pad + item,
   content
  ].join(' : ')
end

[['name', 'description'],
 ['なまえ', '記述'],
].each do |item, content|
  puts display_formatted(item, content)
end
