module MyHelp
  RSpec.describe List do
    let(:templates_path) do
      File.join(File.dirname(__FILE__),
                "../../lib/templates")
    end

    describe "list" do
      context "拡張子が.orgならそっちで動く" do
        it "ヘルプ名がないときは，全てのヘルプとその簡単な内容説明を表示" do
          output = "example: "
          #pList.new(templates_path).list
          expect(List.new(templates_path).list).to be_include(output)
        end
        it "ヘルプ名があるときは，その中の全てのitemを表示" do
          output = "example"
          help_options = "example"
          #p List.new(templates_path).list(help_options)
          expect(List.new(templates_path).list(help_options)).to be_include(output)
        end
        it "item名があるときは，そのcontentを表示" do
          output = "- content_b"
          help_options = "example b_item"
          #p List.new(templates_path).list(help_options)
          expect(List.new(templates_path).list(help_options)).to be_include(output)
        end
        it "item名に似たitemがあるときは，そのcontentを表示" do
          output = "- content_b"
          help_options = "example b_"
          #p List.new(templates_path).list(help_options)
          expect(List.new(templates_path).list(help_options)).to be_include(output)
        end
        it "item名に似たitemが見つからないときは，その旨を返す" do
          output = "Can't find similar item name with :"
          help_options = "example ba_item"
          #p List.new(templates_path).list(help_options)
          expect(List.new(templates_path).list(help_options)).to be_include(output)
        end
        # 追加
        it "layerが指定されているときは，指定されたlayerに合うように階層表示" do
=begin
        output = <<HEREDOC
-               head1  :  a
-                   head1-2  :  b
-               head2  :  c
-               head3  :  d
-                   head3-2  :  e
-                         head3-3  :
HEREDOC
=end
          output = "\e[0;36;49mmy_help called with name : sample, item : \n\e[0m-               head1  :  a\n-                   head1-2  :  b\n-               head2  :  c\n-               head3  :  d\n-                   head3-2  :  e\n-                         head3-3  : \n"
          ext = ".org"
          layer = 3
          help_options = "sample"
          p List.new(templates_path, ext, layer).list(help_options)
          expect(List.new(templates_path, ext, layer).list(help_options)).to eq(output)
        end
      end
      context "拡張子が.mdならそっちで動く" do
        before {
          @ext = ".md"
        }
        it "ヘルプ名がないときは，全てのヘルプとその簡単な内容説明を表示" do
          output = "example: "
          #p List.new(templates_path, @ext).list
          expect(List.new(templates_path, @ext).list).to be_include(output)
        end
        it "ヘルプ名があるときは，その中の全てのitemを表示" do
          output = "example"
          help_options = "example"
          #p List.new(templates_path, @ext).list(help_options)
          expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
        end
        it "item名があるときは，そのcontentを表示" do
          output = "- content_b"
          help_options = "example b_item"
          #p List.new(templates_path, @ext).list(help_options)
          expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
        end
        it "item名に似たitemがあるときは，そのcontentを表示" do
          output = "- content_b"
          help_options = "example b_"
          #p List.new(templates_path, @ext).list(help_options)
          expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
        end
        it "item名に似たitemが見つからないときは，その旨を返す" do
          output = "Can't find similar item name with :"
          help_options = "example ba_item"
          #p List.new(templates_path, @ext).list(help_options)
          expect(List.new(templates_path, @ext).list(help_options)).to be_include(output)
        end
        it "layerが指定されているときは，指定されたlayerに合うように階層表示" do
          output = "\e[0;36;49mmy_help called with name : sample, item : \n\e[0m-               head1  :  a\n-               head2  :  b\n-                   head2-2  :  c\n-                         head2-3  :  d\n-               head3  :  e\n-                   head3-2  :  f\n"
          layer = 3
          help_options = "sample"
          #p List.new(templates_path, @ext, layer).list(help_options)
          expect(List.new(templates_path, @ext, layer).list(help_options)).to be_include(output)
        end
      end
    end
  end
end
