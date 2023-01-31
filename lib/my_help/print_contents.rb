# require_relative "org2hash_new"

module MyHelp
  class Print
    attr_accessor :contents

    def initialize(contents = "")
      @contents = contents
    end

    def list(level = 1)
      s1 = ""
      s2 = ""
      s3 = ""
      s5 = ""
      output = ""

      #@contents.split("\n").each do |key, val|
      @contents.each do |key, val|
        #p [key, val]
        n = @contents[key][:head_num]
        key, desc = key.split(":")
        desc ||= ""

        if n <= level
          if n == 1
            s1 = format("- %20s : %s\n", key, desc)
            output += s1
          else
            s3 = "-"
            s4 = ""
            for i in 1..n - 1
              s2 = "      "
              s4 += s2
            end

            s5 = format(" %20s : %s\n", key, desc)
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
# * head3 : d
# ** head3-2 : e
# *** head3-3 :
# HEREDOC

# contents1 = MyHelp::Org2Hash_new.new(contents).contents
# p MyHelp::Print.new(contents1).list(3)
