SemVer
======

quickstart on the command line
------------------------------
    % semver init
    % semver tag                # => v0.0.0
    % semver inc minor          # => v0.1.0
    % git tag -a `semver tag`
    % say 'that was easy'

quickstart for ruby
-------------------
    v = SemVer.find             #
    v.major                     # => "0"
    v.major.next!
    v.major                     # => "1"
    v.format "%M.%m.%p"         # => "1.1.0"
    v.save
