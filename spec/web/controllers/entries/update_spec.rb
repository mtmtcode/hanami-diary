RSpec.describe Web::Controllers::Entries::Update, type: :action do
  let(:action) { described_class.new }
  let(:repository) { EntryRepository.new }
  let(:entry) { repository.create(date: "2021-10-01", body: "test entry") }
  let(:params) { Hash[] }

  before do
    repository.clear
  end

  context "with valid params" do
    let(:params) { Hash[id: entry.id, body: "updated!"] }

    it "is successful" do
      response = action.call(params)
      expect(response[0]).to eq 200
    end

    it "updates the entry" do
      action.call(params)
      updated = repository.find(entry.id)
      expect(updated.body).to eq(params[:body])
    end
  end

  context "when no entry with specified id found" do
    let(:params) { Hash[id: entry.id + 1, body: "updated!"] }

    it "returns 404" do
      response = action.call(params)
      expect(response[0]).to eq(404)
    end
  end

  context "when no field specfied" do
    let(:params) { Hash[id: entry.id] }

    it "returns 422" do
      response = action.call(params)
      expect(response[0]).to eq(422)
    end
  end

  context "with invalid date" do
    let(:params) { Hash[id: entry.id, date: "2021-13-01"] }

    it "returns 422" do
      response = action.call(params)
      expect(response[0]).to eq(422)
    end
  end
end
