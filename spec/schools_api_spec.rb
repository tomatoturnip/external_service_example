require "spec_helper"
require "pp"
require "httparty"
require_relative "../schools_api"

describe SchoolsAPI do
  let(:schools_api) { SchoolsAPI.new }

  it "gets the target district" do
    target = schools_api.get_target_district

    expect(target["data"]["district"]["code"]).to eq("DS127T-K0")
  end

  it "gets district selections" do
    district_selections = schools_api.get_district_selections

    expect(district_selections["data"]["districts"].count).to eq(33)
  end
end