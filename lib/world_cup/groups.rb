require 'open-uri'
require 'json'
require 'terminal-table'
require 'colorize'

module WorldCup

  class Groups

    SFG_ENDPOINT = 'http://worldcup.sfg.io/group_results'

    attr_reader :raw_response, :response, :table

    def initialize(opts={})
      @opts = opts
      @raw_response = nil
      @response = nil
      @rows = nil
      @table = nil
    end

    def render
      unless retrieve
        puts "Sorry, #{SFG_ENDPOINT} could not be reached. Please check your internet connection and try again."
        return
      end
      unless convert
        puts "Sorry, the response at #{SFG_ENDPOINT} could not be interpreted. Please try again."
        return
      end
      select_groups
      compose_table
    end

  protected

    def retrieve
      @raw_response = open(SFG_ENDPOINT).read
      true
    rescue StandardError
      false
    end

    def convert
      @response = JSON.parse(@raw_response)
      @rows = @response
      true
    rescue JSON::JSONError
      false
    end

    def select_groups
      @groups = @rows.group_by {|r| r["group_id"]}
    end

    def compose_table
      @groups.each do |g|
        generate_group_table(g)
      end
    end

    def generate_group_table(group)
      teams = group[1]
      rows = []
      teams.each do |t|
        rows << [
          '',
          t["country"],
          calculate_points(t["wins"],t["draws"]),
          t["wins"],
          t["draws"],
          t["losses"],
          t["goals_for"],
          t["goals_against"],
        ]
      end
      @table = Terminal::Table.new(
        headings: ["#{group.first}",'Country','Points', 'Wins', 'Draws', 'Losses', 'Goals_for', 'Goals_Against'],
        rows: rows)
      puts @table
    end

    def calculate_points(w,d)
      points = (3 * w) + (d)
    end
  end
end