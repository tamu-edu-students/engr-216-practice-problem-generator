
# @user = User.find_by(email: 'user@tamu.edu')

Then('my weakest topics with an accuracy of 60 or lower should be highlighted as weaknesses') do
    expect(page).to have_content("Weaknesses")

    @user.submissions_by_topic.each do |topic, stats|
      if stats[:accuracy] <= 60
        expect(page).to have_content(topic)
      end
    end
  end

  Then('my strongest topics with an accuracy of 85 or higher should be highlighted as strengths') do
    expect(page).to have_content("Strengths")

    @user.submissions_by_topic.each do |topic, stats|
      if stats[:accuracy] >= 85
        expect(page).to have_content(topic)
      end
    end
  end

Then('I will not have topics highlighted as weaknesses') do
    expect(page).to have_content("Weaknesses")
    expect(page).to have_content("No topics practiced with < 60% accuracy.")
end

Then('I will not have topics highlighted as strengths') do
    expect(page).to have_content("Strengths")
    expect(page).to have_content("No topics practiced with > 85% accuracy.")
end
