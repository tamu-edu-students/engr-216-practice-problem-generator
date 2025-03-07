require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#active_class" do
    it "returns 'active-link' when the current page matches the given path" do
      allow(helper).to receive(:current_page?).with('/home').and_return(true)
      expect(helper.active_class('/home')).to eq('active-link')
    end

    it "returns nil when the current page does not match the given path" do
      allow(helper).to receive(:current_page?).with('/home').and_return(false)
      expect(helper.active_class('/home')).to be_nil
    end
  end
end