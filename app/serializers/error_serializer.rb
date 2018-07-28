# https://github.com/Netflix/fast_jsonapi/issues/53

class ErrorSerializer
  def initialize(model, message, status, code)
    @model = model
    @message = message
    @status = status
    @code = code
  end

  def serialized_json
    validation_errors = @model.errors.messages.map do |field, errors|
      errors.map do |error_message|
        error_detail("/data/attributes/#{field}", error_message)
      end
    end

    # TODO: 関連のvalidationエラーを取得。has_oneや多重にネストした関連を考慮していないため実装が必要
    # @model.class.reflect_on_all_associations.each do |relationship|
    #   @model.send(relationship.name).each_with_index do |child, index|
    #     validation_errors << child.errors.messages.map do |field, errors|
    #       errors.map do |error_message|
    #         error_detail("/data/attributes/#{child.model_name.plural}[#{index}].#{field}", error_message)
    #       end
    #     end
    #   end
    # end
    validation_errors.flatten
  end

  def error_detail(pointer, detail)
    { title: @message, source: { pointer: pointer }, detail: detail, status: @status, code: @code }
  end
end
