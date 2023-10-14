class ParserController < ApplicationController
    skip_before_action :verify_authenticity_token

    def home
    end

    def create
        uploaded_file = params[:file]
        if uploaded_file 
            file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)
            File.open(file_path, 'wb') do |file| #make temporary copy of the file
                file.write(uploaded_file.read)
            end
            Result.clear
            @parsed_results = Result.parse?(file_path)
            render 'parsed' #renders the parsed view, with the parsed_results
        else
            redirect_to root_path, alert: 'Please select a file to upload!'
        end
    end  


end

class Result 
    @@result_count = 0 #used as key in the results hash table
    @@results_hash = Hash.new
    def self.results #accessor method that returns the class variable
        @@results_hash 
    end

    def self.clear #used to reset hash table for new files
        @@results_hash = Hash.new
        @@result_count = 0
    end 

    def self.parse?(file) #takes file input, checks if it exists/has content, then extracts relevant content as a new object per lab result
        begin
            exp_arr = File.read(file).split("OBX\|") #divide file into array of individual results
            exp_arr.shift #remove first array element (blank as file always starts with the OBX| delimiter)
            exp_arr.each do |line| #iterate through each experiment
                line_arr = line.delete("\n").split("|") #remove all original newline chars and split experiment into subfields
                line_code, line_value, line_comments = line_arr[1], line_arr[2], line_arr[3..-1] #ignoring the index field, capturing the exp code, value and unknown number of comments
                Result.new(line_code, line_value, line_comments) #initialising a new Result object with the extracted values, further processing in the initialise func
            end 
            Result.results #return the class hash table when Result.parse is called
            return Result.results
        rescue Errno::ENOENT => e
            puts "File couldn't be found : \n #{e.message}" #prevent program failure for empty/missing files
            return false
        end
    end

    attr_accessor :code, :value, :format, :comments
    def initialize(code, value, comments_arr)
        @code = code
        @value = value
        if assess_type? #format the values 
            @comments = parse_comments(comments_arr)
            @@results_hash[@@result_count] = [@code, @value, @format, @comments]
            @@result_count += 1
        else 
            p "Failed to create object with unrecognisable code: #{code} and value: #{value}"
        end
    end

    def assess_type?() #reads codes and formats values accordingly, returns true if successful, or false if code not recognised
        case @code 
        when "C100", "C200"
            @value = @value.to_f
            @format = "float"
        when "A250"
            @value = (@value == "NEGATIVE") ? -1.0 :  -2.0
            @format = "boolean"
        when "B250"
            if @value == "NIL"
                @value = -1.0
            elsif @value == "+" || @value == "++"
                @value = -2.0
            else 
                @value = -3.0
            end
            @format = "nil_3plus"
        else 
            return false
        end
        true
    end

    def parse_comments(comments_arr) #ignores the 'NTE' and index fields from comments array, and outputs a string of combined comments separated by \n chars
        comments_formatted = String.new
        comments_arr.length.times do |count|
            if (((count+1) % 3) == 0) 
                (comments_formatted.empty?) ? (comments_formatted = comments_arr[count]) : (comments_formatted.concat("\n#{comments_arr[count]}")) #for first : subsequent comments 
            else ;
                next #ignore NTE and index
            end
        end
        comments_formatted #returns the string
    end
end

