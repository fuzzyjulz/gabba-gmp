require 'spec_helper'

describe GabbaGMP::GabbaGMP::Campaign do
  describe "#present?" do
    let(:campaign) { GabbaGMP::GabbaGMP::Campaign.new}
    before do
      campaign.name = "Campaign"
      campaign.source = "Source"
      campaign.medium = "Medium"
      campaign.keyword = "Keyword"
      campaign.content = "Content"
    end
    
    it "has variables set" do
      expect(campaign.name).to eq("Campaign")
      expect(campaign.source).to eq("Source")
      expect(campaign.medium).to eq("Medium")
      expect(campaign.keyword).to eq("Keyword")
      expect(campaign.content).to eq("Content")
    end
    
    it "is present?" do
      expect(campaign.present?).to be(true)
    end
    
    it "is present? because of name" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.name = 'X'
      expect(campaign.present?).to be(true)
    end
    
    it "is present? because of source" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.source = 'X'
      expect(campaign.present?).to be(true)
    end
    
    it "is present? because of medium" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.medium = 'X'
      expect(campaign.present?).to be(true)
    end
    
    it "is present? because of keyword" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.keyword = 'X'
      expect(campaign.present?).to be(true)
    end
    
    it "is present? because of content" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.content = 'X'
      expect(campaign.present?).to be(true)
    end

    it "is not present?" do
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      expect(campaign.present?).to be(false)

      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.name = ''
      expect(campaign.present?).to be(false)

      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.source = ''
      expect(campaign.present?).to be(false)
      
      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.medium = ''
      expect(campaign.present?).to be(false)

      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.keyword = ''
      expect(campaign.present?).to be(false)

      campaign = GabbaGMP::GabbaGMP::Campaign.new
      campaign.content = ''
      expect(campaign.present?).to be(false)
    end
  end
end