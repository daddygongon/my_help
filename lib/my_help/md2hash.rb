# DEFINE NAME TRUE #symbol
# :init 0
# :ignore 1
# :reading 2
# :item 3
# array state_action = [:init, :ignore] => [0,1]
# int score[10]
# TRANS = { init: {}, }
# TRANS = { :init => {}, }
#
# state=:init, line[0]='#'
#state, action = TRANS[state][line[0]] => TRANS[:init]['#'] = [:reading, :item]
#state = :reading
#action= :iem
#state, action = TRANS[state]['#'] = [:action, :item]

class Md2hash
  attr_accessor :md_text, :contents, :results, :opts

  def initialize(md_text = "", **opts)
    @opts = opts
    @md_text = md_text.split("\n")
    @contents = fsm
    #fsm()
  end

  TRANS = {
    #current
    #            new         action
    #-----------------------------------
    init: {
      #"*" => [:init, :ignore],
      :default => [:init, :ignore],
      "#" => [:reading, :item],
    },

    reading: {
      "#" => [:reading, :item],
      :default => [:reading, :data],
    },
  }

  def fsm
    contents = {}
    state = :init
    @results = []
    item = ""
    @md_text.each do |line|
      state, action = TRANS[state][line[0]] || TRANS[state][:default]

      results << [line, state, action]

      case action
      when :ignore
      when :item
        item = line.match(/^#* (.+)/)[1]
        contents[item] = []
      when :data
        contents[item] << line
      end
    end

    return contents
  end
end
