class TrainingSerializer < ApplicationSerializer
  attributes :id,
             :training_type,
             :training_date,
             :training_hours,
             :topic
  def training_type
    I18n.t("training.#{Training.types[object.training_type]}")
  end
end
