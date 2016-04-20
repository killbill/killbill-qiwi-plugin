module Killbill #:nodoc:
  module Qiwi #:nodoc:
    class PrivatePaymentPlugin < ::Killbill::Plugin::ActiveMerchant::PrivatePaymentPlugin
      def initialize(session = {})
        super(:qiwi,
              ::Killbill::Qiwi::QiwiPaymentMethod,
              ::Killbill::Qiwi::QiwiTransaction,
              ::Killbill::Qiwi::QiwiResponse,
              session)
      end
    end
  end
end
