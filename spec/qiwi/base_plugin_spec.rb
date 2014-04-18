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

      @plugin = Killbill::Qiwi::PaymentPlugin.new
      @plugin.logger = Logger.new(STDOUT)
      @plugin.logger.level = Logger::INFO
      @plugin.conf_dir = File.dirname(file)

      # Start the plugin here - since the config file will be deleted
      @plugin.start_plugin
    end
  end

  it 'should start and stop correctly' do
    @plugin.stop_plugin
  end
end
