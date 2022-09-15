# Timex Datalink library for Ruby

Here is a fully-tested, feature-complete, and byte-for-byte perfect reimplementation of the Timex Datalink client
software as a Ruby library!  This library supports protocols 1, 3, and 9, which covers almost every Timex Datalink
device!

These devices have been tested to work with this library:

- Timex 70301 (Datalink 50, protocol 1)
- Timex 69737 (Datalink 150, protocol 3)
- Timex 78701 (Ironman Triathlon, protocol 9)
- Franklin Rolodex Flash PC Companion RFLS-8 (protocol 1)

Protocols 4 and 6 are not currently supported.  The Timex Datalink 150s uses protocol 4, and the Motorola Beepwear Pro
uses protocol 6.  These are the only devices known to use these protocols.  They might be supported sometime in the
future!

## What is the Timex Datalink?

The Timex Datalink is a watch that was introduced in 1994 that is essentially a small PDA on your wrist.  The early
models (supported by this software) have an optical sensor on the top of the face that receives data via visible light.

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

In addition, the Datalink protocol is also used in some other watches, organizers, and toys, i.e. the Motorola Beepwear
Pro, Royal FL95, Tiger PDA2000, Franklin Rolodex Flash PC Companion RFLS-8, and DSI e-BRAIN 69006.

## Determining the protocol to use

On Timex Datalink watches, pressing the center button on the right will change its mode.  Press this button until "COMM
MODE" is displayed, then "COMM READY" will appear.  This is sometimes accompanied by a version number.  Use the table
below to identify the protocol.

|Watch display|Protocol compatibility|
|---|---|
|![image](https://user-images.githubusercontent.com/820984/189607899-5bb67438-1c82-41e0-95d1-d1134cfb1f8b.png)|Use protocol 1 models in `TimexDatalinkClient::Protocol1`|
|![image](https://user-images.githubusercontent.com/820984/189609399-25eea5c5-958e-489d-936e-139342c9fddf.png)|Use protocol 3 models in `TimexDatalinkClient::Protocol3`|
|![image](https://user-images.githubusercontent.com/820984/189609671-33a6dc6b-1eb1-4942-8bac-238e6056d1c2.png)|Protocol 4 (currently not supported)|
|![image](https://user-images.githubusercontent.com/820984/190122029-6df17bd0-171a-425c-ac63-d415eeb9fffd.png)|Use protocol 9 models in `TimexDatalinkClient::Protocol9`|
|![image](https://user-images.githubusercontent.com/820984/190326340-3ffba239-ea9e-4595-83ae-c261be284a30.png)|Protocol 6 (currently not supported)|

During data transmission, the "start" packet of each protocol will announce the protocol number to the device.  If the
protocol doesn't match the device, the screen will display "PC-WATCH MISMATCH" and safely abort the data transmission.

Most non-Timex devices use protocol 1, so start with protocol 1 if the protocol can't be identified.

## Parity to the Timex Datalink software

Here are some examples of data in the original Timex Datalink software and how to reproduce its data with this library.

<image src="https://user-images.githubusercontent.com/820984/188435647-016b160d-0b25-4aa9-b094-f607127cefee.png" width="600px">

### Appointments

<image src="https://user-images.githubusercontent.com/820984/188425133-3b7a0a3a-ac2a-41a7-aeeb-326909e43f7e.png" width="600px">

```ruby
# For protocol 1:

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
  appointment_notification: 2
)

# For protocol 3:

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
  appointment_notification: 2
)
```

### Anniversaries

<image src="https://user-images.githubusercontent.com/820984/188428125-3a394e1d-5d15-4e28-bd40-b1aeadb360c2.png" width="600px">

```ruby
# For protocol 1:

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

# For protocol 3:

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

### Phone Numbers

<image src="https://user-images.githubusercontent.com/820984/188428971-d4085717-2dd2-42c1-894a-e75ecca585b0.png" width="600px">

```ruby
# For protocol 1:

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

# For protocol 3:

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

### Make a List

<image src="https://user-images.githubusercontent.com/820984/188429625-fe3bef86-58b2-445d-8669-a61000dd3e77.png" width="600px">

```ruby
# For protocol 1:

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

# For protocol 3:

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

### Time Settings

<image src="https://user-images.githubusercontent.com/820984/188431136-e2a40eec-d9cd-4b15-992e-3d7b1251b0ee.png" width="600px">

```ruby
# For protocol 1:

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

# For protocol 3:

TimexDatalinkClient::Protocol3::Time.new(
  zone: 1,
  time: Time.new(2022, 9, 5, 3, 39, 44),
  is_24h: false,
  name: "PDT",
  date_format: 0
)

TimexDatalinkClient::Protocol3::Time.new(
  zone: 2,
  time: Time.new(2022, 9, 5, 11, 39, 44),
  is_24h: true,
  name: "GMT",
  date_format: 0
)
```

### Alarms

<image src="https://user-images.githubusercontent.com/820984/188433212-57f41380-9416-4bc2-98fa-4dbc260c2965.png" width="600px">

```ruby
# For protocol 1:

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 1,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 0),
  message: "Wake up"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 2,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 5),
  message: "For real"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 3,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 10),
  message: "Get up"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 4,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 15),
  message: "Or not"
)

