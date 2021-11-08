module MyHelp
  class List
    def setup(target_dir = "example_dir")
      $control =  
    end

    def list(target_dir = "")
      file = args[0]
      item = args[1]
      if file.nil?
      #Dir.glob(target_dir).each { |file| puts file }
    end
  end
end
