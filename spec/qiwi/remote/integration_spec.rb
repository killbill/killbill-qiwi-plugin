require 'spec_helper'

ActiveMerchant::Billing::Base.mode = :test

describe Killbill::Qiwi::PaymentPlugin do

  include ::Killbill::Plugin::ActiveMerchant::RSpec

  before(:each) do
    # Start the plugin early to configure ActiveRecord
    @plugin = build_plugin(::Killbill::Qiwi::PaymentPlugin, 'qiwi')
    @plugin.start_plugin
  end

  after(:each) do
    @plugin.stop_plugin
  end

  it 'should be able to create and retrieve payment methods' do
  end

  it 'should be able to charge and refund' do
  end
end
