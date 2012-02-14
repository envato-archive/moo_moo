require 'spec_helper'

describe MooMoo::BulkChanges do
  it { should have_registered_service(:bulk_transfer, :domain) }
  it { should have_registered_service(:submit, :bulk_change) }
  it { should have_registered_service(:submit_bulk_change, :bulk_change) }
end