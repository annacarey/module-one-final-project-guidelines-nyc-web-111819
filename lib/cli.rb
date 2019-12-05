class CLI 

require 'colorize'
require 'colorized_string'

PROMPT = TTY::Prompt.new

@@user = nil

# Runs the program via the welcome method invocation
def run
    music
    welcome
end

# Welcome is a method that creates the functionality of logging in or creating a new user and running the application
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
     stop_music
    options
    
end

# Allows the User to Sign up or Login via the helper methods being invoked
    def new_user
        puts "🎶 " " 🤩  " "Welcome To Music Source!" "  🤩 " " 🎶".colorize(:yellow)
        choice = PROMPT.select("Your Source For The 🔥 Hottest🔥 Music Events!".colorize(:yellow)) do |option|
            option.choice "Login", 1 
            option.choice "Sign Up", 2
        end 
        if choice == 1
            login
        elsif choice == 2 
            signup
        end
    end

# Helper method that asks the User to sign up with a username and creates a new user instance
    def signup
        username = PROMPT.ask("Please Create A Username:".colorize(:yellow), required: true)
        @@user = create_user(username)
        @@user.reload
    end

    # Helper method that takes in a username and checks to see if the username exists and if it does it tells you the 
    # username is not available and redirects the user to create a new username
    # if it does not exist it creates a new user with that username
    def create_user(username)
        existing_user = User.all.select do |user|
            user.name == username
        end 
        if existing_user != []
            puts "Sorry, That Username Is Not Available!  😅".colorize(:red)
            signup
        else 
            new_user = User.create(name: "#{username}")
            puts "Congrats, You Just Created A New Account!  🥳"
        end
        new_user
    end

# Login checks to see if the username you're typing exists if it does, User is logged in
# otherwise it tells you it was not found
# then it redirects the User to the login/signup screen 
def login
    username = PROMPT.ask("Welcome Back!😄  What's Your Username?🤔 " "🧐".colorize(:yellow), required: true)
        user = User.find_by(name: username)
        if user 
            @@user = user
        else
            PROMPT.error("Sorry Username Not Found! 🤬 🤬")
            puts "\n"
            new_user
        end
end

def logout
    new_user
end

# Just a menu of options that the user can choose from
def options
    puts "\n"
    selection = PROMPT.select("Hello #{@@user.name}, What Would You Like To Do?") do |option|
        option.choice "Find An Event By Artist 🔍".colorize(:yellow), 1   
        option.choice "Show My Events 🎊".colorize(:light_blue), 2
        option.choice "Delete An Event 💀".colorize(:red), 3
        option.choice "Delete My Account 💀".colorize(:magenta), 4
        option.choice "Manage My Profile 👤".colorize(:light_green), 5
        option.choice "Logout", 6
        option.choice "Exit", 7
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
        puts "Your Event Was Succesfully Deleted!".colorize(:red)
        go_back
    elsif 
        selection == 4 
        delete_myself 
        new_user
    elsif
        selection == 5
        update_username
        go_back
    elsif
        selection == 6
        logout
        go_back
    else
        sleep (1)
            puts "\n"
            puts "See You Later #{@@user.name}! " " 😄".colorize(:light_green)

        puts " ██████╗  ██████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███████╗██╗       ██╗ 
██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔════╝██║    ██╗╚██╗
██║  ███╗██║   ██║██║   ██║██║  ██║██████╔╝ ╚████╔╝ █████╗  ██║    ╚═╝ ██║
██║   ██║██║   ██║██║   ██║██║  ██║██╔══██╗  ╚██╔╝  ██╔══╝  ╚═╝    ██╗ ██║
╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝██████╔╝   ██║   ███████╗██╗    ╚═╝██╔╝
 ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝       ╚═╝ 
                                                                          "





            exit
    end
end 

# Takes in the User input to search for an artist
def artist_prompt
    puts "Input Your Favorite Artist:".colorize(:yellow)
    user_input = gets.chomp 
end

def get_artist_event_hash(artist)
    #get artist id
    # get_user_id(artist_prompt)
    
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

    # #map through and get array of display name for event
    # event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
    # end 
    events_hash["resultsPage"]["results"]["event"]
end

# # Get Artist_ID
# def get_artist_id(user_input)
#     artist_string = RestClient.get("https://api.songkick.com/api/3.0/search/artists.json?apikey=io09K9l3ebJxmxe2&query=#{user_input}")
#     JSON.parse(artist_string)
# end 

