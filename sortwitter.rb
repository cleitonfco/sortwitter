#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'json/pure'

class SortTwitter
  def initialize
    @twittes = []
  end

  def init
    call "http://search.twitter.com/search.json?rpp=100&q=%23promoegenial"
    puts "Quantidade de Twittes: #{@twittes.size}\n\n"
  end

  def call(url)
    return false unless url
    begin
      req = Net::HTTP.get_response(URI.parse(url))
      res = JSON.parse(req.body)
    rescue JSON::ParserError => e
      raise "Dados corrompidos. Problemas para tratar o JSON. Tente novamente!"
    rescue => e
      raise "Problema para obter os dados do Twitter."
    else
      if res["results"]
        res["results"].each { |r| @twittes << r }
        if res["next_page"]
          call("http://search.twitter.com/search.json#{res["next_page"]}")
        end
      end
    end
  end

  def sort
    @winner = @twittes[rand(@twittes.size)]
    if @winner["from_user"] == "egenial"
      sort
    else
      puts "O Ganhador é #{@winner["from_user"]} com o twitte http://twitter.com/#{@winner["from_user"]}/status/#{@winner["id"]}"
    end
  end
end

sorteio = SortTwitter.new
sorteio.init
sorteio.sort
