require 'active_support/concern'

module GraphqlSpecHelper
  extend ActiveSupport::Concern

  included do
    subject do
      EntryPoint2018Schema.execute(
        query, context: context, variables: variables, operation_name: operation_name
      ).with_indifferent_access
    end

    let(:context) { {} }
    let(:variables) { {} }
    let(:operation_name) { '' }

    let(:data) { subject['data'] }
    let(:errors) { subject['errors'] }
  end
end
