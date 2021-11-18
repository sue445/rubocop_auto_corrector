## master
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.4.3...master)

## v0.4.3
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.4.2...v0.4.3)

* Enable MFA requirement for gem releasing
  * https://github.com/sue445/rubocop_auto_corrector/pull/44

## v0.4.2
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.4.1...v0.4.2)

* Requires rubocop v1.13.0+ and drop ruby 2.4
  * https://github.com/sue445/rubocop_auto_corrector/pull/43

## v0.4.1
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.4.0...v0.4.1)

* Fixed. `auto_correctable?` doesn't work when cop has `.support_autocorrect?` and doesn't have `#autocorrect`
  * https://github.com/sue445/rubocop_auto_corrector/pull/35

## v0.4.0
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.3.0...v0.4.0)

* Add `--all` option for `rubocop --auto-correct-all`
  * https://github.com/sue445/rubocop_auto_corrector/pull/34
  * When `--all` arg is passed to `rubocop_auto_corrector` (e.g. `rubocop_auto_corrector --all`), run `rubocop --auto-correct-all && git commit` with each cop.
* Upgrade rubocop and drop support ruby 2.3
  * https://github.com/sue445/rubocop_auto_corrector/pull/31

## v0.3.0
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.2.0...v0.3.0)

* Support `rubocop-rails` gem (requires rubocop 0.72.0+ and ruby 2.3.0+)
  * https://github.com/sue445/rubocop_auto_corrector/pull/18

## v0.2.0
[full changelog](http://github.com/sue445/rubocop_auto_corrector/compare/v0.1.0...v0.2.0)

* Support `rubocop-performance` gem
  * https://github.com/sue445/rubocop_auto_corrector/pull/16

## v0.1.0
* first release
