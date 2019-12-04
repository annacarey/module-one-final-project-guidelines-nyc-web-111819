class CLI 

require 'colorize'
require 'colorized_string'

PROMPT = TTY::Prompt.new

@@user = nil

#runs the program
def run
    welcome
end

#welcome is method that creates the funcrtionality of logging in or creating a new user and running the application
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

#Helper method that asks User to sign up with a username and creates a new user
    def signup
        username = PROMPT.ask("Please create a username:".colorize(:yellow), required: true)
        @@user = create_user(username)
        @@user.reload
    end

    #helper method that takes in a username and checks to see if the username exists and if it does it tells you the 
    #username is not available and redirects the user to create a new username
    #if it does not exist it creates a new user with that username
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

#login checks to see if the username you're typing exists if it does, user is logged in
#otherwise it tells you it was not found
#then it redirects the user to login or signup screen 
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

#Just a menu of options that the user can choose from
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
            puts "\n"
            puts "See you later #{@@user.name}! " " 😄".colorize(:light_green)

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

#takes in the user input to search for an artist
def artist_prompt
    puts "Input your favorite artist:".colorize(:yellow)
    user_input = gets.chomp 
end

#takes in the users string as an argument and checks that in the API to get SongKicks artist id.
#if the artist does not exist in the API, sends an error and redirects you to the main menu
#it takes artist id to make an API call and returns a list of concerts on SongKick belonging to that artist
#if Songkick has no concerts for that artist it returns an error and redirects to the main menu
#uses this list of concerts to create an array of concert names
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

    #API call to get the event hash from artist id
    events_string = RestClient.get("https://api.songkick.com/api/3.0/artists/#{artist_id}/calendar.json?apikey=io09K9l3ebJxmxe2
     ")
    events_hash = JSON.parse(events_string)

    #check if the API could not return results for the artist
    if events_hash["resultsPage"]["results"] == {} 
        puts "Sorry, your artist is not on tour!".colorize(:red)
        PROMPT.select("Would you like to go back?", ["yes"])
        go_back  
    end 
         
    #map through and get array of display name for concert
    event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
        event["displayName"]
    end 
end

#display a list of concerts for the artist you chose, allows the user to pick one
#if the the concert has already been picked then it will give an error
#and allow you to pick a new concert, if the concert hasnt been picked, it creates a new event object attached to that concert
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
        new_concert = Concert.create(name: "#{selection}")
        new_event = Event.create(user_id: "#{@@user.id}", concert_id: "#{new_concert.id}", name: "#{selection}")
    end 
end 

#A menu of all the events the user has chosen in the form of strings
#if the user has ne events they will get a message telling them they don't have any events
def show_my_events
    @@user.reload
     puts "\n"
     if @@user.events.length == 0 
        puts "You have no events!".colorize(:red)
     else
        puts "Here are your all your Events!".colorize(:light_green)
        event_names.each do |event_name|
            puts event_name
        end
    end 
    puts "\n"
    choice = PROMPT.select("Would you like to go back?".colorize(:light_green), ["yes"])
    if choice == "yes"
        go_back
    end
end 

#helper method that provides an array of event names in the form strings
def event_names 
    @@user.reload
    @@user.events.map do |event|
        event.name 
    end 
end 

#helper method that gives you a list of events to chose from 
#uses the string to find the event and then stores it
def select_event
    event_name = PROMPT.select("Which event are you looking for?".colorize(:red), event_names)
    Event.find_by(name: "#{event_name}")
end

#It's for us
def destroy_all_users
    User.all.each do |user|
        user.destroy 
    end 
end 

#Is the method for the user to delete thier profile
def delete_myself
    @@user.destroy
end 

#checks to see if the user has any events if they don't, you get a message telling you so.
#if the user has any events if so, the user can delete them, one at a time.
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


#Welcomes the user to their profile, promots them to see if they would like to change their username
#if so, they can and it will be saved. if not they can be redirected to the main menu
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

#helper method that bring the user back to the menu, helps keep things DRY
def go_back
    sleep(1)
    options
end


def self.user 
    @@user 
end 

def self.user(input)
    @@user = input 
end 


end 