# Using TimexDatalinkClient with Protocol 7

This document describes how to use protocol 7 devices with this library by comparing code examples to the DSI e-BRAIN
software version 1.1.6.

![image](https://user-images.githubusercontent.com/820984/207302212-543abafa-2c6b-4cc7-a413-31f3d8567268.png)

## Nicknames

![image](https://user-images.githubusercontent.com/820984/207304059-cdb2bc30-19c3-4556-aaec-f2b20df3f58c.png)

```ruby
phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

computer_from_mars = phrase_builder.vocab_ids_for("Computer", "From", "Mars")
boards_of_canada = phrase_builder.vocab_ids_for("Boards", "Of", "Canada")

speech = TimexDatalinkClient::Protocol7::Eeprom::Speech.new(
  device_nickname: computer_from_mars,
  user_nickname: boards_of_canada
)

TimexDatalinkClient::Protocol7::Eeprom.new(speech: speech)
```

## Life Style Setup

![image](https://user-images.githubusercontent.com/820984/207306710-ec47ed40-e26c-44bd-a9ce-1b04a1219877.png)

```ruby
phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

get_up = phrase_builder.vocab_ids_for("Get", "Up")
really_do_it = phrase_builder.vocab_ids_for("Really", "Do", "It")
picture_day = phrase_builder.vocab_ids_for("Picture", "Day")

activities = [
  TimexDatalinkClient::Protocol7::Eeprom::Activity.new(
    time: Time.new(0, 1, 1, 7, 30, 0),  # Year, month, and day is ignored.
    messages: [get_up, really_do_it],
    random_speech: false
  ),
  TimexDatalinkClient::Protocol7::Eeprom::Activity.new(
    time: Time.new(0, 1, 1, 0, 30, 0),  # Year, month, and day is ignored.
    messages: [picture_day],
    random_speech: true
  )
]

TimexDatalinkClient::Protocol7::Eeprom.new(activities: activities)
```

## Games

![image](https://user-images.githubusercontent.com/820984/207318722-1a37c1ff-e511-45a1-8990-f257935b117b.png)

```ruby
phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

fart = phrase_builder.vocab_ids_for("<Fart>").first
bell = phrase_builder.vocab_ids_for("<Bell>").first

games = TimexDatalinkClient::Protocol7::Eeprom::Games.new(
  memory_game_enabled: true,
  fortune_teller_enabled: true,
  countdown_timer_enabled: true,
  countdown_timer_seconds: 90,
  countdown_timer_sound: fart,
  mind_reader_enabled: true,
  music_time_keeper_enabled: true,
  music_time_keeper_sound: bell,
  morse_code_practice_enabled: true,
  treasure_hunter_enabled: true,
  rhythm_rhyme_buster_enabled: true,
  stop_watch_enabled: true,
  red_light_green_light_enabled: true
)

TimexDatalinkClient::Protocol7::Eeprom.new(games: games)
```

## Calendar of Events

![image](https://user-images.githubusercontent.com/820984/207309088-753f58e5-0c02-436a-b038-4c2c9daea0c9.png)

![image](https://user-images.githubusercontent.com/820984/207310413-6a6fd728-f131-4c89-9e6d-b46a2c77b99b.png)

```ruby
phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

breakfast_with_cousins = phrase_builder.vocab_ids_for("Breakfast", "With", "Cousins")
crashing_around_the_house = phrase_builder.vocab_ids_for("Crashing", "Around", "The", "House")

events = [
  TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event.new(
    time: Time.new(2022, 12, 13, 9, 0, 0),
    phrase: breakfast_with_cousins
  ),
  TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event.new(
    time: Time.new(2022, 12, 13, 19, 0, 0),
    phrase: crashing_around_the_house
  )
]

TimexDatalinkClient::Protocol7::Eeprom::Calendar.new(
  time: Time.new(2022, 12, 11, 17, 50, 2),
  events: events
)

TimexDatalinkClient::Protocol7::Eeprom.new(calendar: calendar)
```

## Phone Numbers

![image](https://user-images.githubusercontent.com/820984/207311988-ff21dc2e-2530-4437-a6fa-93e7c24be591.png)

```ruby
phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

dog_sitter = phrase_builder.vocab_ids_for("Dog", "Sitter")
mom_and_dad = phrase_builder.vocab_ids_for("Mom", "And", "Dad")

phone_numbers = [
  TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber.new(
    name: dog_sitter,
    number: "8675309"
  ),
  TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber.new(
    name: mom_and_dad,
    number: "7133659900"
  )
]

TimexDatalinkClient::Protocol7::Eeprom.new(phone_numbers: phone_numbers)
```

## Speech Setup

![image](https://user-images.githubusercontent.com/820984/207313791-9951813b-6d41-40ca-9bf8-c11179522363.png)

```ruby
phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

my_dog_is_on_television = phrase_builder.vocab_ids_for("My", "Dog", "Is", "On", "Television")
where_is_my_phone = phrase_builder.vocab_ids_for("Where", "Is", "My", "Phone")

speech = TimexDatalinkClient::Protocol7::Eeprom::Speech.new(
  phrases: [
    my_dog_is_on_television,
    where_is_my_phone
  ]
)

TimexDatalinkClient::Protocol7::Eeprom.new(speech: speech)
```

## Complete code example

Here is an example that syncs all models to a device that supports protocol 7:

```ruby
require "timex_datalink_client"

phrase_builder = TimexDatalinkClient::Protocol7::PhraseBuilder.new(database: "pcvocab.mdb")

computer_from_mars = phrase_builder.vocab_ids_for("Computer", "From", "Mars")
boards_of_canada = phrase_builder.vocab_ids_for("Boards", "Of", "Canada")
my_dog_is_on_television = phrase_builder.vocab_ids_for("My", "Dog", "Is", "On", "Television")
where_is_my_phone = phrase_builder.vocab_ids_for("Where", "Is", "My", "Phone")

speech = TimexDatalinkClient::Protocol7::Eeprom::Speech.new(
  device_nickname: computer_from_mars,
  user_nickname: boards_of_canada,
  phrases: [
    my_dog_is_on_television,
    where_is_my_phone
  ]
)

get_up = phrase_builder.vocab_ids_for("Get", "Up")
really_do_it = phrase_builder.vocab_ids_for("Really", "Do", "It")
picture_day = phrase_builder.vocab_ids_for("Picture", "Day")

activities = [
  TimexDatalinkClient::Protocol7::Eeprom::Activity.new(
    time: Time.new(0, 1, 1, 7, 30, 0),  # Year, month, and day is ignored.
    messages: [get_up, really_do_it],
    random_speech: false
  ),
  TimexDatalinkClient::Protocol7::Eeprom::Activity.new(
    time: Time.new(0, 1, 1, 0, 30, 0),  # Year, month, and day is ignored.
    messages: [picture_day],
    random_speech: true
  )
]

fart = phrase_builder.vocab_ids_for("<Fart>").first
bell = phrase_builder.vocab_ids_for("<Bell>").first

games = TimexDatalinkClient::Protocol7::Eeprom::Games.new(
  memory_game_enabled: true,
  fortune_teller_enabled: true,
  countdown_timer_enabled: true,
  countdown_timer_seconds: 90,
  countdown_timer_sound: fart,
  mind_reader_enabled: true,
  music_time_keeper_enabled: true,
  music_time_keeper_sound: bell,
  morse_code_practice_enabled: true,
  treasure_hunter_enabled: true,
  rhythm_rhyme_buster_enabled: true,
  stop_watch_enabled: true,
  red_light_green_light_enabled: true
)

time = Time.now

breakfast_with_cousins = phrase_builder.vocab_ids_for("Breakfast", "With", "Cousins")
crashing_around_the_house = phrase_builder.vocab_ids_for("Crashing", "Around", "The", "House")

events = [
  TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event.new(
    time: Time.new(2022, 12, 13, 9, 0, 0),
    phrase: breakfast_with_cousins
  ),
  TimexDatalinkClient::Protocol7::Eeprom::Calendar::Event.new(
    time: Time.new(2022, 12, 13, 19, 0, 0),
    phrase: crashing_around_the_house
  )
]

calendar = TimexDatalinkClient::Protocol7::Eeprom::Calendar.new(
  time: time,
  events: events
)

dog_sitter = phrase_builder.vocab_ids_for("Dog", "Sitter")
mom_and_dad = phrase_builder.vocab_ids_for("Mom", "And", "Dad")

phone_numbers = [
  TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber.new(
    name: dog_sitter,
    number: "8675309"
  ),
  TimexDatalinkClient::Protocol7::Eeprom::PhoneNumber.new(
    name: mom_and_dad,
    number: "7133659900"
  )
]

models = [
  TimexDatalinkClient::Protocol7::Sync.new,
  TimexDatalinkClient::Protocol7::Start.new,
  TimexDatalinkClient::Protocol7::Eeprom.new(
    activities: activities,
    games: games,
    calendar: calendar,
    phone_numbers: phone_numbers,
    speech: speech
  ),
  TimexDatalinkClient::Protocol7::End.new
]

timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models,
  packet_sleep: 0,
  verbose: true
)

timex_datalink_client.write
```
