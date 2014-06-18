require 'open-uri'
require 'json'
require 'terminal-table'
require 'colorize'

module WorldCup

  class Results

    SFG_ENDPOINT = 'http://worldcup.sfg.io/matches'

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
      select_matches
      compose_table
      puts @table
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

    def parse_match_status(status)
      case status
      when 'future'; 'Upcoming'
      when 'completed'; 'Final'
      when 'in progress'; 'Live'
      else; status
      end
    end

    def format_row(row)
      case row[6].downcase
      when 'live'
        row.map { |rr| rr.to_s.colorize(:white).bold }
      when 'final'
        if row[3] > row[4]
          row.map.with_index { |rr, i|
            i == 2 || i == 3 ? rr.to_s.colorize(:green) : rr }
        elsif row[4] > row[3]
          row.map.with_index { |rr, i|
            i == 4 || i == 5 ? rr.to_s.colorize(:green) : rr }
        else
          row
        end
      else
        row.map { |rr| rr.to_s }
      end
    end

    def select_matches

      return if @opts[:day_delta].nil?
      @rows.keep_if { |r| Date.parse(r['datetime']) == Date.today + @opts[:day_delta].to_i }
    end

    def compose_table
      rows = @rows.sort_by {|r| r['datetime'].to_s }.map do |r|
        [
          r['match_number'],
          DateTime.parse(r['datetime']).strftime('%a %b %-d %H:%M'),
          (r['away_team'].is_a?(Array) ? 'TBD' : r['away_team']['country']),
          (r['away_team'].is_a?(Array) ? '' : r['away_team']['goals']),
          (r['home_team'].is_a?(Array) ? '' : r['home_team']['goals']),
          (r['home_team'].is_a?(Array) ? 'TBD' : r['home_team']['country']),
          parse_match_status(r['status']),
          r['location']
        ]
      end
      rows = rows.map { |r| format_row(r) }
      @table = Terminal::Table.new(
        headings: ['Match', 'Date', 'Away', '', '', 'Home', 'Status', 'Location'],
        rows: rows)
      @table.align_column(2, :right)
    end

  end


end