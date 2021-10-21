require "date"

module Web
  module Controllers
    module Entries
      class Index
        include Web::Action

        PAGE_LIMIT = 50

        params do
          optional(:page).filled(:int?, gteq?: 1)
          optional(:year).filled(:int?)
          optional(:month).filled(:int?)
        end

        def call(params)
          unless params.valid?
            self.body = JSON.dump(params.error_messages)
            self.status = 422
            return
          end

          limit = PAGE_LIMIT
          page = params[:page] || 1
          if params[:year] && params[:month]
            year = params[:year]
            month = params[:month]
            entries = EntryRepository.new.list_by_desc_date(year: year, month: month, limit: limit, page: page)
          else
            entries = EntryRepository.new.list_by_desc_date(limit: limit, page: page)
          end
          self.body = JSON.dump(entries.map(&:to_hash))
        end
      end
    end
  end
end
