module MyHelp
  # get org and trans it to hash by FSM
  class Org2Hash
    attr_accessor :contents, :text
    # current_state => [  new_state,    action ]
    TRANSITIONS = {
      :header_read => {
        "* " => [:contents_read, :start_new_item],
        :default => [:header_read, :ignore],
      },
      :contents_read => {
        "* " => [:contents_read, :start_new_item],
        :default => [:contents_read, :add_contents],
      },
    }

    def initialize(org_text)
      @text = org_text
      @contents = Hash.new
      simple_fsm()
    end

    def simple_fsm()
      state = :header_read
      item = ""
      @text.split("\n").each do |line|
        next if line.size < 1
        state, action = TRANSITIONS[state][line[0..1]] ||
                        TRANSITIONS[state][:default]
        case action
        when :ignore
        when :start_new_item
          item = read_item(line)
          @contents[item] = ""
        when :add_contents
          @contents[item] << line
        end
      end
    end

    def read_item(line)
      m = line.match(/\* (.+)/)
      item = if m
               m[1].match(/head\s*/) ? "head" : m[1]
             else
               nil
             end
      return item
    end
  end
end
