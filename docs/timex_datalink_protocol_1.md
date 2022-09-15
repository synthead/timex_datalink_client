# Protocol 1 usage

This document describes how to use protocol 1 devices with this library by comparing code examples to the Timex Datalink
software version 2.1d.

![image](https://user-images.githubusercontent.com/820984/190341990-540fd072-4380-4c01-b5d4-5f2f2b78950f.png)

Please note that WristApps and Watch Sounds are not supported in protocol 1.  They are visible in the Timex Datalink
software, but when the buttons are clicked, it will display a dialog about the feature is not supported.

## Appointments

![image](https://user-images.githubusercontent.com/820984/190337012-215f8a66-de44-47a3-9834-4bc90c113a77.png)

```ruby
appointments = [
  TimexDatalinkClient::Protocol1::Eeprom::Appointment.new(
    time: Time.new(2022, 10, 31, 19, 0),
    message: "Scare the neighbors"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::Appointment.new(
    time: Time.new(2022, 11, 24, 17, 0),
    message: "Feed the neighbors"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::Appointment.new(
    time: Time.new(2022, 12, 25, 14, 0),
    message: "Spoil the neighbors"
  )
]

TimexDatalinkClient::Protocol1::Eeprom.new(
  appointments: appointments,
  appointment_notification: 3  # In 5 minute intervals.  255 for no notification.
)
```

## Anniversaries

![image](https://user-images.githubusercontent.com/820984/190337661-b1a57a49-cf7c-4fc6-9439-5d49d3f3f44c.png)

```ruby
anniversaries = [
  TimexDatalinkClient::Protocol1::Eeprom::Anniversary.new(
    time: Time.new(1985, 7, 3),
    anniversary: "Release of Back to the Future"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::Anniversary.new(
    time: Time.new(1968, 4, 6),
    anniversary: "Release of 2001"
  )
]

TimexDatalinkClient::Protocol1::Eeprom.new(anniversaries: anniversaries)
```

## Phone Numbers

![image](https://user-images.githubusercontent.com/820984/190338579-f062d4f2-1477-4b5f-8f11-28766d985df6.png)

```ruby
phone_numbers = [
  TimexDatalinkClient::Protocol1::Eeprom::PhoneNumber.new(
    name: "Marty McFly",
    number: "1112223333",
    type: "H"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "C"
  )
]

TimexDatalinkClient::Protocol1::Eeprom.new(phone_numbers: phone_numbers)
```

## Make a List

![image](https://user-images.githubusercontent.com/820984/190338737-1a972c10-5e50-4c33-8386-cd014bff3128.png)

```ruby
lists = [
  TimexDatalinkClient::Protocol1::Eeprom::List.new(
    list_entry: "Muffler bearings",
    priority: 2
  ),
  TimexDatalinkClient::Protocol1::Eeprom::List.new(
    list_entry: "Headlight fluid",
    priority: 4
  )
]

TimexDatalinkClient::Protocol1::Eeprom.new(lists: lists)
```

## Time Settings

![image](https://user-images.githubusercontent.com/820984/190338907-7fd94480-5898-4e46-b715-56565293d0c8.png)

```ruby
TimexDatalinkClient::Protocol1::Time.new(
  zone: 1,
  time: Time.new(2022, 9, 5, 3, 39, 44),
  is_24h: false
)

TimexDatalinkClient::Protocol1::TimeName.new(
  zone: 1,
  name: "PDT"
)

TimexDatalinkClient::Protocol1::Time.new(
  zone: 2,
  time: Time.new(2022, 9, 5, 11, 39, 44),
  is_24h: true
)

TimexDatalinkClient::Protocol1::TimeName.new(
  zone: 2,
  name: "GMT"
)
```

## Alarms

![image](https://user-images.githubusercontent.com/820984/190340768-d426d7f3-d439-420b-907e-d514e9548179.png)

```ruby
TimexDatalinkClient::Protocol1::Alarm.new(
  number: 1,
  audible: true,
  time: Time.new(0, 1, 1, 9, 0),  # Year, month, and day is ignored.
  message: "Wake up"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 2,
  audible: true,
  time: Time.new(0, 1, 1, 9, 5),  # Year, month, and day is ignored.
  message: "For real"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 3,
  audible: false,
  time: Time.new(0, 1, 1, 9, 10),  # Year, month, and day is ignored.
  message: "Get up"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 4,
  audible: true,
  time: Time.new(0, 1, 1, 18, 0),  # Year, month, and day is ignored.
  month: 9,
  day: 18,
  message: "Yearly"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 5,
  audible: false,
  time: Time.new(0, 1, 1, 14, 0),  # Year, month, and day is ignored.
  day: 26,
  message: "Monthly"
)
```

## Code example

Here is an example that uses all of the above data to a device and uses all the features of protocol 1:

```ruby
require "timex_datalink_client"

appointments = [
  TimexDatalinkClient::Protocol1::Eeprom::Appointment.new(
    time: Time.new(2022, 10, 31, 19, 0),
    message: "Scare the neighbors"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::Appointment.new(
    time: Time.new(2022, 11, 24, 17, 0),
    message: "Feed the neighbors"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::Appointment.new(
    time: Time.new(2022, 12, 25, 14, 0),
    message: "Spoil the neighbors"
  )
]

anniversaries = [
  TimexDatalinkClient::Protocol1::Eeprom::Anniversary.new(
    time: Time.new(1985, 7, 3),
    anniversary: "Release of Back to the Future"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::Anniversary.new(
    time: Time.new(1968, 4, 6),
    anniversary: "Release of 2001"
  )
]

phone_numbers = [
  TimexDatalinkClient::Protocol1::Eeprom::PhoneNumber.new(
    name: "Marty McFly",
    number: "1112223333",
    type: "H"
  ),
  TimexDatalinkClient::Protocol1::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "C"
  )
]

lists = [
  TimexDatalinkClient::Protocol1::Eeprom::List.new(
    list_entry: "Muffler bearings",
    priority: 2
  ),
  TimexDatalinkClient::Protocol1::Eeprom::List.new(
    list_entry: "Headlight fluid",
    priority: 4
  )
]

time1 = Time.now
time2 = time1.dup.utc

models = [
  TimexDatalinkClient::Protocol1::Sync.new,
  TimexDatalinkClient::Protocol1::Start.new,

  TimexDatalinkClient::Protocol1::Time.new(
    zone: 1,
    time: time1,
    is_24h: false
  ),
  TimexDatalinkClient::Protocol1::TimeName.new(
    zone: 1,
    name: time1.zone
  ),

  TimexDatalinkClient::Protocol1::Time.new(
    zone: 2,
    time: time2,
    is_24h: true
  ),
  TimexDatalinkClient::Protocol1::TimeName.new(
    zone: 2,
    name: time2.zone
  ),

  TimexDatalinkClient::Protocol1::Alarm.new(
    number: 1,
    audible: true,
    time: Time.new(0, 1, 1, 9, 0),  # Year, month, and day is ignored.
    message: "Wake up"
  ),
  TimexDatalinkClient::Protocol1::Alarm.new(
    number: 2,
    audible: true,
    time: Time.new(0, 1, 1, 9, 5),  # Year, month, and day is ignored.
    message: "For real"
  ),
  TimexDatalinkClient::Protocol1::Alarm.new(
    number: 3,
    audible: false,
    time: Time.new(0, 1, 1, 9, 10),  # Year, month, and day is ignored.
    message: "Get up"
  ),
  TimexDatalinkClient::Protocol1::Alarm.new(
    number: 4,
    audible: true,
    time: Time.new(0, 1, 1, 18, 0),  # Year, month, and day is ignored.
    month: 9,
    day: 18,
    message: "Yearly"
  ),
  TimexDatalinkClient::Protocol1::Alarm.new(
    number: 5,
    audible: false,
    time: Time.new(0, 1, 1, 14, 0),  # Year, month, and day is ignored.
    day: 26,
    message: "Monthly"
  ),

  TimexDatalinkClient::Protocol1::Eeprom.new(
    appointments: appointments,
    anniversaries: anniversaries,
    lists: lists,
    phone_numbers: phone_numbers,
    appointment_notification: 3  # In 5 minute intervals.  255 for no notification.
  ),

  TimexDatalinkClient::Protocol1::End.new
]

timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models,
  verbose: true
)

timex_datalink_client.write
```
