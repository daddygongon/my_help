
module MyHelp
  RSpec.describe Md2Hash do
    context "options" do
      it "accept options" do
        debug = Md2Hash.new("", debug: true).opts[:debug]
        expect(debug).to be_truthy
      end
      it "accept without options" do
        Md2Hash.new("")
      end
    end
    context "fsm" do
      before {
        @md_text = <<HEREDOC
# head1
    - hage
# head2
    - hage
    - hoge
HEREDOC
        @Md2Hash = Md2Hash.new(@md_text)
      }
      it "reads text" do
        actual = @Md2Hash.md_text
        expected = @md_text.split("\n")
        # expected = ["#+STARTUP: indent nolineimages overview",
        #             "# head1", "  - hage",
        #             "# head2", "  - hage", "  - hoge"]
        expect(actual).to eq(expected)
      end
      it "has contents of Hash" do
        contents = @Md2Hash.contents
        expect(contents).to be_a(Hash)
      end
      it "outputs a correct hash" do
        results = @Md2Hash.results
        contents = @Md2Hash.contents
        expected = { "head1" => ["    - hage"],
                     "head2" => ["    - hage", "    - hoge"] }
        expect(contents).to eq(expected)
      end
    end
  end
end
