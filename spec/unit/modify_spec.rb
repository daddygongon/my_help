require "fileutils"

module MyHelp
  RSpec.describe Modify do
    include_context :uses_temp_dir
    let(:tmp_conf) {
      Config.new(temp_dir).config
    }
    before(:each) { FileUtils.mkdir(File.join(temp_dir, ".my_help")) }
    describe "個別のヘルプをいじる" do
      it "ヘルプをnewする" do
        help_name = "example_2"
        help_file = File.join(temp_dir, ".my_help", help_name + ".org")
        Modify.new(tmp_conf).new(help_file)
        expect(File.exist?(help_file)).to be_truthy
      end
      it "ヘルプをdeleteする" do
        help_name = "example_2"
        help_file = File.join(temp_dir, ".my_help", help_name + ".org")
        FileUtils.touch(help_file)
        Modify.new(tmp_conf).delete(help_file)
        expect(File.exist?(help_file)).to be_falsy
      end
      it "ヘルプをeditする, system callなのでunit testではできない"
    end
  end
end
