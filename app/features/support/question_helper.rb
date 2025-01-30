module QuestionHelper
    def question
      @question ||= Question.find_by(template_text: 'A car starts with an initial velocity of \( u \) and accelerates at a constant rate \( a \) for a time \( t \). Calculate the final velocity, v, of the car.')
    end
end

  World(QuestionHelper)
