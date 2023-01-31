# require_relative "org2hash_new"

module MyHelp
  class Print
    attr_accessor :contents

    def initialize(contents = "")
      @contents = contents
    end

    def list(level = 1)
      output = ""
      @contents.each do |key, val|
        n = @contents[key][:head_num]

        key, desc = key.split(":")
        desc ||= ""

        if n <= level
          if n == 1
            s0 = "*"

            s1 = ""
            for i in 1..level - 1
              s1 += " "
            end

            s2 = format("%20s : %s\n", key, desc)
            output += s0 + s1 + s2
          else
            s3 = ""
            for i in 1..n
              s3 += "*"
            end

            s4 = ""
            for j in 1..level - n
              s4 += " "
            end

            s5 = format("%20s : %s\n", key, desc)

            output += s3 + s4 + s5
          end
        end
      end
      return output
    end
  end
end

# contents = <<HEREDOC
# * head1 : a
# - hoge
# ** head1-2 : b
# * head2 : c
# - hage
# ** head2-2
# *** head2-3
# **** head2-4
# - hoge
# ***** head2-5
# * head3 : d
# ** head3-2 : e
# *** head3-3 :
# HEREDOC

# contents1 = MyHelp::Org2Hash_new.new(contents).contents
# p MyHelp::Print.new(contents1).list(5)
