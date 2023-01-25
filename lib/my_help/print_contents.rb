# require_relative "md2hash"
# require_relative "org2hash"

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
      output = ""
      #@contents.split("\n").each do |key, val|
      @contents.each do |key, val|
        #p [key, val]
        n = @contents[key][:head_num]
        if n <= level
          if n == 1
            s1 = "- %s\n" % key
            output = output + s1
          else
            for i in 1..n - 1
              s2 = "  "
            end
            s3 = "- %s\n" % key
            output = output + s2 + s3
          end
        end
      end
      return output
    end
  end
end

# contents = ""
# File.open("./sample.org", "r") do |file|
#   file.each_line do |line|
#     contents = contents + line
#   end
# end

# contents1 = List2::Org2hash.new(contents).fsm_2
# List2::Print.new(contents1).list(2)
