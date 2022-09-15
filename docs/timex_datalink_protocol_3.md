# Using TimexDatalinkClient with Protocol 3

This document describes how to use protocol 3 devices with this library by comparing code examples to the Timex Datalink
software version 2.1d.

![image](https://user-images.githubusercontent.com/820984/190336173-049ebff8-0fd9-4743-93fd-eedd85e88688.png)

## Appointments

![image](https://user-images.githubusercontent.com/820984/190337012-215f8a66-de44-47a3-9834-4bc90c113a77.png)

```ruby
appointments = [
  TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
    time: Time.new(2022, 10, 31, 19, 0),
    message: "Scare the neighbors"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
    time: Time.new(2022, 11, 24, 17, 0),
    message: "Feed the neighbors"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
    time: Time.new(2022, 12, 25, 14, 0),
    message: "Spoil the neighbors"
  )
]

TimexDatalinkClient::Protocol3::Eeprom.new(
  appointments: appointments,
  appointment_notification: 3  # In 5 minute intervals.  255 for no notification.
)
```

## Anniversaries

![image](https://user-images.githubusercontent.com/820984/190337661-b1a57a49-cf7c-4fc6-9439-5d49d3f3f44c.png)

```ruby
anniversaries = [
  TimexDatalinkClient::Protocol3::Eeprom::Anniversary.new(
    time: Time.new(1985, 7, 3),
    anniversary: "Release of Back to the Future"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::Anniversary.new(
    time: Time.new(1968, 4, 6),
    anniversary: "Release of 2001"
  )
]

TimexDatalinkClient::Protocol3::Eeprom.new(anniversaries: anniversaries)
```

## Phone Numbers

![image](https://user-images.githubusercontent.com/820984/190338579-f062d4f2-1477-4b5f-8f11-28766d985df6.png)

```ruby
phone_numbers = [
  TimexDatalinkClient::Protocol3::Eeprom::PhoneNumber.new(
    name: "Marty McFly",
    number: "1112223333",
    type: "H"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "C"
  )
]

TimexDatalinkClient::Protocol3::Eeprom.new(phone_numbers: phone_numbers)
```

## Make a List

![image](https://user-images.githubusercontent.com/820984/190338737-1a972c10-5e50-4c33-8386-cd014bff3128.png)

```ruby
lists = [
  TimexDatalinkClient::Protocol3::Eeprom::List.new(
    list_entry: "Muffler bearings",
    priority: 2
  ),
  TimexDatalinkClient::Protocol3::Eeprom::List.new(
    list_entry: "Headlight fluid",
    priority: 4
  )
]

TimexDatalinkClient::Protocol3::Eeprom.new(lists: lists)
```

## Time Settings

![image](https://user-images.githubusercontent.com/820984/190338907-7fd94480-5898-4e46-b715-56565293d0c8.png)

```ruby
TimexDatalinkClient::Protocol3::Time.new(
  zone: 1,
  name: "PDT",
  time: Time.new(2022, 9, 5, 3, 39, 44),
  is_24h: false,
  date_format: 2
)

TimexDatalinkClient::Protocol3::Time.new(
  zone: 2,
  name: "GMT",
  time: Time.new(2022, 9, 5, 11, 39, 44),
  is_24h: true,
  date_format: 2
)
```

## Alarms

![image](https://user-images.githubusercontent.com/820984/190345616-e011cb73-8a71-49c5-84df-48b539a20e56.png)

```ruby
TimexDatalinkClient::Protocol3::Alarm.new(
  number: 1,
  audible: true,
  time: Time.new(0, 1, 1, 9, 0),  # Year, month, and day is ignored.
  message: "Wake up"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 2,
  audible: true,
  time: Time.new(0, 1, 1, 9, 5),  # Year, month, and day is ignored.
  message: "For real"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 3,
  audible: false,
  time: Time.new(0, 1, 1, 9, 10),  # Year, month, and day is ignored.
  message: "Get up"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 4,
  audible: true,
  time: Time.new(0, 1, 1, 18, 0),  # Year, month, and day is ignored.
  message: "Or not"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 5,
  audible: false,
  time: Time.new(0, 1, 1, 14, 0),  # Year, month, and day is ignored.
  message: "Told you"
)
```

## WristApps

![image](https://user-images.githubusercontent.com/820984/190347561-eab2353d-90d0-44b5-aa69-eb58c4e1c4d4.png)

```ruby
TimexDatalinkClient::Protocol3::WristApp.new(zap_file: "DATALINK/APP/TIMER13.ZAP")
```

## Watch Sounds

![image](https://user-images.githubusercontent.com/820984/190347710-b57fe25b-95b1-49b6-a897-6ad6f2ffe1aa.png)

```ruby
TimexDatalinkClient::Protocol3::SoundTheme.new(spc_file: "DATALINK/SND/DEFAULT.SPC")

TimexDatalinkClient::Protocol3::SoundOptions.new(
  hourly_chime: true,
  button_beep: false
)
```

## Complete code example

Here is an example that syncs all models to a device that supports protocol 3:

```ruby
require "timex_datalink_client"

appointments = [
  TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
    time: Time.new(2022, 10, 31, 19, 0),
    message: "Scare the neighbors"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
    time: Time.new(2022, 11, 24, 17, 0),
    message: "Feed the neighbors"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::Appointment.new(
    time: Time.new(2022, 12, 25, 14, 0),
    message: "Spoil the neighbors"
  )
]

anniversaries = [
  TimexDatalinkClient::Protocol3::Eeprom::Anniversary.new(
    time: Time.new(1985, 7, 3),
    anniversary: "Release of Back to the Future"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::Anniversary.new(
    time: Time.new(1968, 4, 6),
    anniversary: "Release of 2001"
  )
]

phone_numbers = [
  TimexDatalinkClient::Protocol3::Eeprom::PhoneNumber.new(
    name: "Marty McFly",
    number: "1112223333",
    type: "H"
  ),
  TimexDatalinkClient::Protocol3::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "C"
  )
]

lists = [
  TimexDatalinkClient::Protocol3::Eeprom::List.new(
    list_entry: "Muffler bearings",
    priority: 2
  ),
  TimexDatalinkClient::Protocol3::Eeprom::List.new(
    list_entry: "Headlight fluid",
    priority: 4
  )
]

time1 = Time.now
time2 = time1.dup.utc

models = [
  TimexDatalinkClient::Protocol3::Sync.new,
  TimexDatalinkClient::Protocol3::Start.new,

  TimexDatalinkClient::Protocol3::Time.new(
    zone: 1,
    time: time1,
    is_24h: false,
    date_format: 2
  ),
  TimexDatalinkClient::Protocol3::Time.new(
    zone: 2,
    time: time2,
    is_24h: true,
    date_format: 2
  ),

  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 1,
    audible: true,
    time: Time.new(0, 1, 1, 9, 0),  # Year, month, and day is ignored.
    message: "Wake up"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 2,
    audible: true,
    time: Time.new(0, 1, 1, 9, 5),  # Year, month, and day is ignored.
    message: "For real"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 3,
    audible: false,
    time: Time.new(0, 1, 1, 9, 10),  # Year, month, and day is ignored.
    message: "Get up"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 4,
    audible: true,
    time: Time.new(0, 1, 1, 9, 15),  # Year, month, and day is ignored.
    message: "Or not"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 5,
    audible: false,
    time: Time.new(0, 1, 1, 11, 30),  # Year, month, and day is ignored.
    message: "Told you"
  ),

  TimexDatalinkClient::Protocol3::Eeprom.new(
    appointments: appointments,
    anniversaries: anniversaries,
    lists: lists,
    phone_numbers: phone_numbers,
    appointment_notification: 3  # In 5 minute intervals.  255 for no notification.
  ),

  TimexDatalinkClient::Protocol3::SoundTheme.new(spc_file: "DATALINK/SND/DEFHIGH.SPC"),

  TimexDatalinkClient::Protocol3::SoundOptions.new(
    hourly_chime: true,
    button_beep: true
  ),

  TimexDatalinkClient::Protocol3::WristApp.new(zap_file: "DATALINK/APP/TIMER13.ZAP"),

  TimexDatalinkClient::Protocol3::End.new
]

timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models,
  verbose: true
)

timex_datalink_client.write
```