class PointHistorySerializer < ActiveModel::Serializer
  attributes :id, :operation_type, :amount, :total
end
