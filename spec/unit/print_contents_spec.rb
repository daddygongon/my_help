module MyHelp
  RSpec.describe "print" do
    it "orgの階層表示" do
      level = 2
      contents = <<HEREDOC
* head1
** head1-2
- hoge
- hage
*** head1-3
- hoge
* head2
** head2-2
HEREDOC
      contents1 = Org2Hash_new.new(contents).fsm_2
      actual = Print.new(contents1).list(level)

      output = "-                head1 : \n-                    head1-2 : \n-                head2 : \n-                    head2-2 : \n"
      expect(actual).to eq(output)
    end
    it "mdの階層表示" do
      level = 2
      contents = <<HEREDOC
# head1
## head1-2
- hoge
- hage
### head1-3
-hoge
#### head1-4
-hage
    
# head2
- hage
- hoge
## head2-2
- hage
### head2-3
    
# head3
## head3-2
HEREDOC

      contents1 = Md2Hash_new.new(contents).fsm_2
      actual = Print.new(contents1).list(level)

      output = "-                head1 : \n-                    head1-2 : \n-                head2 : \n-                    head2-2 : \n-                head3 : \n-                    head3-2 : \n"
      expect(actual).to eq(output)
    end
  end
end
