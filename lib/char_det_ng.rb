# frozen_string_literal: true

require_relative "char_det_ng/version"
require_relative "char_det_ng/char_det_ng"

module CharDetNg
  class EncodingDetector
    BUFFER_SIZE = 1024 * 1024

    def self.guess_and_assess_file(path, allow_utf8: true)
      File.open(path, mode: "rb") do |f|
        guess_and_assess_io(f, allow_utf8:)
      end
    end

    def self.guess_and_assess_io(io, allow_utf8: true)
      detector = new
      buffer = String.new(encoding: Encoding::ASCII_8BIT, capacity: BUFFER_SIZE)

      loop do
        out = io.read(nil, buffer)

        # The docs claim that IO#read returns nil at EOF, but experiments
        # with ruby 3.3.5 show that it returns the empty string.
        break if out.nil? || out.empty?

        detector.feed(out)
      end

      detector.guess_and_assess(allow_utf8:)
    end

    def initialize
      @impl = Internal::EncodingDetector.new
    end

    def feed(data)
      @impl.feed(data, false)
    end

    alias << feed

    def guess_and_assess(tld: nil, allow_utf8: true)
      @impl.guess_assess(tld, allow_utf8)
    end

    def guess(tld: nil, allow_utf8: true)
      enc, _reliable = guess_and_assess(tld:, allow_utf8:)
      enc
    end
  end
end
