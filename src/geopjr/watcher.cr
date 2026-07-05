module GeopJr::Watcher
  extend self

  # Starts serving in a separate thread
  private def serve
    Fiber::ExecutionContext::Concurrent.new("server").spawn do
      GeopJr::Server.serve
    end
  end

  private def reload_blog(event : FileWatcher::Event)
    if event.type.deleted? # when a blog file is deleted
      found_blog = GeopJr::GENERATOR.@blog_posts.index { |x| x.filename == Path[event.path].basename(".md") }
      if found_blog
        # find the blog pagination page it belongs to
        pagination_page_no = found_blog.tdiv(GeopJr::CONFIG.max_posts_per_page) + 1
        # reload the pagination page, the actual blog post (so it 404s)
        pages_to_reload = [
          "/blog/#{GeopJr::GENERATOR.@blog_posts[found_blog].filename}",
          "/blog/#{pagination_page_no}",
        ]
        # and the main blog pagination if it's the first one
        pages_to_reload << "/blog/" if pagination_page_no == 1

        # remove it and re-write all pagination pages
        GeopJr::GENERATOR.@blog_posts.delete_at(found_blog)
        pages = GeopJr::BlogPagination.new(GeopJr::GENERATOR.@blog_posts)
        pages.write

        GeopJr::Server.request_reload(pages_to_reload)
      end
    else # when a blog file is either modified or created
      if event.type.added?
        return unless File.read(event.path).includes?("title")
      end

      # generate it
      entry = GeopJr::Blog.generate_blog_post(Path[event.path])
      unless entry.nil?
        GeopJr::Blog.write_blog_post(entry)
        found_blog = GeopJr::GENERATOR.@blog_posts.index { |x| x.filename == entry.filename }

        pagination = nil
        if found_blog.nil? # if it's a new blog post / added
           # add it in the front and regenerate just the first pagination page
          GeopJr::GENERATOR.@blog_posts.unshift(entry)
          pagination = GeopJr::BlogPagination.new(GeopJr::GENERATOR.@blog_posts)
          pagination.main.write
          pagination.write_page_including_entry(entry) # aka the first page

          GeopJr::Server.request_reload(["/blog/", "/blog/1"])
        else # if it's modified
          # update it and regenerate its pagination page
          GeopJr::GENERATOR.@blog_posts[found_blog] = entry
          pagination = GeopJr::BlogPagination.new(GeopJr::GENERATOR.@blog_posts)
          pagination.write_page_including_entry(entry)

          pages_to_reload = ["/blog/#{entry.filename}"]
          if !(page = pagination.page_of(entry)).nil?
            pages_to_reload << "/blog/#{page.@page}"
            pages_to_reload << "/blog/" if page.@page == 1
          end

          GeopJr::Server.request_reload(pages_to_reload)
        end
      end
    end
  end

  def watch
    serve

    FileWatcher.watch(
      GeopJr::CONFIG.paths[:icons] / "*",
      "#{__DIR__}/scss/**/*.scss",
      GeopJr::CONFIG.paths[:static] / "**" / "*",
      Path["blog"] / "*.md",
      Path["data"] / "*.yaml"
    ) do |event|
      case event.path
      when .starts_with?("#{__DIR__}/scss/")
        GeopJr::Tools.new(true, false, false).sass
        GeopJr::Server.request_reload
      when .starts_with?(GeopJr::CONFIG.paths[:icons].to_s)
        GeopJr::GENERATOR.spritesheets
        GeopJr::Server.request_reload
      when .starts_with?(Path["blog"].to_s)
        puts "🐱 Updating blog posts"
        reload_blog(event)
        puts "🐱 Updated blog posts"
      when .starts_with?(Path["data"].to_s)
        puts "🐱 Updating data"
        GeopJr::CONFIG.update_data
        case Path[event.path].basename(".yaml")
        when "about", "colors", "footer"
          GeopJr::Page::Home.new.write
          GeopJr::Server.request_reload("/")
        when "brands"
          GeopJr::Page::Donate.new.write
          GeopJr::Page::Contact.new.write
          GeopJr::Server.request_reload([{"donate", true}, {"contact", true}])
        when "contact"
          GeopJr::Page::Contact.new.write
          GeopJr::Server.request_reload({"contact", true})
        when "dict"
          GeopJr::Page::Home.new.write
          GeopJr::Page::Donate.new.write
          GeopJr::Page::Contact.new.write
          GeopJr::Server.request_reload([{"donate", true}, {"contact", true}, "/"])
        when "donate"
          GeopJr::Page::Donate.new.write
          GeopJr::Server.request_reload({"donate", true})
        when "icon_names"
          GeopJr::BlogPagination.new(GeopJr::GENERATOR.@blog_posts).write
          GeopJr::Server.request_reload({"blog", true})
        when "work"
          GeopJr::Page::Work.new.write
          GeopJr::Server.request_reload({"work", true})
        end
        puts "🐱 Updated data"
      when .starts_with?(GeopJr::CONFIG.paths[:static].to_s)
        GeopJr::GENERATOR.move_static_files
        GeopJr::GENERATOR.remove_underscores
        GeopJr::Server.request_reload
      end
    end
  end
end
