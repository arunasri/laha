namespace :shows do
  def l(msg)
    Rails.logger.info(msg)
    puts(msg)
  end

  desc "create wikipages database from database"
  task :telugu => :environment do
    reg = /\((.*)\)/
    WikiPage.telugu.each do | page |
      page.document.css("#outer3 table tr td a").each do | movie |
        begin
          movie_name = movie.children[0].text
          date = reg.match(movie.children[1].text)[1]
          date.gsub!(" 00, "," 01, ")
          year = date.split(",")[1].try(:to_i)

          begin
            date = date.to_date
          rescue
            date = nil
          end

          Show.create(:name => movie_name, :language => 'telugu', :started_on => date, :year => year)
          l "creating #{movie_name}"
        rescue
          l "failed after #{Show.last.try(:name)}"
        end
      end
    end
  end

  task :hindi => :environment do
    WikiPage.hindi.each do | page |
      year = /\d+/.match(page.url)[0]
      page.document.css(".wikitable").each do | table |
        title_index = nil
        genre_index = nil
        dir_index = nil
        cast_index = nil
        thcount = nil
        month = nil
        day = nil
        offset = 0

        next if table.attributes["class"].value.split(" ").include?("sortable")
        first = true
        table.css("tr").each do | movie |

          if first
            first = false
            i = 0
            movie.css("th").each do | td |
              case td.text.downcase
              when /title/:
                title_index = i
              when /genre/:
                genre_index = i
              when /director/:
                dir_index = i
              when /cast/:
                cast_index = i
              end
              i = i + 1
            end
            thcount = i
            next
          end

          options = { :language => page.language, :year => year }
          tdcount = movie.css("td").size


          if thcount + 1 == tdcount
            offset = -1
            month = movie.css("td")[0].text.gsub("\n",'')
            day = movie.css("td")[1].text.gsub(/\/n/,'')
          elsif thcount == tdcount
            offset = 0
            day = movie.css("td")[0].text.gsub(/\/n/,'')
          elsif thcount - 1 == tdcount
            offset = 1
          end

          begin
            released = Date.parse("#{month} #{day}, #{year}")
          rescue
            released = nil
          end

          options.update(:started_on => released)

          if title_index && title = movie.css("td")[title_index - offset]
            options.update( :name => title.text)
            if url = title.search("a")[0]
              wiki_url = url.attributes["href"].value
              options.update(:wiki_url => "http://en.wikipedia.org/#{wiki_url}")
            end
          else
            next
          end

          if genre_index && genre = movie.css("td")[genre_index - offset]
            options.update(:genre => genre.text)
          end

          if dir_index && dir  = movie.css("td")[dir_index - offset]
            options.update(:director => dir.text)
          end

          if cast_index && cast = movie.css("td")[cast_index - offset]
            options.update(:cast => cast.text)
          end


          l("creating show: #{title.text}")

          Show.create(options)
        end
      end
    end
  end
end
