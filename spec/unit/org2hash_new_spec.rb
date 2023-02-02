module MyHelp
  RSpec.describe "org2hash_new" do
    context "options" do
      it "accept options" do
        debug = Org2Hash_new.new("", debug: true).opts[:debug]
        expect(debug).to be_truthy
      end
      it "accept without options" do
        Org2Hash_new.new("")
      end
    end
    context "fsm" do
      before {
        @org_text = <<HEREDOC
#+STARTUP: indent nolineimages overview
* head1
  - hage
* head2
  - hage
  - hoge
HEREDOC
        @org2hash = Org2Hash_new.new(@org_text)
      }
      it "reads text" do
        actual = @org2hash.org_text
        expected = @org_text.split("\n")
        # expected = ["#+STARTUP: indent nolineimages overview",
        #             "* head1", "  - hage",
        #             "* head2", "  - hage", "  - hoge"]
        expect(actual).to eq(expected)
      end
      it "has contents of Hash" do
        contents = @org2hash.contents
        expect(contents).to be_a(Hash)
      end
      it "fsm" do
        results = @org2hash.results
        contents = @org2hash.contents
        expected = { "head1" => { :cont => ["  - hage"], :head_num => 1 },
                     "head2" => { :cont => ["  - hage", "  - hoge"], :head_num => 1 } }
=begin
        expected = {
          "head1" => ["  - hage"],
          "head2" => ["  - hage", "  - hoge"],
        }
=end
        expect(contents).to eq(expected)
      end
    end
  end
end
