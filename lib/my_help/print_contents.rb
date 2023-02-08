module MyHelp
  class Print
    attr_accessor :contents

    def initialize(contents = "")
      @contents = contents
    end

    def maximize()
      max = 0
      @contents.each do |key, val|
        n = @contents[key][:head_num]

        if max < n
          max = n
        end
      end
      max
    end

    def list(layer = 1)
      output = ""

      @contents.each do |key, val|
        n = @contents[key][:head_num]

        key, desc = key.split(":")
        desc ||= ""

        #layerが-1の時，全てのlistを表示
        if layer == -1
          s1 = ""
          for i in 1..n
            s1 += "*"
          end

          s2 = ""
          for j in 1..maximize() - n
            s2 += " "
          end

          s3 = format("%20s : %s\n", key, desc)
          output += s1 + s2 + s3
        end

        #指定したlayerに対応して階層表示
        if n <= layer
          s1 = ""
          for i in 1..n
            s1 += "*"
          end

          s2 = ""
          for j in 1..layer - n
            s2 += " "
          end

          s3 = format("%20s : %s\n", key, desc)

          output += s1 + s2 + s3
        end
      end
      return output
    end
  end
end
