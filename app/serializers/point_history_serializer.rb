class PointHistorySerializer < ActiveModel::Serializer
  attributes :id, :operation_type, :amount, :total, :created_at, :updated_at
end
