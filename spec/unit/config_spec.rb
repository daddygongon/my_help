require "pp"
require "fileutils"

module MyHelp
  RSpec.describe Config do
    describe "クラス変数config" do
      include_context :uses_temp_dir
      let(:tmp_conf) {
        Config.new(temp_dir).config
      }
      it "default confを返す" do
        expect(tmp_conf[:ext]).to eq(".org")
      end
      it "default confに正しいkeyが設定されている" do
        # pp Config.new.config
        [:template_dir, :local_help_dir, :conf_file, :editor, :ext].each do |key|
          expect(tmp_conf).to have_key(key)
        end
      end
    end

    describe "configを変更するconfigure" do
      let(:tmp_conf) {
        Config.new
      }
      it "間違ったkey(:dir)を設定するとKeyErrorが返る" do
        file_path = "hoge"
        expect {
          tmp_conf.configure(dir: file_path)
        }.to raise_error(KeyError)
      end
      it ":extに'.md'を正しく設定できる" do
        expect(tmp_conf.configure(ext: ".md")[:ext]).to eq(".md")
      end
      it ":editorに'code'を正しく設定できる" do
        expect(tmp_conf.configure(editor: "code")[:editor]).to eq("code")
      end
    end

    describe "temp_dirを指定してconfigure" do
      include_context :uses_temp_dir
      let(:tmp_conf) {
        Config.new(temp_dir)
      }
      it ":local_help_dirにpathが正しく設定されている" do
        expect(tmp_conf.config[:local_help_dir]).to eq(File.join(temp_dir, ".my_help"))
      end
      it ":extに'.org'が正しく設定されている" do
        expect(tmp_conf.config[:ext]).to eq(".org")
      end
      it ":local_help_dirに.my_help_conf.ymlを保存する" do
        Dir.mkdir(tmp_conf.config[:local_help_dir])
        tmp_conf.save_config()
        expect(File.exist?(File.join(temp_dir, ".my_help", ".my_help_conf.yml"))).to be_truthy
      end
    end
  end
end
