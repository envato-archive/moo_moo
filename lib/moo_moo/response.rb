require 'hashie'

module MooMoo
  class Response < ::Hashie::Mash
    # Returns whether or not the command executed was successful
    #
    def success?
      self['is_success'].to_i == 1
    end
  end
end