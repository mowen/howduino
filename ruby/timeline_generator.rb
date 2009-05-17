require "twitter"

module Howduino

  Tweet = Struct.new(:time, :id)

  class TwitterTimeline
    def generate_timeline
      timeline = []
      @result.results.each do |r|
        time = Time.parse(r.created_at)
        seconds = time.tv_sec - @timeline_start
        timeline << Tweet.new(seconds, @search_text)
      end
      timeline
    end
  end

  class TwitterSearchTimeline < TwitterTimeline    
    RESULTS_PER_PAGE = 100
    
    def initialize(search_text, timeline_start)
      @search_text, @timeline_start = search_text, timeline_start
      @result = query_twitter(@search_text)
    end

    def query_twitter(search_text)
      @query = Twitter::Search.new(search_text)
      @query.per_page(RESULTS_PER_PAGE)
      @query.fetch
    end
  end

  class TwitterRace
    TIMELINE_START = Time.parse("2009/05/15 00:00:00").tv_sec

    def sort_timeline
      @timeline.sort! do |a, b|
        a.time <=> b.time 
      end
    end

    def save(filename)
      filename ||= @ids.join("_").gsub(" ", "_") + ".txt"
      File.open(filename, "w") do |f|
        @timeline.each do |tweet|
          f.puts("#{tweet.time} #{tweet.id}")
        end
      end
    end
  end

  class TwitterSearchRace < TwitterRace
    def initialize(search_texts)
      @ids = search_texts
      @timeline = []
      search_texts.each do |text|
        search_timeline = TwitterSearchTimeline.new(text, TIMELINE_START)
        @timeline += search_timeline.generate_timeline
      end
      sort_timeline
    end
  end

end

if __FILE__ == $0
  search_race = Howduino::TwitterSearchRace.new(["Angels & Demons", "Star Trek"])
  search_race.save(File.join("timelines", "angels_vs_startrek.txt"))
end
