module Web
  module Controllers
    module Entries
      class Delete
        include Web::Action

        def call(params)
          deleted = EntryRepository.new.delete(params[:id])
          unless deleted
            self.status = 404
            return
          end
          self.status = 204
        end
      end
    end
  end
end
