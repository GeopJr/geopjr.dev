module GeopJr
    class Page::NotFound
      def initialize
      end
  
      ECR.def_to_s "#{__DIR__}/404.ecr"
    end
  end
  