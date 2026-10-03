class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil? || letter !~ /\A[a-z]\z/i
      raise ArgumentError
    end

    letter = letter.downcase

    if @guesses.include?(letter) or @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end

  end

  def word_with_guesses()
    ans = ''
    @word.each_char do |char|
      if @guesses.include?(char)
        ans += char
      else
        ans += '-'
      end
    end
    ans
  end

  def check_win_or_lose()
    if word_with_guesses == @word
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
