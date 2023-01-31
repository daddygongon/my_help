module MyHelp
  class Org2Hash_new
    attr_accessor :org_text, :contents, :results, :opts

    def initialize(org_text = "", **opts)
      @opts = opts
      @org_text = org_text.split("\n")
      @contents = fsm
      @contents = fsm_2
      #fsm()
    end

    TRANS = {
      #current
      #            new         action
      #-----------------------------------
      init: {
        #"#" => [:init, :ignore],
        :default => [:init, :ignore],
        "*" => [:reading, :item],
      },
      reading: {
        "*" => [:reading, :item],
        :default => [:reading, :data],
      },
    }

    def fsm
      contents = {}
      state = :init
      @results = []
      item = ""
      @org_text.each do |line|
        state, action = TRANS[state][line[0]] || TRANS[state][:default]
        results << [line, state, action]

        case action
        when :ignore
        when :item
          item = line.match(/^* (.+)/)[1]
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
      @org_text.each do |line|
        state, action = TRANS[state][line[0]] || TRANS[state][:default]

        results << [line, state, action]
        current_item = case action
          when :ignore
          when :item
            m = line.match(/^(\*+) (.+)/)
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

=begin
  
rescue => exception
  
else
  
end
contents = <<HEREDOC
* head1 : a
- hoge 
** head1-2 
HEREDOC
p MyHelp::Org2Hash_new.new(contents).fsm_2
=end
