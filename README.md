# Timex Datalink library for Ruby

Here is a fully-tested, feature-complete, and byte-for-byte perfect reimplementation of the Timex Datalink client
software as a Ruby library!

For now, this library only supports the Timex Datalink 150 watch.  More models may be supported in the future!

## What is a Timex Datalink?

The Timex Datalink is a watch that was introduced in 1994 that is essentially a small PDA on your wrist.  The early models (supported by this software) have an optical sensor on the top of the face that receives data via visible light.

<image src="https://user-images.githubusercontent.com/820984/188436920-c6763a48-ce5a-4f16-af2d-df8bd7ca4849.png" width="600px">

Originally, these watches received their data by drawing patterns on CRT computer monitors.  CRTs draw scan lines from
top to bottom with electron beams, so the beams essentially "flash" as they draw the picture.  This allows data to be
"drawn" on the screen for the watch to receive wirelessly.

<image src="https://user-images.githubusercontent.com/820984/188436622-8cac39c7-9edc-4d92-a8c7-cbe9774cb691.jpg" width="600px">

For laptop users, Timex also offered the Datalink Notebook Adapter.  Instead of using a CRT monitor, the Notebook
Adapter simply flashed a single LED light.  This adapter is fully supported by the Timex Datalink software, and sends
the same data as a CRT.

<image src="https://user-images.githubusercontent.com/820984/188438526-80752f6a-ef5d-42e9-bf46-e8b10a307a18.png" width="600px">

