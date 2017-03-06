require_relative "./schools_api"
require "pp"

class DistrictMatcher
  attr_reader :target_school, :district_selections

  PERCENT_SIMILARITY = 80.0

  def initialize(api=SchoolsAPI.new)
    @target_school       = api.get_target_district
    @district_selections = api.get_district_selections
  end

  def get_target_district_stats
    schools_array = target_school["data"]["district"]["schools"]
    process_statistics(schools_array)
  end

  def get_districts_selections_stats
    all_districts = []
    districts_array = district_selections["data"]["districts"]

    districts_array.each do |district|
      all_districts << { code: district["code"], name: district["name"], stats: process_statistics(district["schools"]) }
    end

    all_districts
  end

  def compare_selections_to_target(target, selections)
    possible_matches = []

    selections.each do |selection|
      possible_matches << selection if calculate_percentage_similarity?(target, selection)
    end

    possible_matches
  end

  private

  def calculate_percentage_similarity?(target, selection)
    similar = []

    target.each_pair do |k,v|
      similar << find_lower_and_higher(target.send(k)[:avg_students], selection[:stats].send(k)[:avg_students])
      similar << find_lower_and_higher(target.send(k)[:avg_scores],   selection[:stats].send(k)[:avg_scores])
    end

    similar.all? { |x| x >= PERCENT_SIMILARITY }
  end

  def find_lower_and_higher(target, selection)
    lower = target <= selection ? target : selection
    upper = target > selection ? target : selection
    
    calculate_similarity(lower, upper)
  end

  def calculate_similarity(lower, upper)
    (lower.to_f / upper.to_f) * 100
  end

  def process_statistics(schools)
    school_types = OpenStruct.new(es: { students: [], scores: [] }, ms: { students: [], scores: [] }, hs: { students: [], scores: [] })

    schools.each do |school|
      case school["type"]
        when "ES"
          school_types.es[:students] << school["students"]
          school_types.es[:scores]   << school["score"]
        when "MS"
          school_types.ms[:students] << school["students"]
          school_types.ms[:scores]   << school["score"]
        when "HS"
          school_types.hs[:students] << school["students"]
          school_types.hs[:scores]   << school["score"]
      end
    end

    school_types.each_pair do |key, value|
      school_types.send(key)[:avg_students] = get_average(value[:students])
      school_types.send(key)[:avg_scores]   = get_average(value[:scores])
    end

    school_types
  end

  def get_average(stats)
    stats.inject(0) { |sum, x| sum + x } / stats.size
  end
end