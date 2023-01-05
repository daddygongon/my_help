# acceptance受け入れ test
require "spec_helper"
require "aruba/api"
RSpec.describe "my_help cli_spec.rb by aruba", type: :aruba do
  #  include_context "uses aruba API"
  # context :uses_temp_dir is put on spec/spec_helper.rb now.

  context "version command" do
    before(:each) { run_command("my_help version") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output("1.0c") }
  end
  context "no command" do
    before(:each) { run_command("my_help") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(/^Commands:/) }
  end

  context "list command" do
    temp_dir = Dir.pwd
    let(:help_name) { "example" }
    let(:help_dir) { File.join(temp_dir, "lib", "templates") }
    it "list with name" do
      p help_dir
      run_command("my_help list #{help_name} a_item --help_dir=#{help_dir}")
      stop_all_commands
      expect(last_command_started).to have_output(/a_item/)
    end
  end

  context "edit option" do
    include_context :uses_temp_dir
    let(:help_name) { "example2" }
    before(:each) {
      FileUtils.mkdir(File.join(temp_dir, ".my_help"))
      run_command("my_help edit #{help_name} --help_dir=#{temp_dir}")
      stop_all_commands
    }
    #    it "editorをsystemでopen"
    it "存在しないHELPは，newしなさいと注意" do
      output = Regexp.new("make #{help_name} first by 'new' command.")
      expect(last_command_started).to have_output output
    end
  end

  context "new option" do
    include_context :uses_temp_dir
    let(:help_name) { "example2" }
    let(:example_file) { File.join(temp_dir, ".my_help", help_name + ".org") }
    before(:each) {
      FileUtils.mkdir(File.join(temp_dir, ".my_help"))
      run_command("my_help new #{help_name} --help_dir=#{temp_dir}")
      stop_all_commands
    }
    it "example2が新たに作られる" do
      expect(File.exist?(example_file)).to be_truthy
    end
  end

  context "delete option" do
    include_context :uses_temp_dir
    let(:help_name) { "example2" }
    let(:example_file) { File.join(temp_dir, ".my_help", help_name + ".org") }
    before(:each) {
      FileUtils.mkdir(File.join(temp_dir, ".my_help"))
      FileUtils.touch(example_file)
    }
    it "type Yでexample2が消される" do
      run_command("my_help delete #{help_name}  --help_dir=#{temp_dir}")
      type "Y\n"
      stop_all_commands
      expect(File.exist?(example_file)).to be_falsey
    end
    it "type Nでexample2が残る" do
      run_command("my_help delete #{help_name}  --help_dir=#{temp_dir}")
      type "N\n"
      stop_all_commands
      expect(last_command_started).to have_output(/Leave .+ exists./)
      expect(File.exist?(example_file)).to be_truthy
    end
    it "存在しないHELPのdeleteはできない" do
      run_command("my_help delete example1  --help_dir=#{temp_dir}")
      type "Y\n"
      stop_all_commands
      expect(last_command_started).to have_output(/does not exist./)
    end
  end

  context "init option" do
    include_context :uses_temp_dir
    before(:each) do
      run_command("my_help init  --help_dir=#{temp_dir} ")
    end

    it "confとhelpsがtemp_dirに保存される" do
      type ".md\n"
      stop_all_commands
      conf_file = File.join(temp_dir, ".my_help", ".my_help_conf.yml")
      expect(File.exist?(conf_file)).to be_truthy
      expect(YAML.load_file(conf_file)[:ext]).to eq ".md"
      example_file = File.join(temp_dir, ".my_help", "example.md")
      expect(File.exist?(example_file)).to be_truthy
    end
    #   it ":editor/:extの複数setupは，arubaでのrspecがわからなかったので，後で修正するようにputs"
  end

  context "set editor code" do
    include_context :uses_temp_dir
    before(:each) {
      FileUtils.mkdir(File.join(temp_dir, ".my_help"))
    }
    it "my_help/.my_help_conf.ymlに:editor = 'code'がセットされる" do
      run_command("my_help set editor 'code' --help_dir=#{temp_dir}")
      stop_all_commands
      conf_file = File.join(temp_dir, ".my_help", ".my_help_conf.yml")
      expect(File.exist?(conf_file)).to be_truthy
      expect(YAML.load_file(conf_file)[:editor]).to eq "code"
    end

    it "setで引数がないとvalidなkeywordが表示される" do
      run_command("my_help set --help_dir=#{temp_dir}")
      stop_all_commands
      #      puts File.read(conf_file)
      expect(last_command_started).to have_output(/Valid key words/)
    end
  end

  describe "# run_command でinteractiveにできるサンプル" do
    context "cat helloを試す" do
      before { run_command "cat" }

      after { all_commands.each(&:stop) }

      it "type HelloでHelloが返る" do
        type "Hello"
        type "\u0004"
        expect(last_command_started).to have_output "Hello"
        type "Hello"
        type "\u0004"
        expect(last_command_started).to have_output "Hello"
      end
    end
  end

  describe "# run_command interactiveの例" do
    context "hello 'bob'に反応する" do
      before { run_command("my_help hello") }
      #      before(:each) { stop_all_commands }

      after { all_commands.each(&:stop) }

      it "type bobでHello bobが返る" do
        type "bob\n"
        #        type "\u0004"
        close_input
        expect(last_command_started).to have_output "Hello bob."
      end
    end
  end
end