This library communicates with the Datalink Notebook Adapter to emit data to your Timex Datalink watch.  Don't have a
Notebook Adapter?  [Use a Teensy LC instead](https://github.com/synthead/timex-datalink-arduino)!

<image src="https://user-images.githubusercontent.com/820984/188439596-12b4ff61-7d52-4203-b439-740dbd094657.png" width="600px">

As a fun tidbit, these watches are flight certified by NASA and is one of four watches qualified by NASA for space
travel!  Here's a shot of James H. Newman wearing a Datalink watch on the Space Shuttle for STS-88!

<image src="https://user-images.githubusercontent.com/820984/188442622-13ff7be5-4cf6-488e-936b-ca8874648467.png" width="600px">

## Parity to the Timex Datalink software

Here are some examples of data in the original Timex Datalink software and how to reproduce its data with this library.

<image src="https://user-images.githubusercontent.com/820984/188435647-016b160d-0b25-4aa9-b094-f607127cefee.png" width="600px">

### Appointments

<image src="https://user-images.githubusercontent.com/820984/188425133-3b7a0a3a-ac2a-41a7-aeeb-326909e43f7e.png" width="600px">

```ruby
appointments = [
  TimexDatalinkClient::Eeprom::Appointment.new(
    time: Time.new(2022, 10, 31, 19, 0),
    message: "scare the neighbors"
  ),
  TimexDatalinkClient::Eeprom::Appointment.new(
    time: Time.new(2022, 11, 24, 17, 0),
    message: "feed the neighbors"
  ),
  TimexDatalinkClient::Eeprom::Appointment.new(
    time: Time.new(2022, 12, 25, 14, 0),
    message: "spoil the neighbors"
  )
]

TimexDatalinkClient::Eeprom.new(
  appointments: appointments,
  appointment_notification: 2
)
```

### Anniversaries

<image src="https://user-images.githubusercontent.com/820984/188428125-3a394e1d-5d15-4e28-bd40-b1aeadb360c2.png" width="600px">

```ruby
anniversaries = [
  TimexDatalinkClient::Eeprom::Anniversary.new(
    time: Time.new(1985, 7, 3),
    anniversary: "release of back to the future"
  ),
  TimexDatalinkClient::Eeprom::Anniversary.new(
    time: Time.new(1968, 4, 6),
    anniversary: "release of 2001"
  )
]

TimexDatalinkClient::Eeprom.new(anniversaries: anniversaries)
```

### Phone Numbers

<image src="https://user-images.githubusercontent.com/820984/188428971-d4085717-2dd2-42c1-894a-e75ecca585b0.png" width="600px">

```ruby
phone_numbers = [
  TimexDatalinkClient::Eeprom::PhoneNumber.new(
    name: "marty mcfly",
    number: "1112223333",
    type: "h"
  ),
  TimexDatalinkClient::Eeprom::PhoneNumber.new(
    name: "doc brown",
    number: "4445556666",
    type: "c"
  )
]

TimexDatalinkClient::Eeprom.new(phone_numbers: phone_numbers)
```

### Make a List

<image src="https://user-images.githubusercontent.com/820984/188429625-fe3bef86-58b2-445d-8669-a61000dd3e77.png" width="600px">

```ruby
lists = [
  TimexDatalinkClient::Eeprom::List.new(
    list_entry: "muffler bearings",
    priority: 2
  ),
  TimexDatalinkClient::Eeprom::List.new(
    list_entry: "headlight fluid",
    priority: 4
  )
]

TimexDatalinkClient::Eeprom.new(lists: lists)
```

### Time Settings

<image src="https://user-images.githubusercontent.com/820984/188431136-e2a40eec-d9cd-4b15-992e-3d7b1251b0ee.png" width="600px">

```ruby
timezone_1 = TZInfo::Timezone.get("US/Pacific")
time_1 = timezone_1.local_time(2022, 9, 5, 3, 39, 44)

TimexDatalinkClient::Time.new(
  zone: 1,
  time: time_1,
  is_24h: false,
  date_format: 0,
)

timezone_2 = TZInfo::Timezone.get("GMT")
time_2 = timezone_2.local_time(2022, 9, 5, 11, 39, 44)

TimexDatalinkClient::Time.new(
  zone: 2,
  time: time_2,
  is_24h: true,
  date_format: 0,
),
```

### Alarms

<image src="https://user-images.githubusercontent.com/820984/188433212-57f41380-9416-4bc2-98fa-4dbc260c2965.png" width="600px">

```ruby
TimexDatalinkClient::Alarm.new(
  number: 1,
  audible: 1,
  time: Time.new(2022, 1, 1, 9, 0),
  message: "wake up"
)

TimexDatalinkClient::Alarm.new(
  number: 2,
  audible: 1,
  time: Time.new(2022, 1, 1, 9, 5),
  message: "for real"
)

TimexDatalinkClient::Alarm.new(
  number: 3,
  audible: 1,
  time: Time.new(2022, 1, 1, 9, 5),
  message: "get up"
)

TimexDatalinkClient::Alarm.new(
  number: 4,
  audible: 1,
  time: Time.new(2022, 1, 1, 9, 5),
  message: "or not"
)

TimexDatalinkClient::Alarm.new(
  number: 5,
  audible: 0,
  time: Time.new(2022, 1, 1, 9, 5),
  message: "told you"
)
```

### WristApps

<image src="https://user-images.githubusercontent.com/820984/188433986-723686d2-d862-4f54-acea-430c1a8f2571.png" width="600px">

```ruby
TimexDatalinkClient::WristApp.new(
  wrist_app_data: File.open("DATALINK/APP/TIMER13.ZAP", "rb").read
)
```

### Watch Sounds

<image src="https://user-images.githubusercontent.com/820984/188434465-97dc97ca-a396-4643-82ee-26724a4ca718.png" width="600px">

```ruby
  TimexDatalinkClient::SoundTheme.new(
    sound_data: File.open("DATALINK/SND/DEFHIGH.SPC").read
  )

  TimexDatalinkClient::SoundOptions.new(
    hourly_chimes: 1,
    button_beep: 0
  )
```

## Code example

Here is an example that sends every type of data to the watch and uses all the features of this library:

```ruby
require "timex_datalink_client"

appointments = [
  TimexDatalinkClient::Eeprom::Appointment.new(
    time: Time.new(2022, 10, 31, 19, 0),
    message: "scare the neighbors"
  ),
  TimexDatalinkClient::Eeprom::Appointment.new(
    time: Time.new(2022, 11, 24, 17, 0),
    message: "feed the neighbors"
  ),
  TimexDatalinkClient::Eeprom::Appointment.new(
    time: Time.new(2022, 12, 25, 14, 0),
    message: "spoil the neighbors"
  )
]

anniversaries = [
  TimexDatalinkClient::Eeprom::Anniversary.new(
    time: Time.new(1985, 7, 3),
    anniversary: "release of back to the future"
  ),
  TimexDatalinkClient::Eeprom::Anniversary.new(
    time: Time.new(1968, 4, 6),
    anniversary: "release of 2001"
  )
]

phone_numbers = [
  TimexDatalinkClient::Eeprom::PhoneNumber.new(
    name: "marty mcfly",
    number: "1112223333",
    type: "h"
  ),
  TimexDatalinkClient::Eeprom::PhoneNumber.new(
    name: "doc brown",
    number: "4445556666",
    type: "c"
  )
]

lists = [
  TimexDatalinkClient::Eeprom::List.new(
    list_entry: "muffler bearings",
    priority: 2
  ),
  TimexDatalinkClient::Eeprom::List.new(
    list_entry: "headlight fluid",
    priority: 4
  )
]

time1 = Time.now + 4  # Add four seconds to keep in sync.
time2 = time1.dup.utc

models = [
  TimexDatalinkClient::Sync.new(length: 50),
  TimexDatalinkClient::Start.new,

  TimexDatalinkClient::Time.new(
    zone: 1,
    is_24h: false,
    date_format: 2,
    time: time1
  ),
  TimexDatalinkClient::Time.new(
    zone: 2,
    is_24h: true,
    date_format: 2,
    time: time2
  ),

  TimexDatalinkClient::Alarm.new(
    number: 1,
    audible: 1,
    time: Time.new(2022, 1, 1, 9, 0),
    message: "wake up"
  ),
  TimexDatalinkClient::Alarm.new(
    number: 2,
    audible: 1,
    time: Time.new(2022, 1, 1, 9, 5),
    message: "for real"
  ),
  TimexDatalinkClient::Alarm.new(
    number: 3,
    audible: 1,
    time: Time.new(2022, 1, 1, 9, 5),
    message: "get up"
  ),
  TimexDatalinkClient::Alarm.new(
    number: 4,
    audible: 1,
    time: Time.new(2022, 1, 1, 9, 5),
    message: "or not"
  ),
  TimexDatalinkClient::Alarm.new(
    number: 5,
    audible: 0,
    time: Time.new(2022, 1, 1, 9, 5),
    message: "told you"
  ),

  TimexDatalinkClient::Eeprom.new(
    appointments: appointments,
    anniversaries: anniversaries,
    lists: lists,
    phone_numbers: phone_numbers,
    appointment_notification: 2
  ),

  TimexDatalinkClient::SoundTheme.new(
    sound_data: File.open("DATALINK/SND/DEFHIGH.SPC").read
  ),
  TimexDatalinkClient::SoundOptions.new(
    hourly_chimes: 1,
    button_beep: 1
  ),

  TimexDatalinkClient::WristApp.new(
    wrist_app_data: File.open("DATALINK/APP/TIMER13.ZAP", "rb").read
  ),

  TimexDatalinkClient::End.new
]

timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models
)

timex_datalink_client.write
```
