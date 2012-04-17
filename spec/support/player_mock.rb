RSpec.configuration.mock_player_count.each do |n|
  eval %(
    module PlayerMock#{n}
      def to_s
        "Mock Player"
      end
      def move
        [:rest]
      end
    end
  )
end