require 'timeout'
module Sonice
  class Player
    MUSIC_PLAYERS = []

    def name
      self.class.to_s.gsub(/^Sonice::|Player$/, '')
    end

    def host
      %x(hostname).strip
    end

    [:launched?, :playpause, :next, :prev,
      :voldown, :volup, :volume,
      :track, :artist, :album
    ].each do |method|
      define_method method do
        raise NotImplementedError, "this player needs a #{method} method"
      end
    end

    def self.inherited(k)
      MUSIC_PLAYERS.push k.new
    end

    def self.launched
      MUSIC_PLAYERS.find { |player|
        puts "Trying #{player.name}..."
        begin
          Timeout::timeout(5) { player.launched? }
        rescue
          puts "Timed out"
          nil
        end
      }
    end
  end

end

