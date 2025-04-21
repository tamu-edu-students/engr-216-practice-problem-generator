class Question < ApplicationRecord
  belongs_to :topic
  belongs_to :type

  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions
  has_many :answer_choices, dependent: :destroy

  accepts_nested_attributes_for :answer_choices, allow_destroy: true, reject_if: ->(attrs) { attrs[:choice_text].blank? }

  validates :topic_id, :type_id, :template_text, presence: true
  validates :template_text, length: { minimum: 5 }

  validate :validate_equation_fields, if: -> { question_kind == "equation" && variables.present? && !multiple_choice? }

  validate :must_have_at_least_two_mc_choices, if: :mc_template?
  validate :exactly_one_correct_mc_answer,    if: :mc_template?

  validate :validate_dataset_generator_format, if: :dataset?

  validates :answer, presence: true, if: ->{question_kind == "definition"}

  def validate_dataset_generator_format
    return if dataset_generator.blank?

    pattern = /\A\s*
               (?<min>\d+(\.\d+)?)      # capture min
               \s*-\s*
               (?<max>\d+(\.\d+)?)      # capture max
               \s*,\s*
               size\s*=\s*
               (?<size>\d+)
               \s*\z/x

    m = dataset_generator.match(pattern)
    unless m
      return errors.add(
        :dataset_generator,
        "must be in format “min-max, size=n” (e.g. 1-25, size=10)"
      )
    end

    min, max, size = m[:min].to_f, m[:max].to_f, m[:size].to_i

    if max < min
      errors.add(
        :dataset_generator,
        "max (#{max}) must be greater than or equal to min (#{min})"
      )
    end

    if size < 1
      errors.add(
        :dataset_generator,
        "size (#{size}) must be at least 1"
      )
    end
  end

  def dataset?
    question_kind == "dataset"
  end

  def mc_template?
    multiple_choice? && (question_kind == "definition" || question_kind == "dataset")
  end

  def multiple_choice?
    type&.type_name == "Multiple choice"
  end

  private
  def validate_equation_fields
    validate_variable_names
    validate_variable_ranges
    validate_variable_decimals
    validate_round_decimals
  end

  def validate_variable_names
    if variables.blank? || variables.any?(&:blank?)
      errors.add(:variables, "must be present and non-empty.")
    else
      variables.each do |var|
        unless var.match?(/\A[A-Za-z]+\z/)
          errors.add(:variables, "must only contain letters and underscores.")
        end
      end
    end
  end

  def validate_variable_ranges
    return if multiple_choice?
    variable_ranges.each_with_index do |pair, idx|
      min, max = pair
      if max.to_f < min.to_f
        var_name = variables[idx] || "##{idx+1}"
        errors.add(
          :variable_ranges,
          "for '#{var_name}' must have max >= min (got #{min}…#{max})"
        )
      end
    end
  end

  def validate_variable_decimals
    return if multiple_choice?
    variable_decimals.each_with_index do |dec, idx|
      if dec.to_i < 0
        var_name = variables[idx] || "##{idx+1}"
        errors.add(
          :variable_decimals,
          "for '#{var_name}' must be >= 0 (got #{dec})"
        )
      end
    end
  end

  def validate_round_decimals
    return if multiple_choice?
    if round_decimals.present? && round_decimals.to_i < 0
      errors.add(:round_decimals, "must be >= 0 (got #{round_decimals.to_i})")
    end
  end

  def must_have_at_least_two_mc_choices
    count = answer_choices.reject(&:marked_for_destruction?).size
    if count < 2
      errors.add(:answer_choices, "must have at least two choices.")
    end
  end

  def exactly_one_correct_mc_answer
    correct_count = answer_choices.reject(&:marked_for_destruction?).count(&:correct)
    if correct_count != 1
      errors.add(:answer_choices, "must have exactly one correct answer.")
    end
  end
end
