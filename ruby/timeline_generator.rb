require "rubygems"
require "twitter"

module Howduino

  USERNAME = File.open("secret", "r"){ |f| f.readlines[0].chop }
  PASSWORD = File.open("secret", "r"){ |f| f.readlines[1].chop }

  Tweet = Struct.new(:time, :id)

  class TwitterTimeline
    def generate_timeline(id)
      timeline = []
      @result.each do |r|
        time = Time.parse(r.created_at)
        seconds = time.tv_sec - @timeline_start
        timeline << Tweet.new(seconds, id)
      end
      timeline
    end
  end

  class TwitterSearchTimeline < TwitterTimeline
    RESULTS_PER_PAGE = 100
    PAGES = 5
    
    def initialize(search_text, timeline_start)
      @search_text, @timeline_start = search_text, timeline_start
      @result = []
      (1..PAGES).each do |page|
        @result += query_twitter(@search_text, page).results
      end
    end

    def query_twitter(search_text, page)
      @query = Twitter::Search.new(search_text)
      @query.per_page(RESULTS_PER_PAGE)
      @query.page(page)
      @query.fetch
    end
  end

  class TwitterUserTimeline < TwitterTimeline
    def initialize(user, timeline_start)
      @user, @timeline_start = user, timeline_start
      @result = query_twitter(@user)
    end

    def query_twitter(user)
      httpauth = Twitter::HTTPAuth.new(USERNAME, PASSWORD)
      base = Twitter::Base.new(httpauth)
      base.user_timeline(user)
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
    # the timeline so that each ID has an equal number, hence deleted_tweets.)
    def equalize_timeline
      new_starting_time = 0
      total_initial_tweets = @timeline.length
      last_id = @ids.last
      deleted_tweets = Hash.new
      @timeline.reverse.each do |tweet|
        if (tweet.id == last_id)
          new_starting_time = tweet.time
        else
          deleted_tweets[tweet.id] ||= 0
          deleted_tweets[tweet.id] += 1
        end
      end
      @timeline.delete_if{|tweet| tweet.time < new_starting_time }
#       puts "Initial Tweets: ", total_initial_tweets
#       puts "Deleted Tweets: ", deleted_tweets[0]
#       puts "Eventual Tweets: ", @timeline.length
    end

    def save(filename)
      sort_timeline
      equalize_timeline
      normalize_timeline

      metadata = []
      metadata << Time.now.to_s
      @racers.each_with_index{|racer, i| metadata << "#{i}:#{racer}"}

      File.open(filename, "w") do |f|
        f.puts(metadata.join(","))
        @timeline.each do |tweet|
          f.puts("#{tweet.time} #{tweet.id}")
        end
      end
    end
  end

  class TwitterSearchRace < TwitterRace
    def initialize(search_texts)
      @racers = search_texts
      @ids = []
      @timeline = []
      search_texts.each_with_index do |text, i|
        search_timeline = TwitterSearchTimeline.new(text, TIMELINE_START)
        @timeline += search_timeline.generate_timeline(i)
        @ids << i
      end
    end
  end

  class TwitterUserRace < TwitterRace
    def initialize(users)
      @racers = users
      @ids = []
      @timeline = []
      users.each_with_index do |text, i|
        user_timeline = TwitterUserTimeline.new(text, TIMELINE_START)
        @timeline += user_timeline.generate_timeline(i)
        @ids << i
      end
    end
  end

  def search_race(search_texts, filename=nil)
    search_race = TwitterSearchRace.new(search_texts)
    filename ||= generate_filename(search_texts)
    search_race.save(filename)
  end

  def user_race(users, filename=nil)
    user_race = TwitterUserRace.new(users)
    filename ||= generate_filename(users)
    user_race.save(filename)
  end

  def generate_filename(terms)
    timestamp = Time.now.strftime("%Y%m%d%H%M")
    filename = terms.join("_vs_").gsub(" ", "_") + "_" + timestamp + ".txt"
    File.join("timelines", filename)
  end

  module_function :search_race, :user_race, :generate_filename
  
end

if __FILE__ == $0
  Howduino::search_race(ARGV[0..1])
end
