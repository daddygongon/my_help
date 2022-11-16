RSpec.describe "md2hash" do
  context "options" do
    it "accept options" do
      debug = Md2hash.new("", debug: true).opts[:debug]
      expect(debug).to be_truthy
    end
    it "accept without options" do
      Md2hash.new("")
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
      @md2hash = Md2hash.new(@md_text)
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
        "head1" => ["  - hage"],
        "head2" => ["  - hage", "  - hoge"],
      }

      # expected = {
      #   "head1" => {
      #     "head1-2" => ["   - hage"],
      #   },
      #   "head2" => ["  - hage", "  - hoge"],
      # }

      expect(contents).to eq(expected)
    end
  end
end
