require "tmpdir"
require "fileutils"
# [[https://gist.github.com/sue445/d840d6f68771a14a48fc][Example of using temporary directory at rspec]]

module MyHelp
  RSpec.describe Init do
    # context :uses_temp_dir is put on spec/spec_helper.rb now.
    include_context :uses_temp_dir
    let(:config) { Config.new(temp_dir) }

    describe "example of uses_temp_dir" do
      it "should create temp_dir" do
        expect(Dir.exists?(temp_dir)).to be true
      end

      it "can create file in temp_dir" do
        temp_file = "#{temp_dir}/temp.txt"

        File.open(temp_file, "w") do |f|
          f.write("foo")
        end

        expect(File.read(temp_file)).to eq "foo"
      end
    end

    describe "cp_templates" do
      it "cp_templatesでtemplatesの*.extをcpする" do
        # assume :ext = 'org'
        target = File.join(temp_dir, ".my_help")
        FileUtils.mkdir(target)
        Init.new(config).cp_templates
        expect(File).to exist(File.join(target, "example.org"))
      end
    end
  end
end
