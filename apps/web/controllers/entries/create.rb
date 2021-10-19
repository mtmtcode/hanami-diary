module Web
  module Controllers
    module Entries
      class Create
        include Web::Action

        params do
          required(:date).filled(:str?, format?: /\A\d{4}-\d{2}-\d{2}\z/)
          optional(:title).filled
          required(:body).filled(:str?)
        end

        def call(params)
          halt(422) unless params.valid?

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
