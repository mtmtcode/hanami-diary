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

      created = JSON.load(response[2][0])
      expect(created["id"]).to_not be_nil
      expect(created["date"]).to eq(params.dig(:date))
      expect(created["title"]).to eq(params.dig(:title))
      expect(created["body"]).to eq(params.dig(:body))
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

    it "sets params to validation errors" do
      action.call(params)
      expect(action.params.errors).to_not be_nil
    end
  end
end
