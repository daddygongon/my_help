module MyHelpList
  module_function
  
  def help_list(file_path)
    output = ''
    help = auto_load(file_path)
    help.each_pair do |key, conts|
      output << conts[:cont] if key==:head
      output << disp_opts( conts[:opts] )
    end
    output
  end

  def auto_load(file_path)
    case File.extname(file_path)
      #      when '.yml'
      #        cont = YAML.load(File.read(file_path))
      when '.org'
      cont = OrgToYaml.new(file_path).help_cont
    else
      puts "Not handling file types of #{file_path}"
      cont = nil
    end
    cont
  end
    def disp_opts( conts )
      output = ''
      col = 0
      conts.each_pair do |key, item|
        case col
        when 0 ; output << item.rjust(5)+", "
        when 1 ; output << item.ljust(15)+": "
        else   ; output << item
        end
        col += 1
      end
      output << "\n"
    end


end
