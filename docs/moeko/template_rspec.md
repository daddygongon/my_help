cli_spec.rb
context 'set editor have_output matcher' do
    expected = /set editor 'emacs'/

    let(:my_help){run_command("my_help set_editor emacs -d=\'../../test\'")}
        # beforeではなく，letで変数(:my_help)に代入．
	    it { expect(my_help).to have_output(expected) }
	      end
	      ```




## 3.

例

```ruby:cli_spec.rb
  context "default help" do
      expected = /^Commands:/
          # 長い出力の全文を一致させるのではなく，
	      # 最初だけを示すRegExpに一致させるように変更
	          let(:my_help){ run_command("my_help") }
		      it { expect(my_help).to have_output(expected) }
		        end
			```

出力が長く，diffが通らないことがあった為冒頭が一致するとtestが通るようにした．

## 4.

例

```ruby:cli_spec.rb
  context "default help start_with matcher" do
      expected = "Commands:"
          # stop_all_commandsを使って，stdoutを取り出し，start_withを試した
	      # とりあえず，こんなぐらいあればrspecは書けるかな？
	          # raise_errorを試したい．．．
		      before(:each) { run_command("my_help")}
		          before(:each) { stop_all_commands }
			      it { expect(last_command_started.stdout).to start_with expected }
			        end
				```










