require 'spec_helper'

describe Killbill::Qiwi::PaymentPlugin do
  before(:each) do
    Dir.mktmpdir do |dir|
      file = File.new(File.join(dir, 'qiwi.yml'), "w+")
      file.write(<<-eos)
:qiwi:
  :test: true
# As defined by spec_helper.rb
:database:
  :adapter: 'sqlite3'
  :database: 'test.db'
      eos
      file.close

      @plugin              = Killbill::Qiwi::PaymentPlugin.new
      @plugin.logger       = Logger.new(STDOUT)
      @plugin.logger.level = Logger::INFO
      @plugin.conf_dir     = File.dirname(file)
      @plugin.kb_apis      = Killbill::Plugin::KillbillApi.new('qiwi', {})

      # Start the plugin here - since the config file will be deleted
      @plugin.start_plugin
    end
  end

  it 'should start and stop correctly' do
    @plugin.stop_plugin
  end

  it 'should generate forms correctly' do
    kb_account_id = SecureRandom.uuid
    kb_tenant_id  = SecureRandom.uuid
    context       = @plugin.kb_apis.create_context(kb_tenant_id)
    fields        = @plugin.hash_to_properties({
                                                   :order_id   => '1234',
                                                   :account_id => '849384',
                                                   :amount     => 10
                                               })
    form          = @plugin.build_form_descriptor kb_account_id, fields, [], context

    form.kb_account_id.should == kb_account_id
    form.form_method.should == 'GET'
    form.form_url.should == 'https://w.qiwi.ru/payments.action'

    form_fields = @plugin.properties_to_hash(form.form_fields)
    form_fields.size.should == 3
    form_fields[:id].should == '1234'
    form_fields[:account].should == '849384'
    form_fields[:amount].should == '10'
  end

  it 'should receive notifications correctly' do
    transaction_id = '9943820274192'
    transaction_date = '20140427074818'
    account_id     = 98321
    response_code  = 0
    description    = 'description'
    gross = 500

    kb_tenant_id = SecureRandom.uuid
    context      = @plugin.kb_apis.create_context(kb_tenant_id)
    properties   = @plugin.hash_to_properties({ :description => description })

    notification    = "command=check&txn_id=#{transaction_id}&account=#{account_id}"
    gw_notification = @plugin.process_notification notification, properties, context
    gw_notification.entity.should == <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<response>
  <osmp_txn_id>#{transaction_id}</osmp_txn_id>
  <prv_txn>#{account_id}</prv_txn>
  <sum></sum>
  <result>#{response_code}</result>
  <comment>#{description}</comment>
</response>
    eos

    notification    = "command=pay&txn_id=#{transaction_id}&txn_date=#{transaction_date}&account=#{account_id}&sum=#{gross}"
    gw_notification = @plugin.process_notification notification, properties, context
    gw_notification.entity.should == <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<response>
  <osmp_txn_id>#{transaction_id}</osmp_txn_id>
  <prv_txn>#{account_id}</prv_txn>
  <sum>#{gross}</sum>
  <result>#{response_code}</result>
  <comment>#{description}</comment>
</response>
    eos
  end
end
