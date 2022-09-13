# frozen_string_literal: true

require "timex_datalink_client/version"
require "timex_datalink_client/notebook_adapter"

require "timex_datalink_client/eeprom/anniversary"
require "timex_datalink_client/eeprom/appointment"
require "timex_datalink_client/eeprom/list"
require "timex_datalink_client/eeprom/phone_number"

require "timex_datalink_client/protocol_1/alarm"
require "timex_datalink_client/protocol_1/eeprom"
require "timex_datalink_client/protocol_1/end"
require "timex_datalink_client/protocol_1/start"
require "timex_datalink_client/protocol_1/sync"
require "timex_datalink_client/protocol_1/time"
require "timex_datalink_client/protocol_1/time_name"

require "timex_datalink_client/protocol_3/alarm"
require "timex_datalink_client/protocol_3/eeprom"
require "timex_datalink_client/protocol_3/end"
require "timex_datalink_client/protocol_3/sound_options"
require "timex_datalink_client/protocol_3/sound_theme"
require "timex_datalink_client/protocol_3/start"
require "timex_datalink_client/protocol_3/sync"
require "timex_datalink_client/protocol_3/time"
require "timex_datalink_client/protocol_3/wrist_app"

require "timex_datalink_client/protocol_9/alarm"
require "timex_datalink_client/protocol_9/end"
require "timex_datalink_client/protocol_9/sound_options"
require "timex_datalink_client/protocol_9/start"
require "timex_datalink_client/protocol_9/sync"
require "timex_datalink_client/protocol_9/time"
require "timex_datalink_client/protocol_9/time_name"

class TimexDatalinkClient
  attr_accessor :serial_device, :models, :byte_sleep, :packet_sleep, :verbose

  # Create a TimexDatalinkClient instance.
  #
  # @param serial_device [String] Path to serial device.
  # @param models [Array<Protocol3::Alarm, Protocol3::Eeprom, Protocol3::End, Protocol3::SoundOptions,
  #   Protocol3::SoundTheme, Protocol3::Start, Protocol3::Sync, Protocol3::Time, Protocol3::WristApp>] Models to compile
  #   data for.
  # @param byte_sleep [Integer, nil] Time to sleep after sending byte.
  # @param packet_sleep [Integer, nil] Time to sleep after sending packet of bytes.
  # @param verbose [Boolean] Write verbose output to console.
  # @return [TimexDatalinkClient] TimexDatalinkClient instance.
  def initialize(serial_device:, models: [], byte_sleep: nil, packet_sleep: nil, verbose: false)
    @serial_device = serial_device
    @models = models
    @byte_sleep = byte_sleep
    @packet_sleep = packet_sleep
    @verbose = verbose
  end

  # Write data for all models to serial device.
  #
  # @return [void]
  def write
    notebook_adapter.write(packets)
  end

  # Compile packets for all models.
  #
  # @return [Array<Array<Integer>>] Two-dimensional array of integers that represent bytes.
  def packets
    models.map(&:packets).flatten(1)
  end

  private

  def notebook_adapter
    @notebook_adapter ||= NotebookAdapter.new(
      serial_device: serial_device,
      byte_sleep: byte_sleep,
      packet_sleep: packet_sleep,
      verbose: verbose
    )
  end
end
