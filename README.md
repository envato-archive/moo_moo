MooMoo
======

[![Build Status](http://travis-ci.org/site5/moo_moo.png)](http://travis-ci.org/site5/moo_moo)

Ruby library for using the Tucows OpenSRS XML API

[RDoc](http://rdoc.info/github/site5/moo_moo/master/frames)


Description
==========

Implements most of the functionality of the OpenSRS XML API. For full
documentation of the OpenSRS XML API see
http://opensrs.com/docs/opensrsxmlapi/index.htm

Usage
=====

First, create an opensrs object from which all commands are called:

    opensrs = MooMoo::OpenSRS::Base.new("horizon.opensrs.net", "<YOUR_KEY>", "<YOUR_RESELLER_USER>", "<YOUR_PASSWORD>")

Or configure MooMoo and you can initialize it without any arguments:

    MooMoo.configure do |config|
      config.host = "horizon.opensrs.net"
      config.key = "<YOUR_KEY>"
      config.user = "<YOUR_RESELLER_USER>"
      config.pass = "<YOUR_PASSWORD>"
    end

    ...

    opensrs = MooMoo::OpenSRS::Base.new

Now you can call a variety of commands to deal with domains, nameservers, etc.
Here's how to check the availability of a domain name:

    res = opensrs.lookup_domain('example.com')
    p res.success?
    p res.result['status']

    true
    taken

Each method returns an OpenSRSResponse object which you can
use to determine if the call was successful and retrieve the response code
and/or error message. The result variable is a hash that contains all of the
relevant data returned by the call.

Note on Patches/Pull Requests
=======

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
=========

Copyright (c) 2011 Site5 LLC. See LICENSE for details.
