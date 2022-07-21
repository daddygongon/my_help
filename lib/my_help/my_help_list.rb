require "pp"

# List related module functions
# used in Control and Thor::list
module MyHelpList
  module_function

  def help_list(file_path)
    output = ""
    help = auto_load(file_path)
    help.each_pair do |key, conts|
      output << conts[:cont] if key == :head
      output << disp_opts(conts[:opts])
    end
    output
  end

  def item_list(file_path, item)
    help = auto_load(file_path)
    select = select_item(help, item) # or nil　
    output = begin
        help[:head][:cont]
      rescue
        ""
      end
    output << "-" * 5 + "\n" + select.to_s.green + "\n"
    output << begin
      help[select][:cont]
    rescue
      raise WrongItemName, "No item entry: #{item}"
    end
  end

  def auto_load(file_path)
    if File.extname(file_path) == ".org"
      cont = OrgToYaml.new(file_path).help_cont
    else
      puts "Not handling file types of #{file_path}"
      cont = nil
    end
    cont
  end

  def select_item(help, item)
    o_key = nil
    help.each_pair do |key, cont|
      next if key == :license or key == :head
      if cont[:opts][:short] == item or cont[:opts][:long] == item
        o_key = key
        break
      end
    end
    o_key
  end

  def disp_opts(conts)
    output = ""
    col = 0
    conts.each_pair do |key, item|
      case col
      when 0; output << item.rjust(5) + ", "
      when 1; output << item.ljust(15) + ": "
      else; output << item       end
      col += 1
    end
    output << "\n"
  end
end
