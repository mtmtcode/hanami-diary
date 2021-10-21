RSpec.describe Web::Controllers::Entries::Delete, type: :action do
  let(:action) { described_class.new }
  let(:repository) { EntryRepository.new }
  let(:entry) { repository.create(date: "2021-10-01", body: "test entry") }

  before do
    repository.clear
  end

  context "with valid id" do
    let(:params) { Hash[id: entry.id] }

    it "is successful" do
      response = action.call(params)
      expect(response[0]).to eq 204
    end

    it "deletes the entry" do
      action.call(params)
      expect(repository.find(entry.id)).to be_nil
    end
  end

  context "with invalid id" do
    let(:params) { Hash[id: entry.id + 1] }

    it "returns 404" do
      response = action.call(params)
      expect(response[0]).to eq(404)
    end
  end
end
