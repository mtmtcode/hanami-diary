module Web
  module Controllers
    module Entries
      class Update
        include Web::Action

        params do
          required(:id).filled(:int?)
          optional(:date).filled(:date?)
          optional(:title).filled(:str?)
          optional(:body).filled(:str?)

          rule(not_empty: [:date, :title, :body]) do |date, title, body|
            date.filled? | title.filled? | body.filled?
          end
        end

        def call(params)
          unless params.valid?
            self.body = JSON.dump(params.error_messages)
            self.status = 422
            return
          end

          repository = EntryRepository.new
          id = params[:id]
          unless repository.find(id)
            self.status = 404
          end

          self.body = EntryRepository.new.update(id, params)
        end
      end
    end
  end
end
