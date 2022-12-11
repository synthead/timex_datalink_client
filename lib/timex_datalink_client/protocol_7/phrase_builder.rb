# frozen_string_literal: true

require "mdb"

class TimexDatalinkClient
  class Protocol7
    class PhraseBuilder
      class WordNotFound < StandardError; end

      attr_accessor :database

      # Create a PhraseBuilder instance.
      #
      # @param database [String] Database file to compile phrase data from.
      # @return [PhraseBuilder] PhraseBuilder instance.
      def initialize(database:)
        @database = database
      end

      # Compile vocabulary IDs for protocol 7 phrases.
      #
      # @param words [Array<String>] Array of words.
      # @raise [WordNotFound] Word not found in protocol 7 database.
      # @return [Array<Integer>] Array of protocol 7 vocabulary IDs.
      def vocab_ids_for(*words)
        words.flat_map do |word|
          vocab = vocab_for_word(word)

          raise(WordNotFound, "#{word} is not a valid word!") unless vocab

          vocab_links = vocab_links_for_vocab(vocab)

          vocab_links.map do |vocab_link|
            linked_vocab = vocab_for_vocab_link(vocab_link)

            linked_vocab[:"PC Index"].to_i
          end
        end
      end

      private

      def mdb
        @mdb ||= Mdb.open(database)
      end

      def vocab_table
        @vocab_table ||= mdb["Vocab"]
      end

      def vocab_links_table
        @vocab_links_table ||= mdb["Vocab Links"]
      end

      def vocab_for_word(word)
        vocab_table.detect { |vocab| vocab[:Label].casecmp?(word) }
      end

      def vocab_links_for_vocab(vocab)
        links = vocab_links_table.select { |vocab_link| vocab_link[:"PC Index"] == vocab[:"PC Index"] }

        links.sort_by { |link| link[:Sequence].to_i }
      end

      def vocab_for_vocab_link(vocab_link)
        vocab_table.detect { |vocab| vocab[:"PC Index"] == vocab_link[:"eBrain Index"] }
      end
    end
  end
end
