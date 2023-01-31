require_relative "./org2yml"
# require "colorize"
require "colorized_string"

module MyHelp
  # Your code goes here...
  class List
    def initialize(path = "", ext = ".md", layer = 1)
      @path = path
      @ext = ext
      @layer = layer
    end

    def list(help_options = "", _level = 0)
      name, item = help_options.split(" ")
      if item.nil? && name.nil?
        list_helps
      else
        path = if File.exist?(name + @ext)
            name + @ext
          else
            File.join(@path, name + @ext)
          end
        list_help_with(path, name, item)
      end
    end

    def read_help(file)
      info = {}
      #info[:items] = Org2Hash.new(File.read(file)).contents

      if @ext == ".org"
        info[:items] = Org2Hash_new.new(File.read(file)).contents
      end
      if @ext == ".md"
        info[:items] = Md2Hash_new.new(File.read(file)).contents
      end
      info[:name] = File.basename(file).split(".")[0]
      info
    end

    def list_helps
      files = File.join(@path, "*#{@ext}")
      Dir.glob(files).inject("") do |out, file|
        #        p [out, file]
        help_info = read_help(file)
        #p help_info[:items]["head"][:cont][0]
        # p help_info[:items]["head"].split("\n")[0]
        head = if help_info[:items]["head"]
            help_info[:items]["head"][:cont][0]
          else
            ""
          end
        out << format("%10s: %s\n", help_info[:name], head)
      end
    end

    # defaultで@path/name.@extのヘルプを読み込んで，itemを表示

    def list_help_with(path, name, item)
      @help_info = read_help(path)
      output = ColorizedString["my_help called with name : #{name}, item : #{item}\n"].colorize(:cyan)

      if item.nil?
        contents = @help_info[:items]
        #p contents
        output << Print.new(contents).list(@layer)
      else
        output << find_near(item)
      end
      output
    end

    def find_near(input_item)
      candidates = []
      @help_info[:items].each_pair do |item, _val|
        candidates << item if item.include?(input_item)
      end
      if candidates.size == 0
        "Can't find similar item name with : #{input_item}"
      else
        contents = candidates.collect do |near_item|
          ColorizedString["item : #{near_item} \n"].colorize(:cyan) +
            @help_info[:items][near_item][:cont][0]
          # @help_info[:items][near_item]
        end
        contents.join("\n")
      end
    end
  end
end
