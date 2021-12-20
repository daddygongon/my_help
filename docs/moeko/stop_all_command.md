
# Relishを日本語訳してみた stop_all_commands編

## 初めにRelishとは

[Relish](https://relishapp.com)

RelishはCucumberの機能を検索できるサイトである．

[Project:Aruba](https://relishapp.com/philoserf/aruba/docs)
projectの一つにArubaがあり，そこにはcommandの解説などが全て英語で記述されている
筆者は英語が得意ではないためすぐに見直しができるよう，頑張って日本語訳をしてみた．
今回はtestで仕様するコマンドの一つである"stop_all_command"について記述していく

参考ページ
[Stop_all_command](https://relishapp.com/philoserf/aruba/docs/command/stop-all-commands)

## 日本語訳

実行中の全てのコマンドの実行を止めるときに使用するコマンドが"stop_all_commands-method"である．

例

```ruby:spec/run_spec.rb
require 'spec_helper'

RSpec.describe 'learner', type: :aruba do
    context 'version option' do
        before(:each){run_command('learner version')}
        before(:each) { stop_all_commands }
        it { expect(all_commands).to all be_stopped }
    end
  end
end
```

```bash
> bundle exec rspec 
learner
  version option
    is expected to all be stopped
```












