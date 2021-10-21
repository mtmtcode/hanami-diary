RSpec.describe Web::Controllers::Entries::Create, type: :action do
  let(:action) { described_class.new }
  let(:repository) { EntryRepository.new }

  before do
    repository.clear
  end

  context "with valid params" do
    let(:params) { Hash[date: "2021-10-15", title: "test title", body: "test body"] }

    it "returns 201" do
      response = action.call(params)
      expect(response[0]).to eq 201
    end

    it "creates a new entry" do
      response = action.call(params)

      entry = repository.last
      expect(entry.date.iso8601).to eq(params.dig(:date))
      expect(entry.title).to eq(params.dig(:title))
      expect(entry.body).to eq(params.dig(:body))
    end

    it "returns created entry" do
      response = action.call(params)

      res_body = JSON.load(response[2][0])
      created = repository.last
      expect(res_body["id"]).to eq(created.id)
      expect(res_body["date"]).to eq(created.date.iso8601)
      expect(res_body["title"]).to eq(created.title)
      expect(res_body["body"]).to eq(created.body)
    end

    it "returns the URL of the created entry via Location header" do
      response = action.call(params)
      expect(response[1]["Location"]).to match(%r{/entries/\d+\z})
    end
  end

  context "with invalid params" do
    let(:params) { Hash[date: "abc", body: ""] }

    it "returns 422" do
      response = action.call(params)
      expect(response[0]).to eq 422
    end
  end
end
