module MyHelp
  class Md2Hash
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

        if line[0..1] == "#+" # line[1] != " "
          state = :init
          action = :ignore
        end

        results << [line, state, action]

        case action
        when :ignore
        when :item
          item = line.match(/^# (.+)/)[1]
          contents[item] = []
        when :data
          contents[item] << line
        end
      end
      return contents
    end
  end
end
