module MyHelp
  RSpec.describe List do
    let(:templates_path) do
      File.join(File.dirname(__FILE__),
                "../../lib/templates")
    end

    context "拡張子が.mdならそっちで動く" do
      before {
        @ext = ".md"
      }
      it "ヘルプ名がないとき" do
        output = "example: "
        #p List.new(templates_path, @ext).list
        expect(List.new(templates_path, @ext).list).to be_include(output)
      end
      it "ヘルプ名があるとき" do
        output = "example"
        help_options = "example"
        #p List.new(templates_path, @ext).list(help_options)
        expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
      end
      it "item名があるときは" do
        output = "- content_b"
        help_options = "example b_item"
        #p List.new(templates_path, @ext).list(help_options)
        expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
      end
      it "item名に似たitemがあるとき" do
        output = "- content_b"
        help_options = "example b_"
        #p List.new(templates_path, @ext).list(help_options)
        expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
      end
      it "item名に似たitemが見つからないとき" do
        output = "Can't find similar item name with :"
        help_options = "example ba_item"
        #p List.new(templates_path, @ext).list(help_options)
        expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
      end
      it "layerが指定されているとき" do
        output = "\e[0;36;49mmy_help called with name : sample, item : \n\e[0m-               head1  :  a\n-               head2  :  b\n-                   head2-2  :  c\n-                         head2-3  :  d\n-               head3  :  e\n-                   head3-2  :  f\n"
        layer = 3
        help_options = "sample"
        p List.new(templates_path, @ext, layer).list(help_options)
        expect(List.new(templates_path, @ext, layer).list(help_options)).to be_include(output)
      end
    end
  end
end
