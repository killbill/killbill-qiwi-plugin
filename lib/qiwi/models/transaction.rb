module Killbill #:nodoc:
  module Qiwi #:nodoc:
    class QiwiTransaction < ::Killbill::Plugin::ActiveMerchant::ActiveRecord::Transaction

      self.table_name = 'qiwi_transactions'

      belongs_to :qiwi_response

    end
  end
end
