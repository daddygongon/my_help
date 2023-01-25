# DEFINE NAME TRUE #symbol
# :init 0
# :ignore 1
# :reading 2
# :item 3
# array state_action = [:init, :ignore] => [0,1]
# int score[10]
# TRANS = { init: {}, }
# TRANS = { :init => {}, }
# state=:init, line[0]='#'
#state, action = TRANS[state][line[0]] => TRANS[:init]['#'] = [:reading, :item]
#state = :reading
#action= :item
#state, action = TRANS[state]['#'] = [:action, :item]

module MyHelp
  class Md2Hash_new
    attr_accessor :md_text, :contents, :results, :opts

    def initialize(md_text = "", **opts)
      @opts = opts
      @md_text = md_text.split("\n")
      @contents = fsm
      @contents = fsm_2
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
        line
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

    def fsm_2
      contents = {}
      state = :init
      @results = []
      item = ""
      @md_text.each do |line|
        state, action = TRANS[state][line[0]] || TRANS[state][:default]

        results << [line, state, action]
        current_item = case action
          when :ignore
          when :item
            m = line.match(/^(#*) (.+)/)
            head, item = m[1], m[2]
            head_num = head.chomp.size || 0
            contents[item] = { head_num: head_num, cont: [] }
            contents[item]
          when :data
            contents[item][:cont] << line
          end
      end
      contents
      # p contents = {
      #   "head1" => {
      #     "head1-2" => ["   - hage"],
      #   },
      # }
    end
  end
end
