require "rubygems"
require "twitter"

module Howduino

  Tweet = Struct.new(:time, :id)

  class TwitterTimeline
    def generate_timeline(id)
      timeline = []
      @result.results.each do |r|
        time = Time.parse(r.created_at)
        seconds = time.tv_sec - @timeline_start
        timeline << Tweet.new(seconds, id)
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
    
    # Subtract the earliest time from all subsequent times
    def normalize_timeline
      earliest_tweet_time = @timeline.first.time
      @timeline.map! do |tweet|
        Tweet.new(tweet.time - earliest_tweet_time, tweet.id)
      end
    end

    # Sort times in ascending order
    def sort_timeline
      @timeline.sort! do |a, b|
        a.time <=> b.time
      end
    end

    # The first id will have a head start as it was queried earlier,
    # therefore we delete all Tweets before the first appearance of the
    # last id. (I also think I'll have to delete Tweets from the end of
    # the timeline so that each ID has an equal number, hence deleted_id_count.)
    def equalize_timeline
      last_id = @ids.last
      deleted_id_count = Hash.new
      until (id = @timeline.shift.id) == last_id
        deleted_id_count[id] ||= 0
        deleted_id_count[id] += 1
      end
    end

    def save(filename)
      sort_timeline
      equalize_timeline
      normalize_timeline
      File.open(filename, "w") do |f|
        @timeline.each do |tweet|
          f.puts("#{tweet.time} #{tweet.id}")
        end
      end
    end
  end

  class TwitterSearchRace < TwitterRace
    def initialize(search_texts)
      @ids = []
      @timeline = []
      search_texts.each_with_index do |text, i|
        search_timeline = TwitterSearchTimeline.new(text, TIMELINE_START)
        @timeline += search_timeline.generate_timeline(i)
        @ids << i
      end
    end
  end

  def search_race(search_texts, filename)
    search_race = TwitterSearchRace.new(search_texts)
    search_race.save(filename)
  end
  module_function :search_race
  
end

if __FILE__ == $0
  Howduino::search_race(["Angels & Demons", "Star Trek"],
                        File.join("timelines", "angels_vs_startrek.txt"))
end
