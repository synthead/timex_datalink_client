# Timex Datalink library for Ruby

Here is a fully-tested, feature-complete, and byte-for-byte perfect reimplementation of the Timex Datalink client
software as a Ruby library!  This library supports protocols 1, 3, 4, 7, and 9, which covers almost every Timex Datalink
device!

These devices have been tested to work with this library:

- Timex Datalink 50 (protocol 1)
- Timex Datalink 70 (protocol 1)
- Timex Datalink 150 (protocol 3)
- Timex Datalink 150s (protocol 4)
- Timex Ironman Triathlon (protocol 9)
- Franklin Rolodex Flash PC Companion RFLS-8 (protocol 1)
- Royal FL95 PC Organizer (protocol 1)
- DSI e-BRAIN (protocol 7)

Protocol 6 is not currently supported.  The only known product to use this protocol is the Motorola Beepwear Pro.  This
may be supported sometime in the future!

## What is the Timex Datalink?

The Timex Datalink is a watch that was introduced in 1994 that is essentially a small PDA on your wrist.  The early
models (supported by this software) have an optical sensor on the top of the face that receives data via visible light.

<image src="https://user-images.githubusercontent.com/820984/209043607-a449b764-42f9-4f92-9a32-cd0665551289.jpg" width="600px">

The original data transfer method involves
[drawing patterns of lines on a CRT monitor](https://www.youtube.com/watch?v=p3Pzxmq-JLM) for the watch to receive with
the optical sensor.  CRTs use electron beams that draw scan lines one-by-one from top to bottom, then it returns to the
top and repeats for the next frame. This means that the electron guns turn on when its drawing a white line, and and
turn off when its drawing the black background. This produces flashing light as the graphics are drawn, which is
ultimately received by the optical sensor and decoded by the Timex Datalink device.

Have a CRT monitor?  Use this library with [timex\_datalink\_crt](https://github.com/synthead/timex_datalink_crt) to
transfer data with your CRT!

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

## Installing Ruby and the timex\_datalink\_client gem

If you need to install Ruby, follow the
[Ruby installation instructions](https://www.ruby-lang.org/en/documentation/installation) first.

Then, with Ruby installed, run this command to install the timex\_datalink\_client gem:

```shell
gem install timex_datalink_client
```

You're done!  From here, continue reading the documentation for which protocol to use and follow the code examples below.

## Determining the protocol to use

On Timex Datalink watches, pressing the center button on the right will change its mode.  Press this button until "COMM
MODE" is displayed, then "COMM READY" will appear.  This is sometimes accompanied by a version number.  Use the table
below to identify the protocol.

<table>
  <tr>
    <th>Watch display</th>
    <th>Protocol compatibility</th>
  </tr>

  <tr>
    <td>
      <image src="https://user-images.githubusercontent.com/820984/189607899-5bb67438-1c82-41e0-95d1-d1134cfb1f8b.png">
    </td>
    <td>Use protocol 1 models in <code>TimexDatalinkClient::Protocol1</code></td>
  </tr>

  <tr>
    <td>
      <image src="https://user-images.githubusercontent.com/820984/189609399-25eea5c5-958e-489d-936e-139342c9fddf.png">
    </td>
    <td>Use protocol 3 models in <code>TimexDatalinkClient::Protocol3</code></td>
  </tr>

  <tr>
    <td>
      <image src="https://user-images.githubusercontent.com/820984/189609671-33a6dc6b-1eb1-4942-8bac-238e6056d1c2.png">
    </td>
    <td>Use protocol 4 models in <code>TimexDatalinkClient::Protocol4</code></td>
  </tr>

  <tr>
    <td>
      <image src="https://user-images.githubusercontent.com/820984/190122029-6df17bd0-171a-425c-ac63-d415eeb9fffd.png">
    </td>
    <td>Use protocol 9 models in <code>TimexDatalinkClient::Protocol9</code></td>
  </tr>

  <tr>
    <td>
      <image src="https://user-images.githubusercontent.com/820984/190326340-3ffba239-ea9e-4595-83ae-c261be284a30.png">
    </td>
    <td>Protocol 6 (currently not supported)</td>
  </tr>
</table>

During data transmission, the "start" packet of each protocol will announce the protocol number to the device.  If the
protocol doesn't match the device, the screen will display "PC-WATCH MISMATCH" and safely abort the data transmission.

Most non-Timex devices use protocol 1, so start with protocol 1 if the protocol can't be identified.

## Code examples

Code examples for supported protocols have their own documentation:

- [Using TimexDatalinkClient with Protocol 1](docs/timex_datalink_protocol_1.md)
- [Using TimexDatalinkClient with Protocol 3](docs/timex_datalink_protocol_3.md)
- [Using TimexDatalinkClient with Protocol 4](docs/timex_datalink_protocol_4.md)
- [Using TimexDatalinkClient with Protocol 7](docs/dsi_ebrain_protocol_7.md)
- [Using TimexDatalinkClient with Protocol 9](docs/timex_ironman_triathlon_protocol_9.md)

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
