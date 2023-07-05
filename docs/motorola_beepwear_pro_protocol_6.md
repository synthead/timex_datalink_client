# Using TimexDatalinkClient with Protocol 6

This document describes how to use protocol 6 devices with this library by comparing code examples to the Motorola
BeepwearPRO software version 1.03.

![image](https://github.com/synthead/timex_datalink_client/assets/820984/e08eb41d-ca71-4046-a75c-ab3a0b3e322b)

## Time Of Day

![image](https://github.com/synthead/timex_datalink_client/assets/820984/f4f4dd13-68b1-49ce-9eaf-60c5395f2db9)

![image](https://github.com/synthead/timex_datalink_client/assets/820984/36d87858-d52f-44ce-9a89-5be5b32de597)

```ruby
TimexDatalinkClient::Protocol6::Time.new(
  zone: 1,
  time: TZInfo::Timezone.get("America/Los_Angeles").local_time(2023, 7, 4, 20, 34, 44),
  is_24h: false,
  date_format: "%_m-%d-%y"
)

TimexDatalinkClient::Protocol6::Time.new(
  zone: 2,
  flex_time: true,
  flex_time_zone: true,
  is_24h: true,
  date_format: "%_m-%d-%y"
)
```

Here are the valid values for `date_format`, represented by
[Time#strftime format](https://apidock.com/ruby/DateTime/strftime), followed by an example of 2023-09-06 in `%Y-%m-%d`
format:

|`date_format` value|Formatted example|
|---|---|
|`"%_m-%d-%y"`|` 9-06-23`|
|`"%_d-%m-%y"`|` 6-09-23`|
|`"%y-%m-%d"`|`23-09-06`|
|`"%_m.%d.%y"`|` 9.06.23`|
|`"%_d.%m.%y"`|` 6.09.23`|
|`"%y.%m.%d"`|`23.09.06`|

## Watch Options

![image](https://github.com/synthead/timex_datalink_client/assets/820984/a706d85c-725d-45ad-af20-0f22476ddd60)

![image](https://github.com/synthead/timex_datalink_client/assets/820984/6abf3294-a855-4538-9b05-ab07673c7ab1)

![image](https://github.com/synthead/timex_datalink_client/assets/820984/ae6a2034-2c3c-4057-9a48-a1fdad7c5990)

```ruby
TimexDatalinkClient::Protocol6::PagerOptions.new(
  auto_on_off: true,
  on_hour: 6,
  on_minute: 15,
  off_hour: 22,
  off_minute: 45,
  alert_sound: 4
)

TimexDatalinkClient::Protocol6::NightModeOptions.new(
  night_mode_deactivate_hours: 6,
  indiglo_timeout_seconds: 10,
  night_mode_on_notification: true
)

TimexDatalinkClient::Protocol6::SoundScrollOptions.new(
  hourly_chime: true,
  button_beep: false,
  scroll_speed: 2
)
```

## Alarms

![image](https://github.com/synthead/timex_datalink_client/assets/820984/74884c55-b6f6-426a-9571-bc1d0b02d8d8)

```ruby
TimexDatalinkClient::Protocol6::Alarm.new(
  number: 1,
  status: :armed,
  message: "State-of-the-art",
  time: Time.new(0, 1, 1, 6, 30)  # Year, month, and day is ignored.
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 2,
  status: :disarmed,
  message: "900 MHz",
  day: 4,
  time: Time.new(0, 1, 1, 7, 0)  # Year, month, and day is ignored.
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 3,
  status: :unused
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 4,
  status: :armed,
  message: "FLEX",
  month: 7,
  day: 4,
  time: Time.new(0, 1, 1, 6, 30)  # Year, month, and day is ignored.
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 5,
  status: :unused
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 6,
  status: :unused
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 7,
  status: :disarmed,
  message: "Motorola",
  time: Time.new(0, 1, 1, 12, 25)  # Year, month, and day is ignored.
)

TimexDatalinkClient::Protocol6::Alarm.new(
  number: 8,
  status: :armed,
  message: "Pager",
  time: Time.new(0, 1, 1, 21, 15)  # Year, month, and day is ignored.
)
```

## Phone Book

![image](https://github.com/synthead/timex_datalink_client/assets/820984/ca86aa76-2a3d-46cf-a1d2-fb14599b2138)

```ruby
phone_numbers = [
  TimexDatalinkClient::Protocol6::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "1112223333",
    type: "C"
  ),
  TimexDatalinkClient::Protocol6::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "HF"
  )
]

TimexDatalinkClient::Protocol6::Eeprom.new(phone_numbers: phone_numbers)
```

## Complete code example

Here is an example that syncs all models to a device that supports protocol 6:

```ruby
require "timex_datalink_client"

phone_numbers = [
  TimexDatalinkClient::Protocol6::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "1112223333",
    type: "C"
  ),
  TimexDatalinkClient::Protocol6::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "HF"
  )
]

time1 = Time.now
time2 = time1.dup.utc

models = [
  TimexDatalinkClient::Protocol6::Sync.new,
  TimexDatalinkClient::Protocol6::Start.new,

  TimexDatalinkClient::Protocol6::Time.new(
    zone: 1,
    time: time1,
    is_24h: false,
    date_format: "%_m-%d-%y"
  ),
  TimexDatalinkClient::Protocol6::Time.new(
    zone: 2,
    time: time2,
    is_24h: true,
    date_format: "%_m-%d-%y"
  ),

  TimexDatalinkClient::Protocol6::PagerOptions.new(
    auto_on_off: true,
    on_hour: 6,
    on_minute: 15,
    off_hour: 22,
    off_minute: 45,
    alert_sound: 4
  ),
  TimexDatalinkClient::Protocol6::NightModeOptions.new(
    night_mode_deactivate_hours: 6,
    indiglo_timeout_seconds: 10,
    night_mode_on_notification: true
  ),
  TimexDatalinkClient::Protocol6::SoundScrollOptions.new(
    hourly_chime: true,
    button_beep: false,
    scroll_speed: 2
  ),

  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 1,
    status: :armed,
    message: "State-of-the-art",
    time: Time.new(0, 1, 1, 6, 30)  # Year, month, and day is ignored.
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 2,
    status: :disarmed,
    message: "900 MHz",
    day: 4,
    time: Time.new(0, 1, 1, 7, 0)  # Year, month, and day is ignored.
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 3,
    status: :unused
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 4,
    status: :armed,
    message: "FLEX",
    month: 7,
    day: 4,
    time: Time.new(0, 1, 1, 6, 30)  # Year, month, and day is ignored.
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 5,
    status: :unused
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 6,
    status: :unused
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 7,
    status: :disarmed,
    message: "Motorola",
    time: Time.new(0, 1, 1, 12, 25)  # Year, month, and day is ignored.
  ),
  TimexDatalinkClient::Protocol6::Alarm.new(
    number: 8,
    status: :armed,
    message: "Pager",
    time: Time.new(0, 1, 1, 21, 15)  # Year, month, and day is ignored.
  ),

  TimexDatalinkClient::Protocol6::Eeprom.new(phone_numbers: phone_numbers),

  TimexDatalinkClient::Protocol6::End.new
]

timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models,
  verbose: true
)

timex_datalink_client.write
```
