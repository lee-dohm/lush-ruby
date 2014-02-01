# `lush` - Lifted Unix Shell

This is my custom Unix shell, written in [Ruby][ruby]. It is my intention to, over time, build a [POSIX-compatible shell][posix] with the following features:

* Live syntax highlighting
* Simple command and parameter completion
* Sane and opinionated defaults
* Extensibility
* Written in Ruby for rapid development

## Rationale

I used the [`fish` shell][fish] for a while and really liked a lot of the features. The major drawback to using `fish` is that it is not 100% POSIX or Bourne shell compatible. This means that there are scripts out there for things like `rbenv` or `rvm` that don't work out of the box. So I continued to lust after a better shell. I had the inkling to write my own, but I really didn't want to delve back into C/C++ to do it.

Then I stumbled upon [a series of blog articles][shell-in-ruby] that showed how to write the very beginnings of a `bash`-like shell in Ruby. I've used that as my starting point and have a lot of ideas for how to make the best new shell for Unix systems available.

## Acknowledgments

This effort was inspired by:

* [fish][fish]
* [A Unix Shell in Ruby][shell-in-ruby]
* [pry][pry]
* Every Unix shell ever made

## Copyright

Copyright &copy; 2014 [Lee Dohm](http://www.lee-dohm.com), [Lifted Studios](http://www.liftedstudios.com). See [LICENSE](LICENSE.md) for details.

[fish]: http://fishshell.com
[posix]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html
[pry]: http://pryrepl.org
[ruby]: http://www.ruby-lang.org
[shell-in-ruby]: http://www.jstorimer.com/blogs/workingwithcode/7766107-a-unix-shell-in-ruby
