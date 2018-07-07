class Types::UserError < Types::BaseObject
  description 'ユーザーに詳細を伝えるエラー'

  field :message, String, null: false, description: 'エラーの説明'
  field :path, [String], null: true, description: 'エラーの発生箇所'
end
