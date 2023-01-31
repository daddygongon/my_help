module MyHelp
  RSpec.describe "md2hash_new" do
    context "options" do
      it "accept options" do
        debug = Md2Hash_new.new("", debug: true).opts[:debug]
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
        @md2hash = Md2Hash_new.new(@md_text)
      }
      it "reads text" do
        actual = @md2hash.md_text
        expected = @md_text.split("\n")
        # expected = ["# head1", "  - hage",
        #             "# head2", "  - hage", "  - hoge"]
        expect(actual).to eq(expected)
      end
      it "has contents of Hash" do
        contents = @md2hash.contents
        expect(contents).to be_a(Hash)
      end
      it "outputs a correct hash" do
        results = @md2hash.results
        contents = @md2hash.contents
        expected = {
          "head1" => { :head_num => 1, :cont => ["  - hage"] },
          "head2" => { :head_num => 1, :cont => ["  - hage", "  - hoge"] },
        }

        expect(contents).to eq(expected)
      end
    end
    context "hierarchy hash" do
      before {
        @md_text = <<HEREDOC
# head1
## head1-2
  - hage
HEREDOC
        @md2hash = Md2Hash_new.new(@md_text)
      }
      it "reads text" do
        results = @md2hash.results
        contents = @md2hash.contents
        # expected = @md_text.split("\n")
        expected = {
          "head1" => { :head_num => 1, :cont => [] }, "head1-2" => { :head_num => 2, :cont => ["  - hage"] },
        }

        # expected = {
        #   "head1" => {
        #     "head1-2" => ["   - hage"],
        #   },
        # }
        expect(contents).to eq(expected)
      end
    end
  end
end
