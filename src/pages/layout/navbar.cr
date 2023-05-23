module GeopJr
  alias Route = Hash(String, {title: String, page: String, file: String, description: String, style: Array(String), script: Array(String)?})

  class Layout::Navbar
    def initialize(@active_link : String, @routes : Route = ROUTES)
    end

    ECR.def_to_s "#{__DIR__}/navbar.ecr"
  end
end
