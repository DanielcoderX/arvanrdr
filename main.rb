#!/usr/bin/env ruby

# Required libraries
require 'json'
require 'net/http'
require 'io/console'

class ArvanCloud
  def initialize
    # Initialize ISP data, API endpoints, color codes, and terminal width
    @isp_data = get_isp_data
    @origin = 'https://radar.arvancloud.ir'
    @api_path = '/api/v1/internet-monitoring?isp='
    @radar_apps = get_apps
    @terminal_columns = IO.console.winsize[1]
  end

  # Read and parse ISP data from the JSON file
  def get_isp_data
    begin
      data = JSON.parse(File.read('arvan.json'))
      # Symbolize keys for easier access
      symbolized_data = data.map { |hash| { name: hash['name'], api: hash['api'] } }
      { isp_data: symbolized_data }
    rescue => e
      puts "Error reading or parsing JSON file: #{e.message}"
      { isp_data: [] }  # Return an empty array if there's an error
    end
  end

  # Define color codes for applications
  def get_apps
    {
      'playstation' => "\e[38;2;255;255;0m",  # Yellow
      'wikipedia' => "\e[38;2;128;0;128m",    # Purple
      'bing' => "\e[38;2;255;192;203m",        # Pink
      'google' => "\e[38;2;165;42;42m",         # Brown
      'github' => "\e[38;2;255;0;0m",           # Red
      'aparat' => "\e[38;2;255;255;255m",       # White
      'varzesh3' => "\e[38;2;0;0;255m",         # Blue
      'digikala' => "\e[38;2;0;128;0m",         # Green
      'end' => "\e[0m"
    }
  end

  # Create the API URL using ISP API endpoint
  def make_url(isp_api)
    "#{@origin}#{@api_path}#{isp_api}"
  end

  # Check if all ISP data is available
  def available_isp(isp_data)
    isp_data.values.all? { |value| value != nil }
  end

  # Print application names with their respective color codes
  def print_apps
    @radar_apps.each do |app, color|
      print "#{color}⬤ #{app} #{@radar_apps['end']}"
    end
    puts
    print_line_char('_')
  end

  # Print the time bar at the top of the output
  def print_time_bar
    time_space = 0
    times_list = []
    now = Time.now
    25.times do
      time_el = now - time_space * 60
      hour = time_el.strftime('%H').rjust(2, '0')
      minute = time_el.strftime('%M').rjust(2, '0')
      times_list.unshift("        #{hour}:#{minute} |")
      time_space += 15
    end

    time_line = times_list.join
    time_range = time_line.length - @terminal_columns
    puts time_line[time_range..]
    print_line_char('‾')
  end

  # Print a line of characters
  def print_line_char(one_char)
    @terminal_columns.times { print one_char }
    puts
  end

  # Generate the matrix for displaying ISP data
  def matrix_generator(column, resp)
    matrix = []
    max_col = 0

    column.times do |col|
      col_list = resp.map do |app, rate_list|
        if rate_list[col].nil? || rate_list[col] <= 0
          ' ' # Use empty space if the rate is nil or <= 0
        else
          "#{@radar_apps[app]}▐#{@radar_apps['end']}"
        end
      end

      col_list << ' ' if col_list.empty?

      max_col = col_list.length if col_list.length > max_col

      matrix << col_list
    end

    matrix.each do |col|
      col.concat(Array.new(max_col - col.length, ' ')) if col.length < max_col
    end

    matrix
  end

  # Fetch and display ISP data
  def fetch_and_display_isps
    unavailable_isps = []

    @isp_data[:isp_data].each do |isp|
      api_url = make_url(isp[:api])

      begin
        print "\nFetching data for ISP: #{isp[:name]}"
        uri = URI(api_url)
        response = Net::HTTP.get(uri)
        res = JSON.parse(response)

        if res.empty? || !available_isp(res)
          raise StandardError, 'Invalid or empty response'
        end

        puts ''
        print "Data Center(#{isp[:name]}) details:"
        matrix_col_len = 360
        matrix = matrix_generator(matrix_col_len, res)
        responsive = matrix.length - @terminal_columns

        matrix[0].length.downto(1) do |row|
          responsive.upto(matrix.length - 1) do |col|
            print matrix[col][row]
          end
          puts ''
        end

        @terminal_columns.times { print '‾' }
        puts ''
      rescue StandardError => e
        unless unavailable_isps.include?(isp[:name])
          center_message = "Data Center(#{isp[:name]}) is not currently available"
          separator = '-' * @terminal_columns
          puts ''
          puts separator
          puts center_message.center(@terminal_columns, ' ')
          puts separator
          unavailable_isps << isp[:name]
        end
      end
    end
  end
end

# Run the code when the script is executed
if $PROGRAM_NAME == __FILE__
  arvan = ArvanCloud.new
  arvan.print_apps
  arvan.print_time_bar
  arvan.fetch_and_display_isps
end
