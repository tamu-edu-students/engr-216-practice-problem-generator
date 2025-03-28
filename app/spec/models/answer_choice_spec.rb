require 'rails_helper'

RSpec.describe AnswerChoice, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:choice_text) }
  it { should validate_inclusion_of(:correct).in_array([true, false]) }
end
