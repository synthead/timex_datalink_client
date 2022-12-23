# Using TimexDatalinkClient with Protocol 9

This document describes how to use protocol 9 devices with this library by comparing code examples to the Timex Ironman
Triathlon software version 2.01.

![image](https://user-images.githubusercontent.com/820984/190350153-5565958f-8524-4d4c-9c6e-b419e1521095.png)

## Time Of Day

![image](https://user-images.githubusercontent.com/820984/190351578-e9c22fed-a7af-4c94-9477-ef123a740008.png)

![image](https://user-images.githubusercontent.com/820984/190352455-7a0805e2-f351-42f1-8da6-f86d7c86b1ca.png)

```ruby
TimexDatalinkClient::Protocol9::Time.new(
  zone: 1,
  time: Time.new(2022, 9, 15, 1, 12, 45),
  is_24h: false
)

TimexDatalinkClient::Protocol9::TimeName.new(
  zone: 1,
  name: "LAX"
)

TimexDatalinkClient::Protocol9::Time.new(
  zone: 2,
  time: Time.new(2022, 9, 15, 9, 12, 45),
  is_24h: true
)

TimexDatalinkClient::Protocol9::TimeName.new(
  zone: 2,
  name: "LON"
)
```

## Chrono

![image](https://user-images.githubusercontent.com/820984/190353364-628dc404-140f-4af4-be58-20ea3be7d2fd.png)

```ruby
chrono = TimexDatalinkClient::Protocol9::Eeprom::Chrono.new(
  label: "CHRONO",
  laps: 8
)

TimexDatalinkClient::Protocol9::Eeprom.new(chrono: chrono)
```

## Timers

![image](https://user-images.githubusercontent.com/820984/190354187-f1b7747e-003a-490f-b1e7-7869485b1fee.png)

```ruby
TimexDatalinkClient::Protocol9::Timer.new(
  number: 1,
  label: "TIMER 1",
  time: Time.new(0, 1, 1, 0, 5, 0),  # Year, month, and day is ignored.
  action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:stop_timer]
)

TimexDatalinkClient::Protocol9::Timer.new(
  number: 2,
  label: "TIMER 2",
  time: Time.new(0, 1, 1, 0, 10, 0),  # Year, month, and day is ignored.
  action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:repeat_timer]
)

TimexDatalinkClient::Protocol9::Timer.new(
  number: 3,
  label: "TIMER 3",
  time: Time.new(0, 1, 1, 0, 15, 0),  # Year, month, and day is ignored.
  action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:repeat_timer]
)

TimexDatalinkClient::Protocol9::Timer.new(
  number: 4,
  label: "TIMER 4",
  time: Time.new(0, 1, 1, 1, 30, 0),  # Year, month, and day is ignored.
  action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:stop_timer]
)

TimexDatalinkClient::Protocol9::Timer.new(
  number: 5,
  label: "TIMER 5",
  time: Time.new(0, 1, 1, 1, 0, 0),  # Year, month, and day is ignored.
  action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:start_chrono]
)
```

## Alarms

![image](https://user-images.githubusercontent.com/820984/190363807-aaef686a-25ff-4eb8-9768-40267bb85eab.png)

```ruby
TimexDatalinkClient::Protocol9::Alarm.new(
  number: 1,
  audible: false,
  time: Time.new(0, 1, 1, 6, 30),  # Year, month, and day is ignored.
  message: "TALKING AWAY"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 2,
  audible: true,
  time: Time.new(0, 1, 1, 8, 0),  # Year, month, and day is ignored.
  message: "DON'T KNOW WHAT"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 3,
  audible: true,
  time: Time.new(0, 1, 1, 8, 30),  # Year, month, and day is ignored.
  day: 15,
  message: "TO SAY I'LL SAY"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 4,
  audible: false,
  time: Time.new(0, 1, 1, 9, 35),  # Year, month, and day is ignored.
  month: 9,
  day: 14,
  message: "IT ANYWAY"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 5,
  audible: true,
  time: Time.new(0, 1, 1, 11, 0),  # Year, month, and day is ignored.
  message: "TODAY'S ANOTHER"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 6,
  audible: true,
  time: Time.new(0, 1, 1, 18, 0),  # Year, month, and day is ignored.
  message: "DAY TO FIND YOU"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 7,
  audible: false,
  time: Time.new(0, 1, 1, 19, 0),  # Year, month, and day is ignored.
  day: 19,
  message: "SHYING AWAY"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 8,
  audible: true,
  time: Time.new(0, 1, 1, 19, 30),  # Year, month, and day is ignored.
  message: "I'LL BE COMING"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 9,
  audible: false,
  time: Time.new(0, 1, 1, 21, 0),  # Year, month, and day is ignored.
  month: 7,
  day: 15,
  message: "FOR YOUR LOVE OK"
)

TimexDatalinkClient::Protocol9::Alarm.new(
  number: 10,
  audible: true,
  time: Time.new(0, 1, 1, 23, 0),  # Year, month, and day is ignored.
  message: "TAKE ON ME"
)
```

## Phone Book

![image](https://user-images.githubusercontent.com/820984/190359956-82360a41-11c9-4acf-b496-bd6dfbee1013.png)

```ruby
phone_numbers = [
  TimexDatalinkClient::Protocol9::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "1112223333",
    type: "C"
  ),
  TimexDatalinkClient::Protocol9::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "HF"
  )
]

TimexDatalinkClient::Protocol9::Eeprom.new(phone_numbers: phone_numbers)
```

## Watch Options

![image](https://user-images.githubusercontent.com/820984/190360658-899b0a75-3909-46ad-be87-87046f2f5d82.png)

```ruby
TimexDatalinkClient::Protocol9::SoundOptions.new(
  hourly_chime: true,
  button_beep: false
)
```

## Complete code example

Here is an example that syncs all models to a device that supports protocol 9:

```ruby
require "timex_datalink_client"

phone_numbers = [
  TimexDatalinkClient::Protocol9::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "1112223333",
    type: "C"
  ),
  TimexDatalinkClient::Protocol9::Eeprom::PhoneNumber.new(
    name: "Doc Brown",
    number: "4445556666",
    type: "HF"
  )
]

chrono = TimexDatalinkClient::Protocol9::Eeprom::Chrono.new(
  label: "CHRONO",
  laps: 8
)

time1 = Time.now
time2 = time1.dup.utc

models = [
  TimexDatalinkClient::Protocol9::Sync.new,
  TimexDatalinkClient::Protocol9::Start.new,

  TimexDatalinkClient::Protocol9::Time.new(
    zone: 1,
    time: time1,
    is_24h: false
  ),
  TimexDatalinkClient::Protocol9::TimeName.new(
    zone: 1,
    name: time1.zone
  ),

  TimexDatalinkClient::Protocol9::Time.new(
    zone: 2,
    time: time2,
    is_24h: true
  ),
  TimexDatalinkClient::Protocol9::TimeName.new(
    zone: 2,
    name: time2.zone
  ),

  TimexDatalinkClient::Protocol9::Timer.new(
    number: 1,
    label: "TIMER 1",
    time: Time.new(0, 1, 1, 0, 5, 0),  # Year, month, and day is ignored.
    action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:stop_timer]
  ),
  TimexDatalinkClient::Protocol9::Timer.new(
    number: 2,
    label: "TIMER 2",
    time: Time.new(0, 1, 1, 0, 10, 0),  # Year, month, and day is ignored.
    action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:repeat_timer]
  ),
  TimexDatalinkClient::Protocol9::Timer.new(
    number: 3,
    label: "TIMER 3",
    time: Time.new(0, 1, 1, 0, 15, 0),  # Year, month, and day is ignored.
    action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:repeat_timer]
  ),
  TimexDatalinkClient::Protocol9::Timer.new(
    number: 4,
    label: "TIMER 4",
    time: Time.new(0, 1, 1, 1, 30, 0),  # Year, month, and day is ignored.
    action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:stop_timer]
  ),
  TimexDatalinkClient::Protocol9::Timer.new(
    number: 5,
    label: "TIMER 5",
    time: Time.new(0, 1, 1, 1, 0, 0),  # Year, month, and day is ignored.
    action_at_end: TimexDatalinkClient::Protocol9::Timer::ACTIONS_AT_END[:start_chrono]
  ),

  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 1,
    audible: false,
    time: Time.new(0, 1, 1, 6, 30),  # Year, month, and day is ignored.
    message: "TALKING AWAY"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 2,
    audible: true,
    time: Time.new(0, 1, 1, 8, 0),  # Year, month, and day is ignored.
    message: "DON'T KNOW WHAT"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 3,
    audible: true,
    time: Time.new(0, 1, 1, 8, 30),  # Year, month, and day is ignored.
    day: 15,
    message: "TO SAY I'LL SAY"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 4,
    audible: false,
    time: Time.new(0, 1, 1, 9, 35),  # Year, month, and day is ignored.
    month: 9,
    day: 14,
    message: "IT ANYWAY"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 5,
    audible: true,
    time: Time.new(0, 1, 1, 11, 0),  # Year, month, and day is ignored.
    message: "TODAY'S ANOTHER"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 6,
    audible: true,
    time: Time.new(0, 1, 1, 18, 0),  # Year, month, and day is ignored.
    message: "DAY TO FIND YOU"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 7,
    audible: false,
    time: Time.new(0, 1, 1, 19, 0),  # Year, month, and day is ignored.
    day: 19,
    message: "SHYING AWAY"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 8,
    audible: true,
    time: Time.new(0, 1, 1, 19, 30),  # Year, month, and day is ignored.
    message: "I'LL BE COMING"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 9,
    audible: false,
    time: Time.new(0, 1, 1, 21, 0),  # Year, month, and day is ignored.
    month: 7,
    day: 15,
    message: "FOR YOUR LOVE OK"
  ),
  TimexDatalinkClient::Protocol9::Alarm.new(
    number: 10,
    audible: true,
    time: Time.new(0, 1, 1, 23, 0),  # Year, month, and day is ignored.
    message: "TAKE ON ME"
  ),

  TimexDatalinkClient::Protocol9::Eeprom.new(
    chrono: chrono,
    phone_numbers: phone_numbers
  ),

  TimexDatalinkClient::Protocol9::SoundOptions.new(
    hourly_chime: true,
    button_beep: false
  ),

  TimexDatalinkClient::Protocol9::End.new
]

timex_datalink_client = TimexDatalinkClient.new(
  serial_device: "/dev/ttyACM0",
  models: models,
  verbose: true
)

timex_datalink_client.write
```