TimexDatalinkClient::Protocol1::Alarm.new(
  number: 5,
  audible: false,
  time: Time.new(2022, 1, 1, 11, 30),
  message: "Told you"
)

# For protocol 3:

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 1,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 0),
  message: "Wake up"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 2,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 5),
  message: "For real"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 3,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 10),
  message: "Get up"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 4,
  audible: true,
  time: Time.new(2022, 1, 1, 9, 15),
  message: "Or not"
)

TimexDatalinkClient::Protocol3::Alarm.new(
  number: 5,
  audible: false,
  time: Time.new(2022, 1, 1, 11, 30),
  message: "Told you"
)
```

### WristApps

<image src="https://user-images.githubusercontent.com/820984/188433986-723686d2-d862-4f54-acea-430c1a8f2571.png" width="600px">

```ruby
# Only supported in protocol 3:

TimexDatalinkClient::Protocol3::WristApp.new(zap_file: "DATALINK/APP/TIMER13.ZAP")
```

### Watch Sounds

<image src="https://user-images.githubusercontent.com/820984/188434465-97dc97ca-a396-4643-82ee-26724a4ca718.png" width="600px">

```ruby
# Only supported in protocol 3:

TimexDatalinkClient::Protocol3::SoundTheme.new(spc_file: "DATALINK/SND/DEFAULT.SPC")

TimexDatalinkClient::Protocol3::SoundOptions.new(
  hourly_chime: true,
  button_beep: false
)
```

## Code example

Here is an example that uses protocol 3 to every type of data to a device and uses all the features of this library:

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

time1 = Time.now + 4  # Add four seconds to keep in sync.
time2 = time1.dup.utc

models = [
  TimexDatalinkClient::Protocol3::Sync.new(length: 50),
  TimexDatalinkClient::Protocol3::Start.new,

  TimexDatalinkClient::Protocol3::Time.new(
    zone: 1,
    is_24h: false,
    date_format: 2,
    time: time1
  ),
  TimexDatalinkClient::Protocol3::Time.new(
    zone: 2,
    is_24h: true,
    date_format: 2,
    time: time2
  ),

  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 1,
    audible: true,
    time: Time.new(2022, 1, 1, 9, 0),
    message: "Wake up"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 2,
    audible: true,
    time: Time.new(2022, 1, 1, 9, 5),
    message: "For real"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 3,
    audible: true,
    time: Time.new(2022, 1, 1, 9, 10),
    message: "Get up"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 4,
    audible: true,
    time: Time.new(2022, 1, 1, 9, 15),
    message: "Or not"
  ),
  TimexDatalinkClient::Protocol3::Alarm.new(
    number: 5,
    audible: false,
    time: Time.new(2022, 1, 1, 11, 30),
    message: "Told you"
  ),

  TimexDatalinkClient::Protocol3::Eeprom.new(
    appointments: appointments,
    anniversaries: anniversaries,
    lists: lists,
    phone_numbers: phone_numbers,
    appointment_notification: 2
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

## Tuning data transfer performance

After every byte is sent to the watch, a small delay is necessary before advancing to the next byte.  This gives the
watch time to decode and store the incoming data.  In addition, an additional delay is necessary after sending a packet
of data (bytes that represent a piece of data, i.e. an alarm).

The byte and packet sleep time defaults to the same rate of the Timex Datalink software for parity.  This is 0.025
seconds per byte, and 0.25 seconds per packet.  These two sleep times can be tuned with the `byte_sleep` and
`packet_sleep` keywords when creating a `TimexDatalinkClient` instance.

In practice, much smaller values can be used for a much higher data rate.  In testing, these values seem to work
reliably with the [Teensy LC Notebook Adapter](https://github.com/synthead/timex-datalink-arduino):

```ruby
timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models,
  byte_sleep: 0.008,
  packet_sleep: 0.06,
  verbose: true
)
```
