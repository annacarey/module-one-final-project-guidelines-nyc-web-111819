class CLI 

require 'colorize'
require 'colorized_string'

PROMPT = TTY::Prompt.new

@@user = nil
@@concert_name = nil

def self.user 
    @@user 
end 

def self.user(input)
    @@user = input 
end 

def run
    welcome
end

#welcome
def welcome
    new_user
    options
    get_artist_events
end

#Allows user to Sign up or Login
    def new_user
        puts "🎶 " " 🤩  " "Welcome to Music Source!" "  🤩 " " 🎶".colorize(:yellow)
        choice = PROMPT.select("Your source for the 🔥 hottest🔥 music events!".colorize(:yellow)) do |option|
            option.choice "Login", 1 
            option.choice "Sign up", 2
        end 
        if choice == 1
            login
        elsif choice == 2 
            signup
        end
    end

#Helper method that asks User to sign up
    def signup
        username = PROMPT.ask("Please create a username:".colorize(:yellow), required: true)
        @@user = create_user(username)
    end

    def create_user(username)
        existing_user = User.all.select do |user|
            user.name == username
        end 
        if existing_user != []
            puts "That username is not available."
            signup
        else 
            User.create(name: "#{username}")
            puts "You just created a new account!"
        end
    end

# User login
def login
    username = PROMPT.ask("Welcome Back!😄  What's your Username?🤔 " "🧐".colorize(:yellow), required: true)
        user = User.find_by(name: username)
        if user 
            @@user = user
        else
            PROMPT.error("Sorry Username Not Found! 🤬 🤬")
            new_user
        end
end

def options 
    selection = PROMPT.select("Hello #{@@user.name}, What would you like to do?") do |option|
        option.choice "Find an event by Artist".colorize(:yellow), 1
        option.choice "Show my Events".colorize(:light_blue), 2
        option.choice "Delete an Event".colorize(:red), 3
        option.choice "Delete my Account".colorize(:magenta), 4
        option.choice "Manage my Profile".colorize(:light_green), 5
        option.choice "Exit", 6
    end 
    if selection == 1 
        artist = artist_prompt
        event_list = get_artist_events(artist)
        choose_concert(event_list)
        puts "You just saved an event!".colorize(:light_blue)
        go_back
    elsif 
        selection == 2
        show_my_events 
        sleep(3)
        go_back
    elsif 
        selection == 3 
        delete_event
        puts "Your event was succesfully deleted!".colorize(:red)
        go_back
    elsif 
        selection == 4 
        delete_myself 
        exit
    elsif
        selection == 5
        update_username
        go_back

    else
        sleep (1)
            puts "Goodbye! " " 😄".colorize(:light_green)
            exit
    end
end 

def artist_prompt
    puts "Input your favorite artist:".colorize(:yellow)
    user_input = gets.chomp 
end

def get_artist_events(artist)
    #get artist id
    artist_string = RestClient.get("https://api.songkick.com/api/3.0/search/artists.json?apikey=io09K9l3ebJxmxe2&query=#{artist}")
    artist_hash = JSON.parse(artist_string)

     #check if the api could not find an artist by name
    if artist_hash["resultsPage"]["results"] == {} 
        puts "Sorry this artist name is not in our system.".colorize(:red)
        PROMPT.select("Would you like to go back?", ["yes"])
        go_back  
    end 
    artist_id = artist_hash["resultsPage"]["results"]["artist"][0]["id"]

    #look at Songkick and find list of events in a timeframe we set with that particular artist
    events_string = RestClient.get("https://api.songkick.com/api/3.0/artists/#{artist_id}/calendar.json?apikey=io09K9l3ebJxmxe2
     ")
    events_hash = JSON.parse(events_string)

    #check if the API could not return results for the artist
    if events_hash["resultsPage"]["results"] == {} 
        puts "Sorry, your artist is not on tour!".colorize(:red)
        PROMPT.select("Would you like to go back?", ["yes"])
        go_back  
    end 
         
    #map through and get array of display name for event
    event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
        event["displayName"]
    end 
end

def choose_concert(event_list)
    selection = PROMPT.select("Choose your concert?".colorize(:light_green), event_list)
    existing_concert = @@user.concerts.all.select do |concert|
        concert.name == selection
    end 
    if existing_concert != []
        puts "You have already added that concert!".colorize(:red)
        choose_concert(event_list)
    else 
        new_concert = Concert.create(name: "#{selection}")
        new_event = Event.create(user_id: "#{@@user.id}", concert_id: "#{new_concert.id}", name: "#{selection}")
    end 
end 

def show_my_events 
    puts "Here are your all your Events!".colorize(:light_green)
    event_names.each do |event_name|
        puts event_name
    end 
    choice = PROMPT.select("Would you like to go back?".colorize(:light_green), ["yes"])
    if choice == "yes"
        go_back
    end
end 

def concert_names
    @@user.reload.concerts.map do |concert|
        concert.name
    end 
end

def event_names 
    @@user.reload
    @@user.events.map do |event|
        event.name 
    end 
end 

def select_event
    event_name = PROMPT.select("Which event are you looking for?".colorize(:red), event_names)
    Event.find_by(name: "#{event_name}")
end

def destroy_all_users
    User.all.each do |user|
        user.destroy 
    end 
end 

def delete_myself
    @@user.destroy
end 

def delete_event
    if @@user.events.length == 0 
        puts "#{@@user.name} has no events!"
        PROMPT.select("Would you like to go back?", ["yes"])
        go_back  
    end
    puts "Here are #{@@user.name}'s events!".colorize(:light_green)
    my_event = select_event
    my_event.destroy
    @@user.reload
    puts "Event Succesfully Deleted!".colorize(:red)
    PROMPT.select("Would you like to go back?", ["yes"])
    go_back  
end

def update_username
    puts "Welcome to your profile #{@@user.name}!".colorize(:magenta)
    var = PROMPT.select("Would you like to change your Username?".colorize(:magenta), ["yes"], ["no"])
    if var == "yes"
        puts "What would you like your new Username to be?".colorize(:magenta)
        input = gets.chomp
        @@user.update(name: "#{input}")
    elsif
        var == "no"
        puts "Alright!"
        go_back
    end
end

def go_back
    sleep(1)
    options
end

end 