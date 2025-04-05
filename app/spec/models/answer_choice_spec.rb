require 'rails_helper'

RSpec.describe AnswerChoice, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:choice_text) }
end
