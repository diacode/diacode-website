---
title: Fixing temporary dir problems with Ruby 2
date: '2014-06-26'
tags:
  - ruby
author: javier
---

After upgrading one of our apps from ruby 1.9.3 to ruby 2.1.1 we found a weird problem. Some of the URLs in the app were throwing errors like this one:

```
could not find a temporary directory
/usr/local/rubies/2.1.1/lib/ruby/2.1.0/tmpdir.rb:34:in `tmpdir'
```

If we check out the source code for that method we see this:

```ruby
def Dir::tmpdir
  if $SAFE > 0
    tmp = @@systmpdir
  else
    tmp = nil
    for dir in [ENV['TMPDIR'], ENV['TMP'], ENV['TEMP'], @@systmpdir, '/tmp', '.']
      next if !dir
      dir = File.expand_path(dir)
      if stat = File.stat(dir) and stat.directory? and stat.writable? and (!stat.world_writable? or stat.sticky?)
        tmp = dir
        break
      end rescue nil
    end
    raise ArgumentError, "could not find a temporary directory" if !tmp
    tmp
  end
end
```

The interesting bit here is this condition: `stat.sticky?`. That condition wasn't present [in Ruby 1.9.3](http://rxr.whitequark.org/mri/source/lib/tmpdir.rb?v=1.9.3-p547).

This means that our temporary directory needs to have the [sticky bit](http://en.wikipedia.org/wiki/Sticky_bit). To check if your `/tmp` folder has that sticky bit you can do:

```
$ ls -l /
drwxrwxrwt   9 root     root      4096 Jun 26 11:35 tmp
```

If you don't see that `t` at the end of the permissions column, that means you need to add the sticky bit. You can do that with:

```
chmod o+t /tmp
```

Hope this saves you some time!
