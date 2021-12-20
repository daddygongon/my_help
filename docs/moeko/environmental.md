# my_helpというアプリケーションをArubaを使ってテストしてみた．
今回は環境構築．

## 初めに

["daddygongon/my_help"](https://github.com/daddygongon/my_help)

上記のURLをクリックしてcodeのSSHをcopyする．

ターミナルにいき，

```bash
> git clone 先ほどコピーしたSSHのアドレスを貼り付ける
```

とする．

これでmy_helpが入る．

## specファイルを作成

これではまだArubaでテストできるような仕様になっていない(rspecが入っていない)ため，ここからやっていく．
まず，specファイルを作る．

```
> mkdir spec
```

この中にどんどん入れていく．
前に別のアプリケーションでRspecで環境構築したものがあったのでそれを使っていく

```/.spec
--format documentation
--color
--require spec_helper
```

上記はmy_helpに作る(隠しファイル)

```/cli_spec.rb
require 'spec_helper'

RSpec.describe 'hello_thor',type: :aruba do
  context 'version option' do
    before(:each){run_command('hello_thor version')}
    it {expect(last_command_started).to be_successfully_executed}
  end
end
```

```/my_help_spec.rb
 coding: utf-8                                                                                                         
# frozen_string_literal: true                                                                                           

RSpec.describe HelloThor do
  it "has a version number" do
    expect(HelloThor::VERSION).not_to be nil
  end

  describe "HelloThor::Hello" do
    subject(:hello){HelloThor::Hello.new}#主語                                                                          

    describe "run with no arg" do
      it {expect(hello.run).to eq('Hello world.')}
    end

    describe "run with an arg 'Moeko'" do
      it {expect(hello.run('Moeko')).to eq('Hello Moeko.')}
    end

  end
end
```

中身は違うアプリケーションからコピーしているため改良が必要(ファイル名が違う）

```/spec_helper.rb
 frozen_string_literal: true                                                                                           

require "my_help"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure                                                                
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`                                                      
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

::Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
```

specファイルの中に上記３つを作る．

gemspecファイルを開いて,

```
 s.add_development_dependency 'rspec'
```
をコメントアウト外す．そして，下記を追加

```
s.add_runtime_dependency 'thor'
s.add_development_dependency 'aruba'
```

最終的にgemspecファイルは下記のようになる．

```/my_help.gemspec
require File.join([File.dirname(__FILE__),'lib','my_help','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'my_help'
  s.version = MyHelp::VERSION
  s.author = 'Shigeot R. Nishitani'
  s.email = ''
  s.homepage = 'https://github.com/daddygongon/my_help'
  s.platform = Gem::Platform::RUBY
  s.license       = "MIT"
  s.summary       = %q{user building help}
  s.description   = %q{user building help}
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.require_paths = ["lib"]
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'test-unit'
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency "colorize"
  s.add_runtime_dependency "command_line"
end
```

そして，

```bash
> bundle install
```

## Thorを確認

おそらく入っているので挙動確認する.


```bash
> bundle exec rspec
```

## Arubaを入れる

["Aruba gemでCLIテストを支援する"](https://qiita.com/tbpgr/items/41730edcdb07bb5b59ad)

基本はこれ通りにしていくのだが，エラーが発生するので以下の記事に従って書き換える．

["Aruba gemでfizz buzzテストを書いてみた"](https://qiita.com/mek001/items/4c46af014f66b201288c)

最後に

```bash
> bundle exec rspec
```

でok

これであとはspec/cli_spec.rbを書き加えていくとArubaのテストとなる．








  

