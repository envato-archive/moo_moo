MooMoo [![MooMoo Build Status][Build Icon]][Build Status]
=========================================================

MooMoo is a Ruby library for working with the [Tucows OpenSRS XML API][].

MooMoo has been tested on MRI 1.8.7, MRI 1.9.2, MRI 1.9.3 Preview 1,
Rubinius 2.0.0pre, and JRuby 1.6.2.

Documentation is available in [RDoc][] format.

[Build Status]: http://travis-ci.org/site5/moo_moo
[Build Icon]: https://secure.travis-ci.org/site5/moo_moo.png?branch=master
[Tucows OpenSRS XML API]: http://www.opensrs.com/site/resources/documentation
[RDoc]: http://rdoc.info/github/site5/moo_moo/master/frames

Description
-----------

Implements most of the functionality of the OpenSRS XML API. For full
documentation of the OpenSRS XML API see
<http://www.opensrs.com/site/resources/documentation>

Usage
-----

First, create an opensrs object for the namespace you want to use:

    lookup = MooMoo::Lookup.new(
      "horizon.opensrs.net",
      "<YOUR_KEY>",
      "<YOUR_RESELLER_USER>",
      "<YOUR_PASSWORD>"
    )

Or configure MooMoo and you can initialize it without any arguments:

    MooMoo.configure do |config|
      config.host     = "horizon.opensrs.net"
      config.key      = "<YOUR_KEY>"
      config.username = "<YOUR_RESELLER_USER>"
      config.password = "<YOUR_PASSWORD>"
    end

    ...

    lookup = MooMoo::Lookup.new

As an alternative, you can create a .moomoo.yml file in your project root with a default
configuration for the library to use.

Now you can call a variety of commands to deal with domains, nameservers, etc.
Here's how to check the availability of a domain name:

    lookup.api_lookup(:attributes => { :domain => 'example.com' })
    p lookup.successful?

    true

After calling the service method, you can use the following methods to access
the response:

  response    - the http response
  message     - the "response_text"
  attributes  - the "attributes" hash with relevant data
  successful? - wheater the request was successful or not

Currently, there is support for the following services:

  * Cookie
  * Lookup
  * Nameserver
  * Provisioning
  * Transfer

API services are namespaced with api. For example, for the Lookup "get" api method,
it will be named "api_get".

MooMoo provides custom methods that should make it easier to deal with the OpenSRS
api (e.g. Lookup :domain_contacts). This custom methods are not namespaced.
Check their documentation to see what parameters does it expect and what responses
does it return.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2012 Site5.com. See LICENSE for details.
