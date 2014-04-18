module Killbill #:nodoc:
  module Qiwi #:nodoc:
    class QiwiPaymentMethod < ::Killbill::Plugin::ActiveMerchant::ActiveRecord::PaymentMethod

      self.table_name = 'qiwi_payment_methods'

      def external_payment_method_id
        qiwi_token
      end
    end
  end
end
