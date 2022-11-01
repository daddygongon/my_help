module MyHelp
  RSpec.describe Org2Hash do
    let(:org_text) {
      "
#+STARTUP: indent nolineimages overview
* head
- help_title example
* license
-      cc by Shigeto R. Nishitani, 2016-22
* a_item : item_short_description
- content_a
* b_item
- content_b
"
    }
    describe "text" do
      it "returns input" do
        expect(Org2Hash.new(org_text).text).to be_include("#+STARTUP")
      end
    end
    describe "contents" do
      it "returns hash" do
        expect(Org2Hash.new(org_text).contents).to be_a(Hash)
      end
      it "returns items and contents" do
        expect(Org2Hash.new(org_text).contents).to be_a(Hash)
      end
    end
  end
end