#     #check if the API could not return results for the artist
#     if events_hash["resultsPage"]["results"] == {} 
#         puts "Sorry, your artist is not on tour!".colorize(:red)
#         PROMPT.select("Would you like to go back?", ["yes"])
#         go_back  
#     end 
#     events_hash["resultsPage"]["results"]["event"]
# end

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

# Displays a list of concerts for the artist you chose, allows the User to pick one
# if the the concert has already been picked,it will give you an error message
# and allow you to go back and pick a new concert 
# if the concert hasnt been picked, it creates a new event object/instance attached to that concert
def choose_concert(event_list)
    selection = PROMPT.select("Choose Your Concert?".colorize(:light_green), event_list)
    existing_concert = @@user.concerts.all.select do |concert|
        concert.name == selection
    end 
    if existing_concert != []
        puts "You Have Already Added That Concert!".colorize(:red)
        puts "\n"
        choose_concert(event_list)
    else 
        selection 
    end 
   
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
end 

def show_my_events
    @@user.reload
    puts "\n"
    if @@user.events.length == 0 
        puts "You have no events!".colorize(:red)
        puts "\n"
        PROMPT.select("Would You Like To Go Back?", ["Yes"])
        go_back  
    else 
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
        choice = PROMPT.select("Would You Like To Go Back?".colorize(:light_green), ["Yes"])
        if choice == "Yes"
            go_back
        end
    end 
end 

def concert_names
    @@user.reload.concerts.map do |concert|
        concert.name
    end 
end

# Helper method that provides an array of event names in the form strings
def event_names 
    @@user.reload
    @@user.events.map do |event|
        event.name 
    end 
end 

# Helper method that gives you a list of events to chose from 
# uses the string to find the event and then stores it
def select_events
    event_name = PROMPT.multi_select("Which Event Are You Looking For?".colorize(:red), event_names)
    event_name.map do |event_name|
        Event.find_by(name: "#{event_name}")
    end
end   

# It's for us, it has no purpose in the application :)
def destroy_all_users
    User.all.each do |user|
        user.destroy 
    end 
end 

# The method for the user to delete thier profile
def delete_myself
    @@user.destroy
end 

# Checks to see if the User has any events if they don't, you get a message telling you so
# if the User does have any events the User can delete them, one at a time
def delete_event
    puts "\n"
    if @@user.events.length == 0 
        puts "#{@@user.name} Has No Events!".colorize(:red)
        puts "\n"
        PROMPT.select("Would You Like To Go Back?", ["Yes"])
        go_back  
    end
    puts "Here Are #{@@user.name}'s Events!".colorize(:light_green)
    my_events = select_events
    my_events.each do |event|
        event.destroy
    end
    @@user.reload
    puts "Event(s) Succesfully Deleted!".colorize(:red)
    puts "\n"
    PROMPT.select("Would You Like To Go Back?", ["Yes"])
    go_back  
end



# Welcomes the User to their profile, prompts them to see if they would like to change their username
# if so, they can and it will be saved. If not they can be redirected to the main menu
def update_username
    puts "\n"
    puts "Welcome To Your Profile #{@@user.name}!".colorize(:magenta)
    var = PROMPT.select("Would You Like To Change Your Username?".colorize(:magenta), ["Yes"], ["No"])
    if var == "Yes"
        puts "What Would You Like Your New Username To Be?".colorize(:magenta)
        input = gets.chomp
        @@user.update(name: "#{input}")
    elsif
        var == "No"
        puts "Alright!".colorize(:magenta)
        go_back
    end
end

# Helper method that brings the User back to the main menu, helps keep things DRY!!
def go_back
    sleep(1)
    options
end

#Plays music 
def music
        fork{ exec 'killall', "afplay" }
        sleep(0.5)
        fork{ exec 'afplay', "/Users/seaneriksen/Development/code/module-one-final-project-guidelines-nyc-web-111819/lib/music/Kanye_West_feat._Rihanna_Kid_Cudi_Fergie_Alicia_Keys_Elton_John_John_Legend_The-D_-_All_(mp3.pm) (1).mp3" }
end
    


 #Stops the music
 def stop_music
     fork{ exec 'killall', "afplay" }
     sleep(1)
 end



# NO IDEA WHAT THIS IS/DOES
def self.user 
    @@user 
end 



# NO IDEA WHAT THIS IS/DOES
def self.user(input)
    @@user = input 
end 


end 