module MyHelp
# puts hello
  class Conf
    def initialize(path)
      @path = path
    end

    def check_conf
      File.exist?(File.join(@path, ".my_help.conf"))
    end
  end
end
