# stdout_of_commands

## 初めに

今回はtestで使用するコマンドの一つである"stdout"について記述していく

参考ページ
[stdout_of_commands](https://relishapp.com/philoserf/aruba/docs/command/access-stdout-of-command)

## 日本語訳

You may need to #stop_all_commands before accessing #stdout of a single
command - e.g. #last_command_started.

stdoutコマンドを使う前にstop_all_commandsが必要な場合がある．
ちなみにstdout(standard output)は標準出力のことである.

例

```ruby:spec/cli_spec.rb
RSpec.describe 'learner', type: :aruba do
    context 'version option' do
        before(:each){run_command('learner version')}
        before(:each) { stop_all_commands }
        it { expect(last_command_started.stdout).to match  '.0' }
    end 
  end
end
```

この場合であれば，
一旦stop_all_commandsで全てのcommandsの実行を停止してから，
(last_command_started.stdout).to match '.0'で，learner versionの出力結果の中に.0が入っていたらtestが通るということである．

もう一つよく使うものとして

```ruby:spec/cli_spec.rb
RSpec.describe 'learner', type: :aruba do
    context 'version option' do
        before(:each){run_command('learner version')}
        before(:each) { stop_all_commands }
        it { expect(last_command_started.stdout).to start_with  '1.' }
    end 
  end
end
```

この場合であれば，
一旦stop_all_commandsで全てのcommandsの実行を停止してから，
(last_command_started.stdout).to start_with '1.'で，learner versionの出力結果の冒頭が1.から始まるのであればtestが通ることになる．

ちなみにlearner versionは

```bash
> learner version
0.1.0
```

と表示されるため，このぐらい短い出力結果であればこのようなことをしなくとも簡単に一致する．
が，長い出力結果を空白や改行までを一致させるのは面倒である．そのような時にこの機能を使用すれば簡単にtestを通すことができる．



