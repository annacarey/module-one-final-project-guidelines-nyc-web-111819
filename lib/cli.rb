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

    puts"

        _                                                 
      ,´ `.                                               
______|___|______________________________________________
      |  /                       _..-´|                  
      | /                  _..-´´_..-´|                  
______|/__________________|_..-´´_____|__________|\______
     ,|                   |           |          | \     
    / |                   |           |          | ´     
___/__|___________________|___________|__________|_______
  / ,´| `.                |      ,d88b|          |       
 | .  |   \            __ |      88888|       __ |       
_|_|__|____|_________,d88b|______`Y88P'_____,d88b|_______
 |  ` |    |         88888|                 88888|       
 `.   |   /          `Y88P'                 `Y88P'       
___`._|_.´_______________________________________________
      |                                                  
    , |                                                
    '.´
"
    
        
puts "
███╗   ███╗██╗   ██╗███████╗██╗ ██████╗    ███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
████╗ ████║██║   ██║██╔════╝██║██╔════╝    ██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
██╔████╔██║██║   ██║███████╗██║██║         ███████╗██║   ██║██║   ██║██████╔╝██║     █████╗  
██║╚██╔╝██║██║   ██║╚════██║██║██║         ╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝  
██║ ╚═╝ ██║╚██████╔╝███████║██║╚██████╗    ███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗
╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝    ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
"
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
        @@user.reload
    end

    def create_user(username)
        existing_user = User.all.select do |user|
            user.name == username
        end 
        if existing_user != []
            puts "That username is not available."
            signup
        else 
            new_user = User.create(name: "#{username}")
            puts "You just created a new account!"
        end
        new_user
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
     puts "\n"
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
        events_array = get_artist_event_hash(artist)
        event_list = get_event_list(events_array)
        concert_choice = choose_concert(event_list)
        event_hash = get_event_hash_from_selection(events_array, concert_choice)
        create_new_event(concert_choice, event_hash)
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
            puts "\n"
            puts "Goodbye #{@@user.name}! " " 😄".colorize(:light_green)
            exit
    end
end 

def artist_prompt
    puts "Input your favorite artist:".colorize(:yellow)
    user_input = gets.chomp 
end

def get_artist_event_hash(artist)
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
    events_hash["resultsPage"]["results"]["event"]
end

def get_event_list(events_hash)
    events_hash.map do |event|
        event["displayName"]
    end
end 

#map through and get array of display name for event
def get_event_name_list(event_hash)
event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
    event["displayName"]
end
end 

#needs to return a string of the user's choosing
def choose_concert(event_list)
    puts "\n"
    selection = PROMPT.select("Choose your concert?".colorize(:light_green), event_list)
    existing_concert = @@user.concerts.all.select do |concert|
        concert.name == selection
    end 
    if existing_concert != []
        puts "You have already added that concert!".colorize(:red)
        choose_concert(event_list)
    else 
        selection 
    end 
    # binding.pry
end 

def get_event_hash_from_selection(events_array, concert_choice)
    events_array.find do |event|
        event["displayName"] == concert_choice 
    end 
end 

#create a new event using all of the variables 
def create_new_event(concert_choice, event_hash)
    new_concert = Concert.create(name: "#{concert_choice}")
    url = event_hash["uri"]
    date = event_hash["start"]["date"]
    city = event_hash["venue"]["metroArea"]["displayName"]
    venue = event_hash["venue"]["displayName"]
    new_event = Event.create(user_id: "#{@@user.id}", concert_id: "#{new_concert.id}", name: "#{concert_choice}", url: "#{url}", date: "#{date}", city: "#{city}", venue: "#{venue}")
    binding.pry
end 

def show_my_events
    puts "\n"
    selection = PROMPT.select("Here are your all your Events! Select the event for more info.".colorize(:light_green), event_names)
    selected_event = @@user.events.find_by(name: ("#{selection}"))
    puts "\n"
    puts selected_event.name.colorize(:magenta)
    if selected_event.date
        puts "Date: ".colorize(:magenta) + selected_event.date
    end 
    if selected_event.city
        puts "City: ".colorize(:magenta) + selected_event.city
    end 
    if selected_event.venue
        puts "Venue: ".colorize(:magenta) + selected_event.venue
    end 
    if selected_event.url
        puts "Event Link: ".colorize(:magenta) + selected_event.url
    end  
    puts "\n"
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
    puts "\n"
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
    puts "\n"
    puts "Welcome to your profile #{@@user.name}!".colorize(:magenta)
    var = PROMPT.select("Would you like to change your Username?".colorize(:magenta), ["yes"], ["no"])
    if var == "yes"
        puts "What would you like your new Username to be?".colorize(:magenta)
        input = gets.chomp
        @@user.update(name: "#{input}")
    elsif
        var == "no"
        puts "Alright!".colorize(:magenta)
        go_back
    end
end

def go_back
    sleep(1)
    options
end

end 