class ErrorTypes::NotFound < ErrorTypes
  ERROR_CODE = 'NOT_FOUND'.freeze

  def initialize(error, error_code = ERROR_CODE)
    super
  end

  def message
    translate_record_not_found(@error.message)
  end

  private

  # https://qiita.com/arakaji/items/7a7c262f35b17195d3d7
  def translate_record_not_found(error_msg)
    match = error_msg.match(/^Couldn't find ([\S].*) with '([\S]*)'=([\S].*)$/)

    # モデル名を翻訳する
    t_model = I18n.t('activerecord.models.' + match[1].underscore)
    # 属性名を翻訳する
    t_attr = I18n.t('activerecord.attributes.' + match[1].underscore + '.' + match[2])

    I18n.t('graphql.errors.messages.not_found', klass: t_model, attribute: t_attr, value: match[3])
  end
end
