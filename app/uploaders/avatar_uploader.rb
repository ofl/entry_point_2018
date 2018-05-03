class AvatarUploader < Shrine
  plugin :validation_helpers

  MAX_FILE_SIZE = Settings.uploaders.avatar.max_size * 1024 * 1024
  ALLOWED_MIME_TYPES = Settings.uploaders.avatar.allowed_mime_types

  Attacher.validate do
    validate_max_size MAX_FILE_SIZE, message: lambda { |max|
      I18n.t('shrine.errors.messages.max_size', max: max.to_f / 1024 / 1024)
    }
    validate_mime_type_inclusion ALLOWED_MIME_TYPES, message: lambda { |object|
      I18n.t('shrine.errors.messages.mime_type_inclusion', list: object.join(', '))
    }
  end
end
