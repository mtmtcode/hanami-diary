module Web
  module Controllers
    module Entries
      class Create
        include Web::Action

        params do
          required(:date).filled(:date?)
          optional(:title).filled(:str?)
          required(:body).filled(:str?)
        end

        def call(params)
          unless params.valid?
            self.body = JSON.dump(params.error_messages)
            self.status = 422
            return
          end

          date = params[:date]
          title = params[:title]
          body = params[:body]

          created = EntryRepository.new.create(date: date, title: title, body: body)

          self.body = JSON.dump(created.to_hash)
          self.headers.merge!({ "Location" => routes.entry_url(id: 1) })
          self.status = 201
        end
      end
    end
  end
end
