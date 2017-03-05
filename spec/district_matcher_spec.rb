require "spec_helper"
require_relative "../district_matcher"
require_relative "../schools_api"

describe DistrictMatcher do
  it "processes a school's stats" do
    district_matcher = DistrictMatcher.new
    target_district_stats = district_matcher.get_target_district_stats

    expect(target_district_stats[:es][:avg_students]).to eq(256)
    expect(target_district_stats[:es][:avg_scores]).to   eq(1058)
    expect(target_district_stats[:ms][:avg_students]).to eq(790)
    expect(target_district_stats[:ms][:avg_scores]).to   eq(875)
    expect(target_district_stats[:hs][:avg_students]).to eq(778)
    expect(target_district_stats[:hs][:avg_scores]).to   eq(1141)
  end

  it "processes a district's stats" do
    district_matcher = DistrictMatcher.new
    all_districts = district_matcher.get_districts_selections_stats

    expect(all_districts.first[:name]).to eq("Goyette District")
  end

  it "compares similarities for target and district selections" do
    district_matcher = DistrictMatcher.new
    target_district_stats = district_matcher.get_target_district_stats
    all_districts = district_matcher.get_districts_selections_stats

    possible_matches = district_matcher.compare_selections_to_target(target_district_stats, all_districts)
    expect(possible_matches).to eq("foo")
  end
end