module Web
  module Controllers
    module Templates
      class Create
        include Web::Action

        params do
          optional(:title).filled(:str?)
          optional(:body).filled(:str?)

          rule(empty_params: [:title, :body]) do |title, body|
            title.filled? | body.filled?
          end
        end

        def call(params)
          unless params.valid?
            self.status = 422
            return
          end
          created = TemplateRepository.new.create(params)
          self.body = JSON.dump(created.to_h)
          self.status = 201
        end
      end
    end
  end
end
