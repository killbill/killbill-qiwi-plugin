module Killbill #:nodoc:
  module Qiwi #:nodoc:
    class QiwiResponse < ::Killbill::Plugin::ActiveMerchant::ActiveRecord::Response

      self.table_name = 'qiwi_responses'

      has_one :qiwi_transaction

      def self.from_response(api_call, kb_payment_id, response, extra_params = {})
        super(api_call,
              kb_payment_id,
              response,
              {
                  # Pass custom key/values here
                  #:params_id => extract(response, 'id'),
                  #:params_card_id => extract(response, 'card', 'id')
              }.merge!(extra_params),
              ::Killbill::Qiwi::QiwiResponse)
      end
    end
  end
end
