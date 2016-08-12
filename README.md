MooMoo [![MooMoo Build Status][Build Icon]][Build Status]
=========================================================

MooMoo is a Ruby library for working with the [OpenSRS XML Domain API][].

MooMoo has been tested with MRI versions 1.9.3, 2.0.0, 2.1.3 and JRuby 1.9 mode.

Documentation is available in [RDoc][] format.

[Build Status]: http://travis-ci.org/pressednet/moo_moo
[Build Icon]: https://secure.travis-ci.org/pressednet/moo_moo.png?branch=master
[OpenSRS XML Domain API]: https://opensrs.com/integration/api/
[RDoc]: http://rdoc.info/github/pressednet/moo_moo/master/frames

Description
-----------

Implements most of the functionality of the OpenSRS XML API. For full
documentation of the OpenSRS XML API see
<https://help.opensrs.com/hc/en-us/articles/203245883-OpenSRS-API>.

Usage
-----

First, create an opensrs object for the namespace you want to use:

```ruby
lookup = MooMoo::Lookup.new(
  host:     "horizon.opensrs.net",
  key:      "<YOUR_KEY>",
  username: "<YOUR_RESELLER_USER>"
)
```
Or configure MooMoo and you can initialize it without any arguments:

```ruby
MooMoo.configure do |config|
  config.host     = "horizon.opensrs.net"
  config.key      = "<YOUR_KEY>"
  config.username = "<YOUR_RESELLER_USER>"
end

...

lookup = MooMoo::Lookup.new
```

As an alternative, you can create a .moomoo.yml file in your project root with a default
configuration for the library to use.

Now you can call a variety of commands to deal with domains, nameservers, etc.
Here's how to check the availability of a domain name:

```ruby
lookup.api_lookup(:attributes => { :domain => 'example.com' })
p lookup.successful?

true
```

After calling the service method, you can use the following methods to access
the response:

```
response    - the http response
message     - the "response_text"
attributes  - the "attributes" hash with relevant data
successful? - whether the request was successful or not
```

Currently, there is support for the following services:

  * Cookie
  * Lookup
  * Nameserver
  * Provisioning
  * Transfer

API services are namespaced with api. For example, for the Lookup "get" API method,
it will be named `api_get`.

MooMoo provides custom methods that should make it easier to deal with the OpenSRS
API (e.g. Lookup `:domain_contacts`). These custom methods are not namespaced.
Check the documentation to see the parameters they expect and the responses
they return.

TLD List
--------

`MooMoo::Lookup` provides a `tlds` method that is used to list top level domains
that OpenSRS support. At this time, OpenSRS has no API method that does that,
so we keep that in a custom configuration file (`config/tlds.yml`).

The top level domains data comes from https://opensrs.com/services/domains/domain-pricing/.
OpenSRS also provides a CSV file for country code top level domains at
https://opensrs.com/images/elements/cctld-pricing.csv.

In order to generate our own `config/tlds.yml` file, we use the `scripts/parse_cctld_csv`
script to parse OpenSRS CSV file. In order to do that, place an updated `cctld-pricing.csv`
under `config`, and run `scripts/parse_cctld_csv`.

For non-country code top level domains, the `scripts/parse_cctld_csv` `defaults`
list needs to be updated.

Debugging
---------

If you need to debug requests and responses, you can set a logger object, and
MooMoo will `debug` the request/response XMLs. Make sure the log level is set to
`debug`.

```ruby
MooMoo.configure do |config|
  config.logger = my_logger
end
```

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile, version, or history. (if you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2016 Pressed, LLC. See LICENSE for details.
